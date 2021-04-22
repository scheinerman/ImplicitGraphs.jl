using SimpleGraphs, ImplicitGraphs

import SimpleGraphs: SimpleGraph, SimpleDigraph


"""
`SimpleGraph(G::ImplicitGraph,A)` returns the induced `SimpleGraph` 
of `G` with vertices in the collection `A`.
"""
function SimpleGraph(G::ImplicitGraph{T}, A) where {T}
    H = SimpleGraph{T}()
    for v in A
        if has(G, v)
            add!(H, v)
        end
    end
    for v in A
        for w in A
            if v != w && G[v, w]
                add!(H, v, w)
            end
        end
    end
    return H
end


"""
`SimpleDigraph(G::ImplicitGraph,A)` returns the induced `SimpleDigraph` 
of `G` with vertices in the collection `A`.
"""
function SimpleDigraph(G::ImplicitGraph{T}, A) where {T}
    D = SimpleDigraph{T}()
    for v in A
        if has(G, v)
            add!(D, v)
        end
    end

    for v in A
        for w in A
            if G[v, w]
                add!(D, v, w)
            end
        end
    end
    return D
end
