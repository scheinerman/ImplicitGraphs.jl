# `ImplicitGraphs` Extras

This directory contains additional code and examples associated with the `ImplicitGraph` type.

## `conversion.jl`



An `ImplicitGraph` may be infinite and so there is no universal way to convert an `ImplicitGraph` to an `UndirectedGraph` or a `DirectedGraph`. However, given a finite subset of the vertices, we can form the induced subgraph (or sub-digraph) on that subset.

* `UndirectedGraph(G::ImplicitGraph, A)` returns an undirected graph 
  (type `UndirectedGraph`) whose 
  vertex set is `A` and is the induced subgraph of `G` on that set.

* Likewise, `DirectedGraph(G::ImplicitGraph, A)` returns a directed graph 
  (type `DirectedGraph`).



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
```
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
```
julia> CoxeterDecomposition(p)
Permutation of 1:10: (2,3)(3,4)(2,3)(5,6)(4,5)(6,7)(5,6)(4,5)(3,4)(2,3)(7,8)(6,7)(5,6)(8,9)(7,8)(6,7)(5,6)(4,5)(3,4)(9,10)(8,9)(7,8)(6,7)(5,6)
```

We include the adjective *crazy* in the function name because it is much slower and 
memory intensive than `CoxeterDecomposition`:
```
julia> using BenchmarkTools

julia> p = RandomPermutation(30);

julia> @btime CoxeterDecomposition(p);
  384.528 μs (11 allocations: 5.25 KiB)

julia> @btime crazy_trans_product(p,true);
  109.266 ms (387316 allocations: 63.06 MiB)
```

## `Collatz.jl`

The function `Collatz()` returns a directed graph represenation of the Collatz 3x+1 problem.

The vertices of the graph are positive integers. For a vertex `n`
there is exactly one edge emerging from `n` pointing either to
`n÷2` if `n` is even or to `3n+1` if `n` is odd.

```
julia> G = Collatz();

julia> find_path(G,12,1)
10-element Vector{Int64}:
 12
  6
  3
 10
  5
 16
  8
  4
  2
  1
```

The function `ReverseCollatz()` is the same as `Collatz()` except the edges are reversed.

```
julia> H = ReverseCollatz();

julia> find_path(H,1,12)
10-element Vector{Int64}:
  1
  2
  4
  8
 16
  5
 10
  3
  6
 12
 ```

