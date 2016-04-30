module Page2.Page (..) where

import Effects exposing (Effects)
import String exposing (toInt)

import Html exposing (..)
import Html.Attributes exposing (..)

import RouteHash exposing (HashUpdate)

type alias Page2Model = {}

init : Page2Model
init = {}

type Page2Action
  = NoOp

update : Page2Action -> Page2Model -> ( Page2Model, Effects Page2Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

view : Signal.Address Page2Action -> Page2Model -> Html
view address model =
  div [ class "container" ] [ text "Page 2" ]

delta2update : Page2Model -> Page2Model -> Maybe HashUpdate
delta2update previous current =
  Just <|
    RouteHash.set [toString current]

location2action : List String -> List Page2Action
location2action list =
  case list of
    first :: rest ->
      case toInt first of
        Ok value ->
          [ ]

        Err _ ->
          -- If it wasn't an integer, then no action ... we could
          -- show an error instead, of course.
          []

    _ ->
      -- If nothing provided for this part of the URL, return empty list 
      []
