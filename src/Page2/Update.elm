module Page2.Update (..) where

import Effects exposing (Effects)

import Page2.Actions exposing (..)
import Page2.Models exposing (..)

update : Page2Action -> Page2Model -> ( Page2Model, Effects Page2Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )
