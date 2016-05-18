module Thing.Actions (..) where

import Cruddy.Actions exposing (Action)

import Entities exposing (..)

type ThingAction 
  = NoOp
  | PageAction (Cruddy.Actions.Action Thing)
