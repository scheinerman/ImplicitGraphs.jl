module ImplicitGraphs

using DataStructures

export ImplicitGraph, has_vertex, deg

import Base: getindex, show, eltype

struct ImplicitGraph{T}
    has_vertex::Function
    out_neighbors::Function
end

function getindex(G::ImplicitGraph{T}, v::T) where {T}
    if !has_vertex(G, v)
        error("This graph does not have a vertex $v")
    end
    G.out_neighbors(v)
end

eltype(G::ImplicitGraph{T}) where {T} = T

function getindex(G::ImplicitGraph{T}, v::T, w::T) where {T}
    if !has_vertex(G, v) || !has_vertex(G, w)
        error("One or both of vertices $v and $w are not in this graph")
    end
    return in(w, G[v])
end

"""
`deg(G::ImplicitGraph,v)` returns the degree of vertex `v`
in the graph `G`.
"""
deg(G::ImplicitGraph{T}, v::T) where {T} = length(G[v])


"""
`has_vertex(G::ImplicitGraph,v)` checks if `v` is a vertex of `G`.
"""
function has_vertex(G::ImplicitGraph{T}, v::T) where {T}
    return G.has_vertex(v)
end

function show(io::IO, G::ImplicitGraph{T}) where {T}
    print(io, "ImplicitGraph{$T}")
end

include("iGraphs.jl")
include("find_path.jl")

end # module
