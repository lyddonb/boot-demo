module Thing.Update (..) where

import Debug

import Dict exposing (Dict)

import Effects exposing (Effects)

import Maybe exposing (withDefault)

import Form exposing (Form)

import List.Extra exposing (last)

import Page.Actions exposing (Action (SubmitPageEntity, SubmitModalEntity))
import Page.Update exposing (..)

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
          Page.Update.update pageAction model.page

        ( updatedModel, fx ) =
          updateForm pageAction { model | things = model.page.entities }

        updatedPageModel = { pageModel | entities = updatedModel.things }
      in
        ( { model | page = updatedPageModel }, fx )
        --, Effects.map PageAction fx )


updateForm : Page.Actions.Action Thing -> ThingModel -> ( ThingModel, Effects ThingAction )
updateForm action model =
  case action of

    SubmitPageEntity thing ->
      let
        -- HACK: Until we persist we need to get a new ID
        newId = (Dict.keys model.things
                  |> last
                  |> withDefault 0) + 1

        updatedCollection = Dict.insert (newId) {thing | id = newId} model.things
      in
        ( { model | things = updatedCollection 
          }
        , Effects.none)

    SubmitModalEntity thing ->
      let
        updatedCollection = Dict.insert (thing.id) thing model.things
      in
        ( { model | things = updatedCollection }
        , Effects.none)

    _ ->
      ( model, Effects.none )
