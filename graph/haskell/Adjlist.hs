module Adjlist (
    Graph, Vertex, Edge,
    create, nvertices, vertices, edges, successors
    ) where

import Data.Array

type Vertex = Int
type Edge   = (Vertex, Vertex)
type Graph  = Array Vertex [Vertex]

create :: Int -> [Edge] -> Graph
create nv edges = accumArray (\vs v -> v:vs) []
    (0, nv-1) (reverse edges)

nvertices :: Graph -> Int
nvertices g = n + 1
    where
    (_, n) = bounds g

vertices :: Graph -> [Vertex]
vertices g = [0..nvertices g]

edges :: Graph -> [Edge]
edges g = [(i, j) | (i, vs) <- assocs g, j <- vs]

successors :: Graph -> Vertex -> [Vertex]
successors g i = g!i


