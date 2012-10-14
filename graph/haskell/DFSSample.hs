module Main where

import Adjlist as G
import GraphAlgorithm

main = do
    let g = G.create 7 [(0,1),(0,2),(1,3),(2,3),(2,5),(5,3),(5,4),(5,6),(6,3)]
    print $ dfs_preorder g 0
    print $ dfs_postorder g 0
