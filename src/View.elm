module View exposing (..) 

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App

import Messages exposing (..)
import Models exposing (..)

import Users.View as UsersView


view : Model -> Html Msg
view model =
  div
    [ class "container" ]
    [ div
      [ class "row" ]
      [ viewPage model ]
    ]

--viewPage : Model -> Html msg
viewPage : Model -> Html Msg
viewPage {page, user} =
  case page of
    Home ->
      div [] [ text "Home" ]

    Users ->
      --UsersView.view user
      App.map UserMsg (UsersView.view user)
