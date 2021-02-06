export find_path, dist

"""
`find_path(G::ImplicitGraph,s,t)` finds a shortest path from `s` to `t`. 
"""
function find_path(G::ImplicitGraph{T}, s::T, t::T) where {T}

    if !has(G, s) || !has(G, t)
        error("Source and/or target vertex is not in this graph")
    end
    if s == t
        return [s]
    end

    # set up a queue for vertex exploration
    Q = Queue{T}()
    enqueue!(Q, s)

    # set up trace-back dictionary
    tracer = Dict{T,T}()
    tracer[s] = s

    while length(Q) > 0
        v = dequeue!(Q)
        Nv = G[v]
        for w in Nv
            if haskey(tracer, w)
                continue
            end
            tracer[w] = v
            enqueue!(Q, w)

            if w == t  # success!
                path = Array{T}(undef, 1)
                path[1] = t
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

dist(G::ImplicitGraph{T}, s::T, t::T) where {T} = length(find_path(G, s, t)) - 1
