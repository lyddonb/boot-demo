module User.Actions (..) where

import Cruddy.Actions exposing (Action)

import Entities exposing (..)

type UserAction 
  = NoOp
  | PageAction (Cruddy.Actions.Action User)
