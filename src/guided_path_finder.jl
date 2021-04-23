export guided_path_finder

function _edge_generator(G::ImplicitGraph{T}, v::T, depth::Int = 1) where {T}
    @assert depth > 0 "Depth must be positive, argument was $depth"

    if depth == 1
        return [(v, w) for w in G[v]]
    end

    edges = _edge_generator(G, v, depth - 1)
    result = Tuple{T,T}[]

    visited = Set(first.(edges)) ∪ Set(last.(edges))
    for (x, y) in edges
        push!(result, (x, y))   # keep this edge 
        for z in G[y]
            if z ∉ visited
                push!(result, (y, z))
            end
        end
    end
    return unique(result)
end

"""
    guided_path_finder(G, s, t; score, depth)

Find a path from vertex `s` to vertex `t` in an `ImplicitGraph` `G`.

* `score` is a function mapping vertices to `Int` values. It should decrease 
   as vertices get closer to `t`. Ideally, `score(t)` should be the smallest 
   possible value.

* `depth` controls the amount of look ahead as we explore each vertex. The default value is `1`.
"""
function guided_path_finder(
    G::ImplicitGraph{T},
    s::T,
    t::T;
    score::Function = x -> 1,
    depth::Int = 1,
)::Vector{T} where {T}


    PQ = PriorityQueue{T,Int}()
    PQ[s] = score(s)

    visited = Set{T}()               # Visited  positions
    trace_back = Dict{T,T}()         # Reverse edges 
    trace_back[s] = s

    if s == t
        return [t]
    end

    while length(PQ) > 0
        v = dequeue!(PQ)
        if v == t
            break
        end
        push!(visited, v)

        edges = _edge_generator(G, v, depth)

        for (x, y) in edges
            if y ∉ keys(trace_back)
                trace_back[y] = x
                PQ[y] = score(y)
            end
        end
    end

    rev_path = T[]
    push!(rev_path, t)

    while true
        x = rev_path[end]
        if x == s
            break
        end
        push!(rev_path, trace_back[x])
    end

    return reverse(rev_path)
end
