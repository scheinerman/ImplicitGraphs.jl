export iCycle, iPath, iGrid, iKnight, iCube

"""
`iCycle(n::Int)` creates an implicit graph that is
a cycle graph with `n` vertices `1` through `n`.
"""
function iCycle(n::Int)::ImplicitGraph{Int}
    if n < 3
        error("Number of vertices must be at least 3")
    end

    function N(v::Int)
        a = mod1(v + 1, n)
        b = mod1(v - 1, n)
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
    yes(v::Tuple{Int,Int})::Bool = true
    function N(v::Tuple{Int,Int})::Vector{Tuple{Int,Int}}
        a, b = v
        return [(a, b - 1), (a, b + 1), (a - 1, b), (a + 1, b)]
    end
    return ImplicitGraph{Tuple{Int,Int}}(yes, N)
end

"""
`iKnight()` returns the Knight's move graph on an infinite 
chessboard.
"""
function iKnight()::ImplicitGraph{Tuple{Int,Int}}
    yes(v::Tuple{Int,Int})::Bool = true
    function N(v::Tuple{Int,Int})::Vector{Tuple{Int,Int}}
        a, b = v
        neigh = [
            (a + 1, b + 2),
            (a + 1, b - 2),
            (a + 2, b + 1),
            (a + 2, b - 1),
            (a - 1, b + 2),
            (a - 1, b - 2),
            (a - 2, b + 1),
            (a - 2, b - 1),
        ]
        return neigh
    end
    return ImplicitGraph{Tuple{Int,Int}}(yes, N)
end

"""
`iCube(d::Int)` creates an (implict) `d`-dimensional cube graph.
"""
function iCube(d::Int)::ImplicitGraph{String}
    if d < 1
        error("Dimension must be positive")
    end

    function dvec_check(s::String)::Bool
        if length(s) != d
            return false
        end
        for i = 1:d
            if s[i] ∉ "01"
                return false
            end
        end
        return true
    end

    function N(v::String)
        result = Vector{String}(undef, d)
        for i = 1:d
            head = v[1:i-1]
            c = v[i] == '0' ? "1" : "0"
            tail = v[i+1:end]
            result[i] = head * c * tail
        end
        return result
    end

    return ImplicitGraph{String}(dvec_check, N)
end
