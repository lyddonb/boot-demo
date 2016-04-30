module View (..) where

import Signal exposing (forwardTo)

import Html exposing (..)
import Html.Attributes exposing (..)

import Actions exposing (..)
import Menu.Menu exposing (menu)
import Models exposing (..)

import Page1.Page exposing (..)
import Page2.Page exposing (..)

view : Signal.Address Action -> AppModel -> Html.Html
view address model =
  let
    mainView =
      case model.currentPage of
        Page1 ->
          Page1.Page.view (forwardTo address Page1Action) model.page1

        Page2 ->
          Page2.Page.view (forwardTo address Page2Action) model.page2
 in
    div
      [ class "container" ]
      [ div
        [ class "row" ]
        [ Menu.Menu.menu address model ]
      , mainView ]
