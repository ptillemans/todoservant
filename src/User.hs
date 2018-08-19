module User(User(User), UserRepository, findAllUsers) where

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

class UserRepository a where
  findAllUsers :: a -> IO [User]
