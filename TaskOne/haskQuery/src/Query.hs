{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Query() where

import qualified Data.Text as T (Text)
import Data.Time (Day, UTCTime)
import Data.Aeson (ToJSON)
import GHC.Generics (Generic)

data SuccessResponse = SuccessResponse {
    slack_name :: Maybe T.Text,
    current_day :: Day,
    utc_time :: UTCTime,
    track :: Maybe T.Text,
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