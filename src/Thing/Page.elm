module Thing.Page (..) where

import Dict exposing (Dict)

import String exposing (toInt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import RouteHash exposing (HashUpdate)

import Page.Bootstrap exposing (..)
import Page.Components exposing (..)

import Thing.Actions exposing (..)
import Thing.Models exposing (..)
import Thing.Update exposing (..)

view : Signal.Address ThingAction -> ThingModel -> Html
view address model =
  let
    pageAddress = (Signal.forwardTo address PageAction)
  in
    div 
      [ class "container" ] 
      [ page pageAddress model.page
      ]


--thingTable : Signal.Address ThingAction -> ThingModel -> List Html.Html
--thingTable address model =
  --[ thead
    --[]
    --[ tr
      --[]
      --[ th [] [ text "Id" ]
      --, th [] [ text "Name" ]
      --, th [] [ text "User" ]
      --, th [] [ text "Actions" ]
      --]
    --]
    --, Dict.values model.entities
      --|> List.reverse
      --|> List.map (thingRow address model)
      --|> tbody []
  --]

--thingRow : Signal.Address ThingAction -> ThingModel -> Thing -> Html.Html
--thingRow address model thing =
  --tr
    --[]
    --[ td [] [ text (toString thing.id) ]
    --, td [] [ text thing.name ]
    --, td [] [ text (toString thing.userId) ]
    --, td 
        --[] 
        --[ editBtn address thing
        --, deleteBtn address thing
        --]
    --]


delta2update : ThingModel -> ThingModel -> Maybe HashUpdate
delta2update previous current =
  Just <|
    RouteHash.set [toString current]

location2action : List String -> List ThingAction
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
