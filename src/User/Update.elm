module User.Update (..) where

import Debug

import Dict exposing (Dict)

import Focus exposing (..)

import Effects exposing (Effects)

import Maybe exposing (withDefault)

import Form exposing (Form)

import List.Extra exposing (last)

import Cruddy.Actions exposing (Action (SubmitPageEntity, SubmitModalEntity))
import Cruddy.Update exposing (..)

import Entities exposing (..)

import User.Actions exposing (..)
import User.Models exposing (..)

update : UserAction -> UserModel -> ( UserModel, Effects UserAction )
update action model =
  case action of

    NoOp ->
      ( model, Effects.none )

    PageAction pageAction ->
      let
        ( pageModel, _ ) =
          Cruddy.Update.update pageAction model

        ( updatedModel, fx ) =
          updateForm pageAction pageModel

        --updatedPageModel = { pageModel | entities = updatedModel.users }
      in
        ( updatedModel, fx )
        --, Effects.map PageAction fx )


updateForm : Cruddy.Actions.Action User -> UserModel -> ( UserModel, Effects UserAction )
updateForm action model =
  case action of

    SubmitPageEntity thing ->
      let
        -- HACK: Until we persist we need to get a new ID
        newId = (Dict.keys model.entities.users
                  |> last
                  |> withDefault 0) + 1

        updatedUsers = Dict.insert (newId) {thing | id = newId} model.entities.users

        updatedModel = model
                        |> set (entities => users) updatedUsers
      in
        ( updatedModel, Effects.none)

    SubmitModalEntity thing ->
      let
        updatedUsers = Dict.insert (thing.id) thing model.entities.users

        updatedModel = model
                        |> set (entities => users) updatedUsers
      in
        ( updatedModel, Effects.none)

    _ ->
      ( model, Effects.none )
