module Users.Messages exposing (..)

import Cruddy.Messages as CruddyMessages

import Entities exposing (User)

type Msg
  = NoOp
  | PageMsg (CruddyMessages.Msg User)
