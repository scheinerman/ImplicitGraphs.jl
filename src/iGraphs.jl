export iCycle, iPath, iGrid

"""
`iCycle(n::Int)` creates an implicit graph that is
a cycle graph with `n` vertices `1` through `n`.
"""
function iCycle(n::Int)::ImplicitGraph{Int}
    if n < 3
        error("Number of vertices must be at least 3")
    end

    function N(v::Int)
        a = mod(v + 1, n)
        b = mod(v - 1, n)
        a = a == 0 ? n : a
        b = b == 0 ? n : b
        return [b, a]
    end

    has_vertex(v::Int) = 1 <= v <= n

    return ImplicitGraph{Int}(has_vertex, N)
end

"""
`iPath(n::Int)` creates an implicit graph that is
a path graph with `n` vertices `1` through `n`.

`iPath()` creates an implicit graph that is 
a path graph on the integers.
"""
function iPath(n::Int)::ImplicitGraph{Int}
    if n < 1
        error("Number of vertices must be at least 1")
    end

    function N(v::Int)::Vector{Int}
        if v == 1
            return [2]
        end
        if v == n
            return [n - 1]
        end
        return [v - 1, v + 1]
    end

    has_vertex(v::Int)::Bool = 1 <= v <= n

    return ImplicitGraph{Int}(has_vertex, N)
end


function iPath()::ImplicitGraph{Int}
    N(v::Int)::Vector{Int} = [v - 1, v + 1]
    yes(v::Int)::Bool = true
    return ImplicitGraph{Int}(yes, N)
end


"""
`iGrid()` returns an infinite two-dimensional grid graph. Vertices are 
of type `Tuple{Int,Int}`.
"""
function iGrid()::ImplicitGraph{Tuple{Int,Int}}
    yes(v::Tuple{Int,Int}) = true
    function N(v::Tuple{Int,Int})::Vector{Tuple{Int,Int}}
        a, b = v
        return [(a, b - 1), (a, b + 1), (a - 1, b), (a + 1, b)]
    end
    return ImplicitGraph{Tuple{Int,Int}}(yes, N)
end