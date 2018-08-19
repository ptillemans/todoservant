{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where


import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

import User (User(User), UserRepository, findAllUsers)
import Todo

data DummyUserRepository = DummyUserRepository [User]
instance UserRepository DummyUserRepository where
  findAllUsers (DummyUserRepository users) = return users

data DummyTodoRepository = DummyTodoRepository [Todo]
instance TodoRepository DummyTodoRepository where
  findAllTodos (DummyTodoRepository todos) = return todos

$(deriveJSON defaultOptions ''User)
$(deriveJSON defaultOptions ''TodoStatus)
$(deriveJSON defaultOptions ''Todo)

type API = "users" :> Get '[JSON] [User]
  :<|> "todos" :> Get '[JSON] [Todo]

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

userRepo = DummyUserRepository [ User 1 "Isaac" "Newton"
                               , User 2 "Albert" "Einstein"]
todoRepo = DummyTodoRepository [ Todo 1 "Learn Servant routing." Open]

server :: Server API
server =  (liftIO $ findAllUsers userRepo)
  :<|> (liftIO $ findAllTodos todoRepo)
