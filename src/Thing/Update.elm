module Thing.Update (..) where

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

import Thing.Actions exposing (..)
import Thing.Models exposing (..)

update : ThingAction -> ThingModel -> ( ThingModel, Effects ThingAction )
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

        --updatedPageModel = { pageModel | entities = updatedModel.things }
      in
        ( updatedModel, fx )
        --, Effects.map PageAction fx )


updateForm : Cruddy.Actions.Action Thing -> ThingModel -> ( ThingModel, Effects ThingAction )
updateForm action model =
  case action of

    SubmitPageEntity thing ->
      let
        -- HACK: Until we persist we need to get a new ID
        newId = (Dict.keys model.entities.things
                  |> last
                  |> withDefault 0) + 1

        updatedThings = Dict.insert (newId) {thing | id = newId} model.entities.things

        updatedModel = model
                        |> set (entities => things) updatedThings
      in
        ( updatedModel, Effects.none)

    SubmitModalEntity thing ->
      let
        updatedThings = Dict.insert (thing.id) thing model.entities.things

        updatedModel = model
                        |> set (entities => things) updatedThings
      in
        ( updatedModel, Effects.none)

    _ ->
      ( model, Effects.none )
