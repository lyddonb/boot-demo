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
import Page.Models exposing (..)

import Entities exposing (Thing)

import Thing.Actions exposing (..)
import Thing.Models exposing (..)
import Thing.Update exposing (..)

view : Signal.Address ThingAction -> Page.Models.Model Thing e -> Html
view address model =
  page (Signal.forwardTo address PageAction) model


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
