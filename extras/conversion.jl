using SimpleGraphs, ImplicitGraphs

import SimpleGraphs: UndirectedGraph, DirectedGraph


"""
    UndirectedGraph(G::ImplicitGraph{T}, A) where {T}

returns the induced `UndirectedGraph` 
of `G` with vertices in the collection `A`.
"""
function UndirectedGraph(G::ImplicitGraph{T}, A) where {T}
    H = UG{T}()
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
    DirectedGraph(G::ImplicitGraph{T}, A) where {T}

Returns the induced `DirectedGraph` 
of `G` with vertices in the collection `A`.
"""
function DirectedGraph(G::ImplicitGraph{T}, A) where {T}
    D = DG{T}()
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
