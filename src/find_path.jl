export find_path, find_path_undirected, dist

"""
`find_path(G::ImplicitGraph{T}, s::T, is_target::Function, cutoff_depth::Int=0) where {T}`

Finds a shortest path from `s` to any vertex for which `is_target`
returns `true`.
Optionally, we include a `cutoff_depth` at which the search stops, to
avoid exponential memory usage.
"""
function find_path(G::ImplicitGraph{T}, s::T, is_target::Function, cutoff_depth::Int=0) where {T}
    if is_target(s)
        return [s]
    end

    # set up an array for vertex exploration
    frontier = Array{T}(undef, 1)
    frontier[1] = s

    # the current search depth
    depth = 0

    # set up trace-back dictionary
    tracer = Dict{T,T}()
    tracer[s] = s

    while length(frontier) > 0
        # Check whether to abort
        if (cutoff_depth != 0) && (depth == cutoff_depth)
            break
        end

        # Move frontier forward
        depth += 1
        frontier = advance_frontier(G, is_target, frontier, tracer)

        # Traceback and return if successful
        if typeof(frontier) == T
            return reverse(traceback_path(tracer, s, frontier))
        end
    end
    return T[]   # return empty array if no path found
end

"""
`advance_frontier(G::ImplicitGraph{T}, is_target::Function, frontier::Array{T}, tracer::Dict{T, T}) where {T}`

Advances the vertex frontier by one step. In other words, if all vertices in `frontier` are
at depth `d`, then the returned frontier will contain all vertices of depth `d+1`.

If a vertex `v` is found such that `is_target` returns `true`, then abort search and return
`v` instead. The return type may thus be one of
 - T[]: the new frontier of depth `d+1`
 - T: a vertex satisfying `is_target`

This will mutate `tracer`, inserting all the new vertices found.
"""
function advance_frontier(G::ImplicitGraph{T}, is_target::Function, frontier::Array{T}, tracer::Dict{T, T}) where {T}
    new_frontier = T[]
    for v in frontier
        Nv = G[v]

        for w in Nv
            if haskey(tracer, w)
                continue
            end
            tracer[w] = v
            push!(new_frontier, w)

            if is_target(w)  # success!
                return w
            end
        end
    end
    new_frontier
end

"""
`traceback_path(tracer::Dict{T, T}, s::T, t::T) where {T}`

Traces back path from source `s` to target `t` using the tracer dictionary.
The path is returned in reversed order
"""
function traceback_path(tracer::Dict{T, T}, s::T, t::T) where {T}
    rev_path = Array{T}(undef, 1)
    rev_path[1] = t
    while rev_path[end] != s
        v = tracer[rev_path[end]]
        push!(rev_path, v)
    end
    rev_path
end

"""
`find_path(G::ImplicitGraph,s,t)` finds a shortest path from `s` to `t`.
"""
function find_path(G::ImplicitGraph{T}, s::T, t::T, cutoff_depth::Int=0) where {T}

    if !has(G, s) || !has(G, t)
        error("Source and/or target vertex is not in this graph")
    end

    find_path(G, s, isequal(t), cutoff_depth)
end

"""
`find_path_undirected(G::ImplicitGraph,s,t)`.

Finds a shortest path from `s` to `t`, assuming that `G` is undirected.
This will proceed from both ends of the path until finding a common vertex.
"""
function find_path_undirected(G::ImplicitGraph{T}, s::T, t::T, cutoff_depth::Int=0) where {T}

    if !has(G, s) || !has(G, t)
        error("Source and/or target vertex is not in this graph")
    end

    if s == t
        return [s]
    end

    # set up two arrays for vertex exploration
    # one frontier will proceed from the source, the other from the target
    frontier_s = Array{T}(undef, 1)
    frontier_s[1] = s
    frontier_t = Array{T}(undef, 1)
    frontier_t[1] = t

    # the current search path depth (for both search directions)
    depth = 0

    # set up a trace-back dictionaries
    tracer_s = Dict{T,T}()
    tracer_s[s] = s
    tracer_t = Dict{T,T}()
    tracer_t[t] = t

    while length(frontier_s) + length(frontier_t) > 0
        # Check whether to abort
        if (cutoff_depth != 0) && (depth == cutoff_depth)
            break
        end

        # target vertex: a vertex present in the tracer for the other direction
        is_target_s = v -> haskey(tracer_t, v)
        is_target_t = v -> haskey(tracer_s, v)

        # Move frontier forward in both directions
        depth += 1

        # Forward move
        frontier_s = advance_frontier(G, is_target_s, frontier_s, tracer_s)
        # Traceback and return if successful
        if typeof(frontier_s) == T
            s_to_middle = reverse(traceback_path(tracer_s, s, frontier_s))
            middle_to_t = traceback_path(tracer_t, t, frontier_s)
            return [s_to_middle[1:end-1]; middle_to_t]
        end

        # Backward move
        frontier_t = advance_frontier(G, is_target_t, frontier_t, tracer_t)
        # Traceback and return if successful
        if typeof(frontier_t) == T
            s_to_middle = reverse(traceback_path(tracer_s, s, frontier_t))
            middle_to_t = traceback_path(tracer_t, t, frontier_t)
            return [s_to_middle[1:end-1]; middle_to_t]
        end

    end
    return T[]   # return empty array if no path found
end

dist(G::ImplicitGraph{T}, s::T, t::T) where {T} = length(find_path(G, s, t)) - 1
