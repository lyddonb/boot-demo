module Update (..) where

import Focus exposing (..)
import Effects exposing (Effects)

import Actions exposing (..)
import Models exposing (..)

import Page1.Actions exposing (..)
import Page1.Models exposing (Page1Model)
import Page1.Update exposing (update)

import Page2.Actions exposing (..)
import Page2.Models exposing (Page2Model)
import Page2.Update exposing (update)

import Thing.Actions exposing (..)
import Thing.Models exposing (ThingModel)
import Thing.Update exposing (update)


update : Actions.Action -> AppModel -> ( AppModel, Effects Actions.Action )
update action model =
  case action of

    Actions.NoOp ->
      ( model, Effects.none )

    ShowPage page ->
      ( set (pages => currentPage) page model, Effects.none )

    Page1Action subAction ->
      let
        pModel = model.pages.page1

        -- Pass the users from the AppModel down to the Page1Model
        ( pageModel, fx ) =
          Page1.Update.update subAction ({ pModel | users = model.entities.users })

        -- Update page1 and users on the AppModel
        updatedModel = model
                        |> set (pages => page1) pageModel
                        |> set (entities => users) pageModel.users
      in
        ( updatedModel, Effects.map Page1Action fx )
        
    Page2Action subAction ->
      let
        ( pageModel, fx ) =
          Page2.Update.update subAction model.pages.page2
      in
        ( set (pages => page2) pageModel model, Effects.map Page2Action fx )
        
    ThingAction subAction ->
      let
        tModel = model.pages.thing

        ( pageModel, fx ) =
          Thing.Update.update subAction ({ tModel | things = model.entities.things })

        updatedModel = model
                        |> set (pages => thing) pageModel
                        |> set (entities => things) pageModel.things
      in
        ( updatedModel, Effects.map ThingAction fx )
