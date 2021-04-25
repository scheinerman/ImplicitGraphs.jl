# `ImplicitGraphs` Extras

This directory contains additional code and examples associated with the `ImplicitGraph` type.

## `conversion.jl`



An `ImplicitGraph` may be infinite and so there is no universal way to convert an `ImplicitGraph` to a `SimpleGraph` or `SimpleDigraph`. However, given a finite subset of the vertices, we can form the induced subgraph (or sub-digraph) on that subset.

* `SimpleGraph(G::ImplicitGraph, A)` returns an undirected graph (type `SimpleGraph`) whose 
  vertex set is `A` and is the induced subgraph of `G` on that set.

* Likewise, `SimpleDigraph(G::ImplicitGraph, A)` returns a directed graph 
  (type `SimpleDigraph`).



## `iPaley.jl`

The `iPaley` function creates an implicit Paley graph. In particular, `iPaley(p)` 
(where `p` is a prime congruennt to 1 modulo 4) creates a graph with vertex set `0:p-1` 
in which two vertices are adjacent iff their difference is a quadratic residue modulo `p`.


## `iTransposition.jl`

The function `iTransposition(n)` creates an `ImplicitGraph` whose vertices
are all permutation of `1:n`. Two vertices of this graph are adjacent iff
they differ by a transposition.

* `iTransposition(n,true)` [default] only considers transpositions of the form `(a,a+1)` where `0 < a < n`.
* `iTransposition(n,false)` considers all transpositions `(a,b)` where `0<a<b≤n`.

As a demonstration of guided path finding, we include the function `crazy_trans_product` 
to find a representation of a `Permutation` as the product of transpositions. 
The function is invoked as


`crazy_trans_product(p::Permutation, adjacent::Bool=true)::String`

Example:
```julia
julia> p = RandomPermutation(10)
(1)(2,7,8,6,3,9)(4)(5,10)

julia> println(crazy_trans_product(p,true))
true
(5,6)(6,7)(5,6)(2,3)(3,4)(4,5)(3,4)(2,3)(7,8)(8,9)(7,8)(5,6)(6,7)(5,6)(9,10)(7,8)(8,9)(7,8)(3,4)(4,5)(3,4)(6,7)(7,8)(5,6)

julia> println(crazy_trans_product(p,false))
true
(7,8)(6,8)(2,3)(2,6)(5,10)(3,9)
```

An analogous result is given by `CoxeterDecomposition`:
```julia
julia> CoxeterDecomposition(p)
Permutation of 1:10: (2,3)(3,4)(2,3)(5,6)(4,5)(6,7)(5,6)(4,5)(3,4)(2,3)(7,8)(6,7)(5,6)(8,9)(7,8)(6,7)(5,6)(4,5)(3,4)(9,10)(8,9)(7,8)(6,7)(5,6)
```





