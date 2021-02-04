using Test
using ImplicitGraphs

G = iGrid()
@test G[(1, 1), (1, 2)]
@test length(G[(0, 0)]) == 4
@test dist(G, (0, 0), (1, 1)) == 2

G = iPath(10)
@test has_vertex(G, 3)
@test !has_vertex(G, 11)

G = iKnight()
@test deg(G, (0, 0)) == 8
