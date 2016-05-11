module Thing.Actions (..) where

import Page.Actions exposing (Action)

import Thing.Models exposing (..)

type ThingAction 
  = NoOp
  | PageAction (Page.Actions.Action Thing)
