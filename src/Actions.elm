module Actions (..) where

import Models exposing (Page)
import User.Actions exposing (..)
import Thing.Actions exposing (..)

type Action
  = UserAction User.Actions.UserAction
  | ThingAction Thing.Actions.ThingAction
  | ShowPage Page
  | NoOp
