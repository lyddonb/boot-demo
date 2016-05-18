module View (..) where

import Signal exposing (forwardTo)

import Html exposing (..)
import Html.Attributes exposing (..)

import Actions exposing (..)
import Menu exposing (menu)
import Models exposing (..)

import Page1.Page exposing (..)
import Thing.Page exposing (..)

view : Signal.Address Action -> AppModel -> Html.Html
view address model =
  let
    mainView =
      case model.pages.currentPage of
        Page1 ->
          Page1.Page.view (forwardTo address Page1Action) model.pages.page1

        ThingPage ->
          Thing.Page.view (forwardTo address ThingAction) model.pages.thing
 in
    div
      [ class "container" ]
      [ div
        [ class "row" ]
        [ Menu.menu address model ]
      , mainView ]
