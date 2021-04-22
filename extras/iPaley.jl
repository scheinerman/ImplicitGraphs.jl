using ImplicitGraphs, Primes

"""
    iPaley(p::Int)

Create an implicit Paley graph on `p` vertices. 
Here `p` must be a prime congruent to 1 modulo 4. 
The vertices of the graph are integers in the range
`0:p-1` and two vertices are adjacent if their difference
is a quadratic residue mod `p`.
"""
function iPaley(p::Int)::ImplicitGraph
    if !isprime(p) || p%4 != 1
        error("Argument ($p) must be prime and congruent to 1 mod 4")
    end

    vcheck(v::Int) = 0 <= v < p 

    function outs(v::Int)
        return unique((v + k^2)%p for k=1:p-1)
    end

    return ImplicitGraph{Int}(vcheck,outs)
end