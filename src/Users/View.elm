module Users.View exposing (..)

import Html exposing (..)
import Html.App as App

import Cruddy.Page as CruddyPage

import Users.Models exposing (Model)
import Users.Messages exposing (Msg(..))

view : Model -> Html Msg
view model =
  App.map PageMsg (CruddyPage.page model)
