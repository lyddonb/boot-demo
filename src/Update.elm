module Update (..) where

import Focus exposing (..)
import Effects exposing (Effects)

import Actions exposing (..)
import Models exposing (..)

import Entities exposing (..)

import User.Actions exposing (..)
import User.Models exposing (UserModel)
import User.Update exposing (update)

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

    UserAction subAction ->
      let
        pModel = model.pages.user

        -- Pass the users from the AppModel down to the UserModel
        ( pageModel, fx ) =
          User.Update.update subAction ({ pModel | entities = model.entities })

        -- Update user and users on the AppModel
        updatedModel = { model | entities = pageModel.entities }
                        |> set (pages => user) pageModel
      in
        ( updatedModel, Effects.map UserAction fx )
        
    ThingAction subAction ->
      let
        tModel = model.pages.thing

        ( pageModel, fx ) =
          Thing.Update.update subAction ({ tModel | entities = model.entities })

        updatedModel = { model | entities = pageModel.entities }
                        |> set (pages => thing) pageModel
      in
        ( updatedModel, Effects.map ThingAction fx )
