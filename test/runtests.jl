using Test
using ImplicitGraphs

G = iGrid()
@test G[(1, 1), (1, 2)]
@test length(G[(0, 0)]) == 4
@test dist(G, (0, 0), (1, 1)) == 2

G = iCycle(10)
@test has(G, 1, 10)

@test length(find_path(G, 1, 5)) == 5
@test length(find_path_undirected(G, 1, 5)) == 5

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

# abstract target vertices
multiplies_to_16(point) = (point[1] * point[2]) == 16
G = iGrid()
@test find_path(G, (1, 1), multiplies_to_16)[end] == (4, 4)

# cutoff depth
@test find_path(G, (0, 0), (3, 5), 8) == find_path(G, (0, 0), (3, 5))
@test length(find_path(G, (0, 0), (3, 5))) ==
      length(find_path_undirected(G, (0, 0), (3, 5)))
@test isempty(find_path(G, (0, 0), (3, 5), 7))
