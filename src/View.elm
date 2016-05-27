module View exposing (..) 

import Html exposing (..)
import Html.Attributes exposing (..)

import Messages exposing (..)
import Models exposing (..)


view : Model -> Html Msg
view model =
  div
    [ class "container" ]
    [ div
      [ class "row" ]
      [ text "Hi" ]
    ]
