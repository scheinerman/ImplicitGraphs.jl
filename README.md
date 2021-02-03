# ImplicitGraphs


An `ImplicitGraph` is a graph in which the vertices and edges are implicitly defined by two functions: one that tests for vertex membership and one that returns a list of (out) neighbors of a vertex. 

The vertex set of an `ImplicitGraph` may be finite or (implicitly) infinite. The (out) degree, however, must be finite.

## Creating Graphs


An `ImplicitGraph` is defined as follows:
```julia
ImplicitGraph{T}(has_vertex, out_neighbors)
```
where 
* `T` is the data type of the vertices.
* `has_vertex(v::T)::Bool` is a function that takes objects of type `T` as input and returns `true` if `v` is a vertex of the graph.
* `out_neighbors(v::T)::Vector{T}` is a function that takes objects of type `T` as input and returns a list of the (out) neighbors of `v`.

For example, the following creates an (essentially) infinite path whose vertices are integers (see also the `iPath` function):
```julia
yes(v::Int)::Bool = true 
N(v::Int)::Vector{Int} = [v-1, v+1]
G = ImplicitGraph{Int}(yes, N)
```
The `yes` function always returns `true` for any `Int`. The `N` function returns the two neighbors of a vertex `v`. (For a truly infinite path, use `BigInt` in place of `Int`).

### Undirected and directed graphs 

The user-supplied `out_neighbors` function can be used to create both undirected and directed graphs. If an undirected graph is intended, be sure that if `{v,w}` is an edge of the graph, then `w` will be in the list returned by `out_neighbors(v)` and `v` will be in the list returned by `out_neighbors(w)`.

To create an infinite *directed* path, the earlier example can be modified like this:
```julia
yes(v::Int)::Bool = true 
N(v::Int)::Vector{Int} = [v+1]
G = ImplicitGraph{Int}(yes, N)
```


## Inspection

To test if `v` is a vertex of an `ImplicitGraph` `G`, use `has_vertex(G)`. Note that the data type of `v` must match the element type of `G`. (The function `eltype` returns the data type of the vertics of the `ImplicitGraph`.)

To test if `{v,w}` is an edge of `G` use `G[v,w]`. Note that `v` and `w` must both be vertices of `G` or an error is thrown.

To get a list of the (out) neighbors of a vertex `v`, use `G[v]`.

## Path Finding

> **Under Construction**

## Predefined Graphs

We provide a few basic graphs that can be created using the following methods:

* `iCycle(n::Int)` creates an undirected cycle with vertex set `{1,2,...,n}`.

* `iPath(n::Int)` creates an undirected path with vertex set `{1,2,...,n}`.

* `iPath()` creates an (essentially) infinite undirected path whose vertex set contains any integer (object of type `Int`).

* `iGrid()` creates an (essentially) infinite grid whose vertices are ordered pairs of integers (`Int`s).
