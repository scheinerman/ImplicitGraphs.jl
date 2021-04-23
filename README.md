# ImplicitGraphs

[![Build Status](https://travis-ci.com/scheinerman/ImplicitGraphs.jl.svg?branch=main)](https://travis-ci.com/scheinerman/ImplicitGraphs.jl)


An `ImplicitGraph` is a graph in which the vertices and edges are implicitly defined by two functions: one that tests for vertex membership and one that returns a list of the (out) neighbors of a vertex. 

The vertex set of an `ImplicitGraph` may be finite or (implicitly) infinite. The (out) degrees, however, must be finite.

## Creating Graphs


An `ImplicitGraph` is defined as follows:
```julia
ImplicitGraph{T}(has_vertex, out_neighbors)
```
where 
* `T` is the data type of the vertices.
* `has_vertex(v::T)::Bool` is a function that takes objects of type `T` as input and returns `true` if `v` is a vertex of the graph.
* `out_neighbors(v::T)::Vector{T}` is a function that takes objects of type `T` as input and returns a list of the (out) neighbors of `v`.

For example, the following creates an (essentially) infinite path whose vertices are integers (see the `iPath` function):
```julia
yes(v::Int)::Bool = true 
N(v::Int)::Vector{Int} = [v-1, v+1]
G = ImplicitGraph{Int}(yes, N)
```
The `yes` function always returns `true` for any `Int`. The `N` function returns the two neighbors of a vertex `v`. (For a truly infinite path, use `BigInt` in place of `Int`.)

Note that if `v` is an element of its own neighbor set, that represents a loop at vertex `v`.

### Undirected and directed graphs 

The user-supplied `out_neighbors` function can be used to create both undirected and directed graphs. If an undirected graph is intended, be sure that if `{v,w}` is an edge of the graph, then `w` will be in the list returned by `out_neighbors(v)` and `v` will be in the list returned by `out_neighbors(w)`.

To create an infinite *directed* path, the earlier example can be modified like this:
```julia
yes(v::Int)::Bool = true 
N(v::Int)::Vector{Int} = [v+1]
G = ImplicitGraph{Int}(yes, N)
```


## Predefined Graphs

We provide a few basic graphs that can be created using the following methods:

* `iCycle(n::Int)` creates an undirected cycle with vertex set `{1,2,...,n}`; 
`iCycle(n,false)` creates a directed `n`-cycle.

* `iPath()` creates an (essentially) infinite undirected path whose vertex set contains all integers (objects of type `Int`);
`iPath(false)` creates a one-way infinite path `⋯ → -2 → -1 → 0 → 1 → 2 → ⋯`.

* `iGrid()` creates an (essentially) infinite grid whose vertices are ordered pairs of integers (objects of type `Int`).

* `iCube(d::Int)` creates a `d`-dimensional cube graph. The vertices are all `d`-long strings of `0`s and `1`s. Two vertices are adjacent iff they differ in exactly one bit.

* `iKnight()` creates the Knight's move graph on an (essentially) infinite chessboard. The vertices are pairs of integers (objects of type `Int`).

* `iShift(alphabet, n::Int)` creates the shift digraph whose vertices are `n`-tuples of elements of `alphabet`.


## Inspection

* To test if `v` is a vertex of an `ImplicitGraph` `G`, use `has(G)`. Note that the data type of `v` must match the element type of `G`. (The function `eltype` returns the data type of the vertices of the `ImplicitGraph`.)

* To test if `{v,w}` is an edge of `G` use `G[v,w]` or `has(G,v,w)`. Note that `v` and `w` must both be vertices of `G` or an error is thrown.

* To get a list of the (out) neighbors of a vertex `v`, use `G[v]`.

* To get the degree of a vertex in a graph, use `deg(G,v)`.

```julia
julia> G = iGrid()
ImplicitGraph{Tuple{Int64,Int64}}

julia> has_vertex(G,(1,2))
true

julia> G[(1,2)]
4-element Array{Tuple{Int64,Int64},1}:
 (1, 1)
 (1, 3)
 (0, 2)
 (2, 2)

julia> G[(1,2),(1,3)]
true

julia> deg(G,(5,0))
4
```

## Path Finding

### Shortest path

The function `find_path` finds a shortest path between vertices of a graph. This function may run without returning if the graph is infinite and disconnected.
```julia
julia> G = iGrid()
ImplicitGraph{Tuple{Int64,Int64}}

julia> find_path(G,(0,0), (3,5))
9-element Array{Tuple{Int64,Int64},1}:
 (0, 0)
 (0, 1)
 (0, 2)
 (0, 3)
 (0, 4)
 (0, 5)
 (1, 5)
 (2, 5)
 (3, 5)
```

The function `dist` returns the length of a shortest path between vertices in the graph.
```julia
julia> dist(G,(0,0),(3,5))
8
```

### Guided path finding

The function `guided_path_finder` employs a score function to try to find a 
path between vertices. It may be faster than `find_path`, but might not give a shortest path.

This function is called as follows: `guided_path_finder(G,s,t,score=sc, depth=d)` where
* `G` is an `ImplicitGraph`,
* `s` is the starting vertex of the desired path,
* `t` is the ending vertex of the desired path,
* `sc` is a score function that mapping vertices to integers and should get smaller as vertices get closer to `t` (and should minimize at `t`), and
* `d` controls amount of look ahead (default is `1`).

```julia
julia> G = iKnight();

julia> s = (9,9); t = (0,0);

julia> sc(v) = sum(abs.(v));  # score of (a,b) is |a| + |b|

julia> guided_path_finder(G,s,t,score=sc,depth=1)
9-element Vector{Tuple{Int64, Int64}}:
 (9, 9)
 (8, 7)
 (7, 5)
 (6, 3)
 (5, 1)
 (3, 0)
 (1, -1)
 (-1, -2)
 (0, 0)

# With better look-ahead we find a shorter path

julia> guided_path_finder(G,s,t,score=sc,depth=3)
7-element Vector{Tuple{Int64, Int64}}:
 (9, 9)
 (8, 7)
 (7, 5)
 (6, 3)
 (4, 2)
 (2, 1)
 (0, 0)
```
Greater depth can find a shorter path, but that comes at a cost:
```julia
julia> using BenchmarkTools

julia> @btime guided_path_finder(G,s,t,score=sc,depth=1);
  52.361 μs (1308 allocations: 81.05 KiB)

julia> @btime guided_path_finder(G,s,t,score=sc,depth=3);
  407.546 μs (8691 allocations: 696.47 KiB)
```


<hr/>

## Extras

The `extras` directory contains the following additional functions.

### Conversion to `SimpleGraph` or `SimpleDigraph`

An `ImplicitGraph` may be infinite and so there is no universal way to convert an `ImplicitGraph` to a `SimpleGraph` or `SimpleDigraph`. However, given a finite subset of the vertex, we can form the induced subgraph (or sub-digraph) on that subset.

Code for this is in the file `extras/conversion.jl`. It is not part of the `ImplicitGraphs` module. 

### iPaley

The file `extras/iPaley.jl` contains the `iPaley` function for creating an 
implicit Paley graph. In particular, `iPaley(p)` (where `p` is a prime congruennt
to 1 modulo 4) creates a graph with vertex set `0:p-1` in which two vertices are
adjacent iff their difference is a quadratic residue modulo `p`.

### iTransposition

The function `iTransposition(n)` creates an `ImplicitGraph` whose vertices
are all permutation of `1:n`. Two vertices of this graph are adjacent iff
they differ by a transposition.

* `iTransposition(n,true)` [default] only considers transpositions of the form `(a,a+1)` where `0 < a < n`.
* `iTransposition(n,false)` considers all transpositions `(a,b)` where `0<a<b≤n`.