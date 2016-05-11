module Actions (..) where

import Models exposing (Page)
import Page1.Actions exposing (..)
import Page2.Actions exposing (..)
import Thing.Actions exposing (..)

type Action
  = Page1Action Page1.Actions.Page1Action
  | Page2Action Page2.Actions.Page2Action
  | ThingAction Thing.Actions.ThingAction
  | ShowPage Page
  | NoOp
