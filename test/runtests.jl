using Test
using ImplicitGraphs

G = iGrid()
@test G[(1,1),(1,2)]
@test length(G[(0,0)])==4

G = iPath(10)
@test has_vertex(G,3)
@test !has_vertex(G,11)