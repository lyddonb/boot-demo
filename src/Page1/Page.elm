module Page1.Page (..) where

import String exposing (toInt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import RouteHash exposing (HashUpdate)

import Page1.Actions exposing (..)
import Page1.Form exposing (..)
import Page1.List exposing (..)
import Page1.Models exposing (..)
import Page1.Update exposing (..)


panel : Signal.Address Page1Action -> Page1Model -> (Signal.Address Page1Action -> Page1Model -> Html) -> String -> Html
panel address model panelView title =
  div
    [ class "panel panel-default" ]
    [ div
      [ class "panel-heading" ]
      [ div
        [ class "panel-title" ]
        [ text title ]
      ]
    , div
      [ class "panel-body" ]
      [ panelView address model ]
    ]
  

view : Signal.Address Page1Action -> Page1Model -> Html
view address model =
  div 
    [ class "container" ] 
    [ panel address model pageForm "Add a User"
    , panel address model listView "View Users"
    ]
    

delta2update : Page1Model -> Page1Model -> Maybe HashUpdate
delta2update previous current =
  Just <|
    RouteHash.set [toString current]

location2action : List String -> List Page1Action
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
