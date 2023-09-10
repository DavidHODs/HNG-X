module Main (main) where

import Query(queryApplication)
import Network.Wai.Handler.Warp (run)

port :: Int 
port = 80

main :: IO ()
main = do
    print $ "app running on port " ++ show port
    run port queryApplication