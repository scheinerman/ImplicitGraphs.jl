using ImplicitGraphs

"""
    Collatz()::ImplicitGraph{Int}

Create a directed graph represenation of the Collatz 3x+1 problem.

The vertices of the graph are positive integers. For a vertex `n`
there is exactly one edge emerging from `n` pointing either to
`n÷2` if `n` is even or to `3n+1` if `n` is odd.
"""
function Collatz()::ImplicitGraph{Int}
    vcheck(v::Int) = v > 0
    function outs(v::Int)
        if v % 2 == 0
            return [div(v, 2)]
        else
            return [3v + 1]
        end
    end

    return ImplicitGraph{Int}(vcheck, outs)
end