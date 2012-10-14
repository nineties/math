module AdjlistW (
    Graph, Vertex, Edge,
    create, nvertices, vertices, edges, successors
    ) where

import Data.Array

type Vertex = Int
type Edge w = (Vertex, Vertex, w)
type Graph w = Array Vertex [(Vertex, w)]

create :: Num w => Int -> [Edge w] -> Graph w
create nv edges = accumArray (\vs v -> v:vs) []
    (0, nv-1) [(i,(j,w)) | (i,j,w) <- reverse edges]

nvertices :: Num w => Graph w -> Int
nvertices g = n + 1
    where
    (_, n) = bounds g

vertices :: Num w => Graph w -> [Vertex]
vertices g = [0..nvertices g]

edges :: Num w => Graph w -> [Edge w]
edges g = [(i,j,w) | (i, vs) <- assocs g, (j,w) <- vs]

successors :: Num w => Graph w -> Vertex -> [(Vertex,w)]
successors g i = g!i


