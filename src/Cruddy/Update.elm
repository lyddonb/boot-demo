module Cruddy.Update exposing (..)

import Form exposing (Form)

import Cruddy.Messages exposing (..)
import Cruddy.Models exposing (..)

update : Msg a -> Model a e -> ( Model a e, Cmd (Msg a) )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    PageFormMsg msg ->
      ({ model | pageForm = Form.update msg model.pageForm}, Cmd.none)

    ModalFormMsg msg ->
      ({ model | modalForm = Form.update msg model.modalForm}, Cmd.none)

    SubmitPageEntity entity ->
      ( { model | pageFormEntity = Nothing 
        , pageForm = Form.initial model.initialFields model.validation
        }
      , Cmd.none)

    SubmitModalEntity entity ->
      ( { model | modalFormEntity = Just entity
        , modalForm = Form.initial model.initialFields model.validation
        }
      , Cmd.none)

    EditEntity entity ->
      --case (Dict.get id model.entities) of
        --Just entity ->
      ( { model | modalFormEntity = Just entity
        , modalForm = Form.initial (model.setFormFields entity) model.validation }
      , Cmd.none )

        --Nothing ->
          --( { model | modalEntity = Nothing
            --, modalForm = Form.initial initialFields validate }
          --, Cmd.none )

    DeleteEntity entity ->
      ( model, Cmd.none )
