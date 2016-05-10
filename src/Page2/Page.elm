module Page2.Page (..) where

import Dict exposing (Dict)

import String exposing (toInt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Input

import RouteHash exposing (HashUpdate)

import Layout.Bootstrap exposing (..)
import Layout.Components exposing (..)

import Page2.Actions exposing (..)
import Page2.Models exposing (..)

view : Signal.Address Page2Action -> Page2Model -> Html
view address model =
  div 
    [ class "container" ] 
    [ panel address model (pageForm initialFields) "Add a Thing"
    , panel address model (listView thingTable) "View Things"
    ]

thingTable : Signal.Address Page2Action -> Page2Model -> List Html.Html
thingTable address model =
  [ thead
    []
    [ tr
      []
      [ th [] [ text "Id" ]
      , th [] [ text "Name" ]
      , th [] [ text "User" ]
      , th [] [ text "Actions" ]
      ]
    ]
    , Dict.values model.entities
      |> List.reverse
      |> List.map (thingRow address model)
      |> tbody []
  ]

thingRow : Signal.Address Page2Action -> Page2Model -> Thing -> Html.Html
thingRow address model thing =
  tr
    []
    [ td [] [ text (toString thing.id) ]
    , td [] [ text thing.name ]
    , td [] [ text (toString thing.userId) ]
    , td 
        [] 
        [ editBtn address thing
        , deleteBtn address thing
        ]
    ]

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
