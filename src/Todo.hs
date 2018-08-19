{-# LANGUAGE DeriveGeneric #-}
module Todo
  ( Todo(Todo)
  , TodoStatus(Open, Blocked, Done)
  , TodoRepository
  , findAllTodos)
where
import GHC.Generics

data TodoStatus = Open | Blocked | Done
  deriving (Eq, Show, Generic)
-- instance ToJSON TodoStatus
-- instance FromJSON TodoStatus

data Todo = Todo
  { todoId :: Int
  , description :: String
  , status :: TodoStatus
  } deriving (Eq, Show)

class TodoRepository a where
  findAllTodos :: a -> IO [Todo]
