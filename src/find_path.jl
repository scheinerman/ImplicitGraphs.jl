export find_path, dist

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

    # set up a queue for vertex exploration
    Q = Queue{Tuple{T, Int}}()
    enqueue!(Q, (s, 0))

    # set up trace-back dictionary
    tracer = Dict{T,T}()
    tracer[s] = s

    while length(Q) > 0
        v, l = dequeue!(Q)
        Nv = G[v]

        if (cutoff_depth != 0) && (l == cutoff_depth)
            continue
        end

        for w in Nv
            if haskey(tracer, w)
                continue
            end
            tracer[w] = v
            enqueue!(Q, (w, l + 1))

            if is_target(w)  # success!
                path = Array{T}(undef, 1)
                path[1] = w
                while path[1] != s
                    v = tracer[path[1]]
                    pushfirst!(path, v)
                end
                return path

            end
        end
    end
    return T[]   # return empty array if no path found
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

dist(G::ImplicitGraph{T}, s::T, t::T) where {T} = length(find_path(G, s, t)) - 1
