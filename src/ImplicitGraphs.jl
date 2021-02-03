module ImplicitGraphs

export ImplicitGraph, has_vertex

import Base: getindex, show

struct ImplicitGraph{T}
    N::Function
    has_vertex::Function
end

function getindex(G::ImplicitGraph{T}, v::T) where {T}
    if !G.has_vertex(v)
        error("This graph does not have a vertex $v")
    end
    G.N(v)
end

"""
`has_vertex(G::ImplicitGraph,v)` checks if `v` is a vertex of `G`.
"""
function has_vertex(G::ImplicitGraph{T}, v::T) where T 
    return G.has_vertex(v)
end 

function show(io::IO, G::ImplicitGraph{T}) where {T}
    print(io, "ImplicitGraph{$T}")
end

include("iGraphs.jl")

end # module
