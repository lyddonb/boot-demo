module Actions (..) where

import Models exposing (Page)
import Page1.Actions exposing (..)
import Page2.Page exposing (..)

type Action
  = Page1Action Page1.Actions.Page1Action
  | Page2Action Page2.Page.Page2Action
  | ShowPage Page
  | NoOp
