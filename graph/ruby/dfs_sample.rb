require "./adjlist.rb"
require "./graph_algorithm.rb"

g = Graph.new(7,
    [[0,1],[0,2],[1,3],[2,3],[2,5],[5,3],[5,4],[5,6],[6,3]]
)

p g.dfs_preorder(0).to_a
p g.dfs_postorder(0).to_a
