module User.Page (..) where

import Dict exposing (Dict)

import String exposing (toInt)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import RouteHash exposing (HashUpdate)

import Bootstrap exposing (..)

import Cruddy.Components exposing (..)
import Cruddy.Models exposing (..)

import Entities exposing (User)

import User.Actions exposing (..)
import User.Models exposing (..)
import User.Update exposing (..)

view : Signal.Address UserAction -> Cruddy.Models.Model User e -> Html
view address model =
  page (Signal.forwardTo address PageAction) model


delta2update : UserModel -> UserModel -> Maybe HashUpdate
delta2update previous current =
  Just <|
    RouteHash.set [toString current]

location2action : List String -> List UserAction
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
