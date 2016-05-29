module Users.Messages exposing (..)

import Form exposing (Form)

import Cruddy.Messages as CruddyMessages

import Entities exposing (User)

type Msg
  = NoOp
  | CruddyMsg (CruddyMessages.Msg User)
