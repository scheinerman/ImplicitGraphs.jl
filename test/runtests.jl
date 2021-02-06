using Test
using ImplicitGraphs

G = iGrid()
@test G[(1, 1), (1, 2)]
@test length(G[(0, 0)]) == 4
@test dist(G, (0, 0), (1, 1)) == 2

G = iPath(10)
@test has(G, 3)
@test !has(G, 11)
G = iCycle(10)
@test has(G,1,10)

G = iKnight()
@test deg(G, (0, 0)) == 8
