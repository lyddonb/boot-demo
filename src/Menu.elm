module Menu (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Actions exposing (..)
import Models exposing (..)

getMenuDisplay : Page -> Html.Html
getMenuDisplay page =
  case page of
    Page1 ->
      text "Page 1"

    ThingPage ->
      text "Thing"

iconBar : Signal.Address Action -> AppModel -> Html.Html
iconBar address model =
  span
    [ class "icon-bar" ]
    []

header : Signal.Address Action -> AppModel -> Html.Html
header address model =
  div
    [ class "navbar-header" ]
    [ button
      [ type' "button"
      , class "navbar-toggle collapsed"
      , attribute "data-toggle" "collapse"
      , attribute "data-target" "#bs-example-navbar-collapse-1"
      , attribute "aria-expanded"  "false"
      ]
      [ span
        [ class "sr-only" ]
        [ text "Toggle navigation" ]
      , iconBar address model
      , iconBar address model
      , iconBar address model
      ]
    , a
      [ class "navbar-brand"
      , href "#"
      ]
      [ text "Boot Demo" ]
    ]

-- TODO: Switch to checking the model for the "active" page
link : Signal.Address Action -> AppModel -> Page -> Html.Html
link address model page =
  if page == model.pages.currentPage then
    activeLink address model page
  else
    inactiveLink address model page

inactiveLink : Signal.Address Action -> AppModel -> Page -> Html.Html
inactiveLink address model page =
  li
    [ ]
    [ a
      [ href "#"
      , onClick address (ShowPage page) 
      ]
      [ getMenuDisplay page ]
    ]

activeLink : Signal.Address Action -> AppModel -> Page -> Html.Html
activeLink address model page =
  li
    [ class "active" ]
    [ a
      [ href "#" ]
      [ getMenuDisplay page 
      , span
        [ class "sr-only" ]
        [ text "(current)" ]
      ]
    ]

links : Signal.Address Action -> AppModel -> Html.Html
links address model =
  div
    [ class "collapse navbar-collapse"
    , id "bs-example-navbar-collapse-1"
    ]
    [ ul
      [ class "nav navbar-nav" ]
      [ link address model Page1
      , link address model ThingPage
      ]
    ]

menu : Signal.Address Action -> AppModel -> Html.Html
menu address model =
  nav 
    [ class "navbar navbar-inverse navbar-fixed-top" ]
    [ div
      [ class "container" ]
      [ header address model
      , links address model
      ]
    ]
