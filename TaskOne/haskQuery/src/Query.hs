{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Query() where

import qualified Data.Text as T (Text, pack)
import Data.Time (Day, UTCTime (utctDay), getCurrentTime)
import Data.Aeson (ToJSON)
import GHC.Generics (Generic)
import Servant (Get, JSON, QueryParam, (:>), Handler, Server, Application, serve)
import Control.Monad.IO.Class (liftIO)
import Data.Proxy ( Proxy(..) )

data SuccessResponse = SuccessResponse {
    slack_name :: T.Text,
    current_day :: Day,
    utc_time :: UTCTime,
    track :: T.Text,
    github_file_url :: T.Text,
    github_repo_url :: T.Text,
    status_code :: Int
} deriving (Show, Generic)

instance ToJSON SuccessResponse

data ErrorResponse = ErrorResponse {
    errMsg :: T.Text,
    errCode :: Int
} deriving (Show, Generic)

instance ToJSON ErrorResponse

type QueryAPI = "hng-x" :> "taskone" :> QueryParam "name" T.Text :> QueryParam "track" T.Text :> Get '[JSON] (Either ErrorResponse SuccessResponse)

queryEndpoint :: Maybe T.Text -> Maybe T.Text -> Handler (Either ErrorResponse SuccessResponse)
queryEndpoint _slack_name _track = do
    case (_slack_name, _track) of
        (Nothing, Nothing) -> return $ Left ErrorResponse {
            errMsg = T.pack "bad request: slack name and track missing in query parameter",
            errCode = 400
        }

        (_, Nothing) -> return $ Left ErrorResponse {
            errMsg = T.pack "bad request: track missing in query parameter",
            errCode = 400
        }

        (Nothing, _) -> return $ Left ErrorResponse {
            errMsg = T.pack "bad request: slack name missing in query parameter",
            errCode = 400
        }

        (Just name, Just trk) -> do
            currentUTCTime <- liftIO getCurrentTime
            currentDay <- liftIO $ return (utctDay currentUTCTime)
            return $ Right SuccessResponse {
                slack_name = name,
                current_day = currentDay,
                utc_time = currentUTCTime,
                track = trk,
                github_file_url = T.pack "https://github.com/DavidHODS/HNG-X/TaskOne/haskQuery/src/Query.hs",
                github_repo_url = T.pack "https://github.com/DavidHODS/HNG-X",
                status_code = 200
            }



queryHandler :: Server QueryAPI
queryHandler = queryEndpoint

queryServer :: Proxy QueryAPI
queryServer = Proxy

queryApplication :: Application
queryApplication = serve queryServer queryHandler