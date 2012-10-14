module AdjmatW (
    Graph, Vertex, Edge,
    create, vertices, edges, successors
    ) where

import Data.Array

type Vertex  = Int
type Edge w  = (Vertex, Vertex, w)
type Graph w = Array (Vertex, Vertex) w

create :: Num w => Int -> [Edge w] -> Graph w
create nv edges = accumArray (\_ w -> w) 0
    ((0,0), (nv-1,nv-1)) [((i,j),w) | (i,j,w) <- edges]

nvertices :: Num w => Graph w -> Int
nvertices g = n + 1
    where
    (_, (n, _)) = bounds g

vertices :: Num w => Graph w -> [Vertex]
vertices g = [0..nvertices g]

edges :: Num w => Graph w -> [Edge w]
edges g = [ (i,j,w) | ((i,j), w) <- assocs g, w /= 0]

successors :: Num w => Graph w -> Vertex -> [(Vertex, w)]
successors g i = [ (j, w) | j <- [0..n], let w = g!(i, j), w /= 0]
    where
    (_, (n, _)) = bounds g


