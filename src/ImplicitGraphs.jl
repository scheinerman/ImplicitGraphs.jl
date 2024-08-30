module ImplicitGraphs

using DataStructures

export ImplicitGraph

import Base: getindex, show, eltype
import SimpleGraphs: deg, find_path, dist, has
export deg, find_path, dist, has


"""
`ImplicitGraph{T}(has_vertex, out_neighbors)` constructs a new `ImplicitGraph`
whose vertices have type `T`. 
* `has_vertex(v::T)::Bool` is a function that checks if `v` is in the graph.
* `out_neighbors(v::T)::Vector{T}` is a function that takes an object `v` of
type `T` and returns a list of `v`'s out neighbors. 
"""
struct ImplicitGraph{T}
    has_vertex::Function
    out_neighbors::Function
end

function getindex(G::ImplicitGraph{T}, v::T) where {T}
    if !has(G, v)
        error("This graph does not have a vertex $v")
    end
    G.out_neighbors(v)
end

eltype(::ImplicitGraph{T}) where {T} = T

function getindex(G::ImplicitGraph{T}, v::T, w::T) where {T}
    if !has(G, v) || !has(G, w)
        error("One or both of vertices $v and $w are not in this graph")
    end
    return in(w, G[v])
end

has(G::ImplicitGraph{T}, v::T, w::T) where {T} = G[v, w]

"""
`deg(G::ImplicitGraph,v)` returns the degree of vertex `v`
in the graph `G`.
"""
deg(G::ImplicitGraph{T}, v::T) where {T} = length(G[v])


"""
`has(G::ImplicitGraph,v)` checks if `v` is a vertex of `G`.

`has(G,v,w)` checks if `(v,w)` is an edge of `G`.
"""
function has(G::ImplicitGraph{T}, v::T) where {T}
    return G.has_vertex(v)
end

function show(io::IO, G::ImplicitGraph{T}) where {T}
    print(io, "ImplicitGraph{$T}")
end

include("iGraphs.jl")
include("find_path.jl")
include("guided_path_finder.jl")

end # module
