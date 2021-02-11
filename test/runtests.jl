using Test
using ImplicitGraphs

G = iGrid()
@test G[(1, 1), (1, 2)]
@test length(G[(0, 0)]) == 4
@test dist(G, (0, 0), (1, 1)) == 2

G = iCycle(10)
@test has(G,1,10)

G = iCycle(10,false)
@test !has(G,1,10)


G = iKnight()
@test deg(G, (0, 0)) == 8

G = iCube(4)
@test dist(G,"0000","1111") == 4