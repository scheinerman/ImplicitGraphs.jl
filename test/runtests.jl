using Test
using ImplicitGraphs

G = iGrid()
@test G[(1, 1), (1, 2)]
@test length(G[(0, 0)]) == 4
@test dist(G, (0, 0), (1, 1)) == 2

G = iCycle(10)
@test has(G, 1, 10)

@test length(find_path(G, 1, 5)) == 5

G = iCycle(10, false)
@test !has(G, 1, 10)


G = iKnight()
@test deg(G, (0, 0)) == 8

G = iCube(4)
@test dist(G, "0000", "1111") == 4

G = iShift([1, 2, 3], 5)
@test deg(G, (1, 1, 1, 1, 1)) == 3


G = iKnight()
s = (5, 5)
t = (0, 0)
score(vw) = sum(abs.(vw))
P = guided_path_finder(G, s, t, score = score, depth = 2)
@test length(P) > 0
