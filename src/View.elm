module View (..) where

import Signal exposing (forwardTo)

import Html exposing (..)
import Html.Attributes exposing (..)

import Actions exposing (..)
import Menu exposing (menu)
import Models exposing (..)

import User.Page exposing (..)
import Thing.Page exposing (..)

view : Signal.Address Action -> AppModel -> Html.Html
view address model =
  let
    mainView =
      case model.pages.currentPage of
        User ->
          User.Page.view (forwardTo address UserAction) model.pages.user

        ThingPage ->
          Thing.Page.view (forwardTo address ThingAction) model.pages.thing
 in
    div
      [ class "container" ]
      [ div
        [ class "row" ]
        [ Menu.menu address model ]
      , mainView ]
