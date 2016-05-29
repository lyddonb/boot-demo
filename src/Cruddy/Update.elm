module Cruddy.Update exposing (..)

import Form exposing (Form)

import Cruddy.Messages exposing (..)
import Cruddy.Models exposing (..)

update : Msg a -> Model a e -> ( Model a e, Cmd (Msg a) )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    FormMsg msg ->
      ({ model | form = Form.update msg model.form}, Cmd.none)

    EditFormMsg msg ->
      ({ model | editForm = Form.update msg model.editForm}, Cmd.none)

    SubmitEntity entity ->
      ( { model | entityMaybe = Nothing 
        , form = Form.initial model.initialFields model.validation
        }
      , Cmd.none)

    SubmitEditEntity entity ->
      ( { model | editEntityMaybe = Just entity
        , editForm = Form.initial model.initialFields model.validation
        }
      , Cmd.none)

    EditEntity entity ->
      ( { model | editEntityMaybe = Just entity
        , editForm = Form.initial (model.setEditFormFields entity) model.validation }
      , Cmd.none )

    DeleteEntity entity ->
      ( model, Cmd.none )
