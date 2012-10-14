module Adjmat (
    Graph, Vertex, Edge,
    create, nvertices, vertices, edges, successors
    ) where

import Data.Array

type Vertex = Int
type Edge   = (Vertex, Vertex)
type Graph  = Array Edge Int

create :: Int -> [Edge] -> Graph
create nv edges = accumArray (\_ _ -> 1) 0
    ((0,0), (nv-1,nv-1)) [(e, 1) | e <- edges]

nvertices :: Graph -> Int
nvertices g = n + 1
    where
    (_, (n, _)) = bounds g

vertices :: Graph -> [Vertex]
vertices g = [0..nvertices g]

edges :: Graph -> [Edge]
edges g = [ e | (e, 1) <- assocs g ]

successors :: Graph -> Vertex -> [Vertex]
successors g i = [ j | j <- [0..n], g!(i, j) == 1]
    where
    (_, (n, _)) = bounds g


