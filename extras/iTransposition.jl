using ImplicitGraphs, Permutations


"""
    iTransposition(n::Int, adjacent::Bool=true)

Create an `ImplicitGraph` whose vertices are all permutations of `1:n`
in which two vertices are adjacent if they differ by a transpostion.

* If `adjacent` is true, then only consider transpositions of the form `(a,a+1)`
* Otherwise, consider all possible transpositions of the form `(a,b)` where `1≤a<b≤n`.
"""
function iTransposition(n::Int, adjacent::Bool = true)
    @assert n > 0 "Require n>0, got n=$n"

    vcheck(v::Permutation) = length(v) == n

    function outs(v::Permutation)
        if adjacent
            return [v * Transposition(n, i, i + 1) for i = 1:n-1]
        end
        return [v * Transposition(n, i, j) for i = 1:n for j = 1:n if i ≠ j]
    end

    return ImplicitGraph{Permutation}(vcheck, outs)
end
