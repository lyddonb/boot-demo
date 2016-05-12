module Page.Update (..) where

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

    SubmitPageEntity entity ->
      ( { model | pageFormEntity = Nothing 
        , pageForm = Form.initial model.initialFields model.validation
        }
      , Effects.none)

    EditEntity entity ->
      ( model, Effects.none )

    DeleteEntity entity ->
      ( model, Effects.none )
