module GraphAlgorithm (
    dfs_preorder, dfs_postorder,
    dijkstra
    ) where

import Control.Monad.State
import Data.Array
import Adjlist

dfs_preorder, dfs_postorder :: Graph -> Vertex -> [Vertex]
dfs_preorder g s
    = evalState (dfs_sub g True s) (listArray (0, (nvertices g)-1) (repeat False))
dfs_postorder g s
    = evalState (dfs_sub g False s) (listArray (0, (nvertices g)-1) (repeat False))

dfs_sub :: Graph -> Bool -> Vertex -> State (Array Int Bool) [Vertex]
dfs_sub g pre i = do
    visited <- get
    if visited!i
        then return []
        else do
            put (visited // [(i, True)])
            list <- mapM (dfs_sub g pre) (successors g i)
            if pre
                then return $ i:concat list
                else return $ concat list ++ [i]
