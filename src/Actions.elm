module Actions (..) where

import Models exposing (Page)
import Page1.Actions exposing (..)
import Thing.Actions exposing (..)

type Action
  = Page1Action Page1.Actions.Page1Action
  | ThingAction Thing.Actions.ThingAction
  | ShowPage Page
  | NoOp
