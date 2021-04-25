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

"""
    trans_string(p::Permutation)

We assume that `p` is a transposition. 
"""
function trans_string(p::Permutation)::String
    n = length(p)
    FP = fixed_points(p)
    @assert n == length(FP) + 2 "Permutation must be a transposition"
    elts = sort(setdiff(1:n, FP))
    a, b = elts
    return "($a,$b)"
end

"""
    pscore(p::Permutation)::Int

Measures the extent to which `p` is different from the identity permutation 
using this formula:

`sum(abs(p[k]-k) for k=1:length(p))`
"""
function pscore(p::Permutation)::Int
    n = length(p)
    sum(abs(i - p(i)) for i = 1:n)
end

"""
    crazy_trans_product(p::Permutation, adjacent::Bool=true)::String

Express `p` as the product of transpositions. With `adjacent=true` the transpositions 
are all of the form `(a,a+1)`; otherwise, all possible transpositions are allowed.

Result is expressed as a `String`.
"""
function crazy_trans_product(p::Permutation, adjacent::Bool = true)::String
    n = length(p)
    G = iTransposition(n, adjacent)
    P = reverse(guided_path_finder(G, p, Permutation(n), score = pscore))

    nP = length(P)

    if nP == 1
        return "()"
    end

    Q = [P[k]' * P[k+1] for k = 1:nP-1]

    prod(trans_string(Q[j]) for j = 1:length(Q))
end
