export iCycle, iPath

"""
`iCycle(n::Int)` creates an implicit graph that is
a cycle graph with `n` vertices `1` through `n`.
"""
function iCycle(n::Int)
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

    return ImplicitGraph{Int}(N, has_vertex)
end

"""
`iPath(n::Int)` creates an implicit graph that is
a path graph with `n` vertices `1` through `n`.

`iPath()` creates an implicit graph that is 
a path graph on the integers.
"""
function iPath(n::Int)
    if n < 1
        error("Number of vertices must be at least 1")
    end

    function N(v::Int)
        if v == 1
            return [2]
        end
        if v == n
            return [n - 1]
        end
        return [v - 1, v + 1]
    end

    has_vertex(v::Int) = 1 <= v <= n

    return ImplicitGraph{Int}(N, has_vertex)
end


function iPath()
    N(v::Int) = [v-1, v+1]
    return ImplicitGraph{Int}(N, x::Int -> true)
end