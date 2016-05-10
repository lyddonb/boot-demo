module Page2.Update (..) where

import Dict exposing (Dict)

import Effects exposing (Effects)

import Maybe exposing (withDefault)

import Form exposing (Form)

import List.Extra exposing (last)

import Layout.Actions exposing (..)

import Page2.Actions exposing (..)
import Page2.Models exposing (..)

update : Page2Action -> Page2Model -> ( Page2Model, Effects Page2Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    PageFormAction formAction ->
      ({ model | pageForm = Form.update formAction model.pageForm}, Effects.none)

    ModalFormAction formAction ->
      ({ model | modalForm = Form.update formAction model.modalForm}, Effects.none)

    SubmitPageEntity entity ->
      let
        -- HACK: Until we persist we need to get a new ID
        newId = (Dict.keys model.entities
                  |> last
                  |> withDefault 0) + 1

        updatedCollection = Dict.insert (newId) {entity | id = newId} model.entities
      in
        ({ model | pageEntity = Nothing
          , pageForm = Form.initial initialFields validate
          , entities = updatedCollection }, Effects.none)

    SubmitModalEntity entity ->
      let
        updatedCollection = Dict.insert (entity.id) entity model.entities
      in
        ( { model | modalEntity = Just entity, entities = updatedCollection }
        , Effects.none)

    EditEntity id ->
      case (Dict.get id model.entities) of
        Just entity ->
          ( { model | modalEntity = Just entity
            , modalForm = Form.initial (setFormFields entity) validate }
          , Effects.none )

        Nothing ->
          ( { model | modalEntity = Nothing
            , modalForm = Form.initial initialFields validate }
          , Effects.none )
