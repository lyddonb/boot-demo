module Update (..) where

import Effects exposing (Effects)

import Actions exposing (..)
import Models exposing (..)

import Page1.Actions exposing (..)
import Page1.Update exposing (update)
import Page2.Page exposing (Page2Action, update)
--import Page1.Page exposing (..)
--import Page2.Page exposing (..)

update : Actions.Action -> AppModel -> ( AppModel, Effects Actions.Action )
update action model =
  case action of
    Actions.NoOp ->
      ( model, Effects.none )

    ShowPage page ->
      ( { model | currentPage = page } , Effects.none )

    Page1Action subAction ->
      let
        ( pageModel, fx ) =
          Page1.Update.update subAction model.page1
      in
        ( { model | page1 = pageModel } , Effects.map Page1Action fx )
        
    Page2Action subAction ->
      let
        ( pageModel, fx ) =
          Page2.Page.update subAction model.page2
      in
        ( { model | page2 = pageModel } , Effects.map Page2Action fx )
