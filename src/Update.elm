module Update (..) where

import Focus exposing (..)
import Effects exposing (Effects)

import Actions exposing (..)
import Models exposing (..)

import Entities exposing (..)

import Page1.Actions exposing (..)
import Page1.Models exposing (Page1Model)
import Page1.Update exposing (update)

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
        
    ThingAction subAction ->
      let
        tModel = model.pages.thing

        ( pageModel, fx ) =
          Thing.Update.update subAction ({ tModel | entities = model.entities })

        updatedModel = { model | entities = pageModel.entities }
                        |> set (pages => thing) pageModel
      in
        ( updatedModel, Effects.map ThingAction fx )
