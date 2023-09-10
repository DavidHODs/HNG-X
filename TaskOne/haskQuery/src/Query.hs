{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Query(queryApplication) where

import qualified Data.Text as T (Text, pack)
import Data.Time (UTCTime (utctDay), getCurrentTime, formatTime)
import Data.Aeson (ToJSON)
import GHC.Generics (Generic)
import Servant (Get, JSON, QueryParam, (:>), Handler, Server, Application, serve, throwError, ServerError (..))
import Control.Monad.IO.Class (liftIO)
import Data.Proxy ( Proxy(..) )
import qualified Data.ByteString.Lazy.Char8 as LBS
import Data.Time.Format (defaultTimeLocale)

data SuccessResponse = SuccessResponse {
    slack_name :: T.Text,
    current_day :: T.Text,
    utc_time :: T.Text,
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

type QueryAPI = "hng-x" :> "api" :> QueryParam "slack_name" T.Text :> QueryParam "track" T.Text :> Get '[JSON] SuccessResponse

errorHandler :: LBS.ByteString -> Handler a
errorHandler msg = throwError err
    where
        err :: ServerError
        err = ServerError {
            errHTTPCode = 400,
            errReasonPhrase = "bad request",
            errBody = msg <> LBS.pack " track missing in query parameter",
            errHeaders = []
        }

getCurrentDayName :: IO String
getCurrentDayName = do
    currentTime <- getCurrentTime
    let currentDay = utctDay currentTime
    return $ formatTime defaultTimeLocale "%A" currentDay

formatUtcTime :: UTCTime -> String
formatUtcTime = formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ"


queryEndpoint :: Maybe T.Text -> Maybe T.Text -> Handler SuccessResponse
queryEndpoint _slack_name _track = do
    case (_slack_name, _track) of
        (Nothing, Nothing) -> errorHandler $ LBS.pack "slack_name and track"

        (_, Nothing) -> errorHandler $ LBS.pack "track"

        (Nothing, _) -> errorHandler $ LBS.pack "slack_name"

        (Just name, Just trk) -> do
            currentUTCTime <- liftIO getCurrentTime
            currentDay <- liftIO getCurrentDayName
            return SuccessResponse {
                slack_name = name,
                current_day = T.pack currentDay,
                utc_time = T.pack $ formatUtcTime currentUTCTime,
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

