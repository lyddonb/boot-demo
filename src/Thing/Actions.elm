module Thing.Actions (..) where

import Page.Actions exposing (Action)

import Entities exposing (..)

type ThingAction 
  = NoOp
  | PageAction (Page.Actions.Action Thing)
