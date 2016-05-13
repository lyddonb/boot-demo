module Page.Update (..) where

import Dict exposing (Dict)

import Effects exposing (Effects)

import Form exposing (Form)

import Page.Actions exposing (..)
import Page.Models exposing (..)

update : Action a -> Model a e -> ( Model a e, Effects (Action a))
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    PageFormAction formAction ->
      ({ model | pageForm = Form.update formAction model.pageForm}, Effects.none)

    ModalFormAction formAction ->
      ({ model | modalForm = Form.update formAction model.modalForm}, Effects.none)

    SubmitPageEntity entity ->
      ( { model | pageFormEntity = Nothing 
        , pageForm = Form.initial model.initialFields model.validation
        }
      , Effects.none)

    SubmitModalEntity entity ->
      ( { model | modalFormEntity = Just entity
        , modalForm = Form.initial model.initialFields model.validation
        }
      , Effects.none)

    EditEntity entity ->
      --case (Dict.get id model.entities) of
        --Just entity ->
      ( { model | modalFormEntity = Just entity
        , modalForm = Form.initial (model.setFormFields entity) model.validation }
      , Effects.none )

        --Nothing ->
          --( { model | modalEntity = Nothing
            --, modalForm = Form.initial initialFields validate }
          --, Effects.none )

    DeleteEntity entity ->
      ( model, Effects.none )
