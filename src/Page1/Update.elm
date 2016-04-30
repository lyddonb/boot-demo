module Page1.Update (..) where

import Debug

import Effects exposing (Effects)

import Form exposing (Form)

import Page1.Actions exposing (..)
import Page1.Models exposing (..)

update : Page1Action -> Page1Model -> ( Page1Model, Effects Page1Action )
update action model =
  case (Debug.log "Action: " action) of
    NoOp ->
      ( model, Effects.none )

    PageFormAction formAction ->
      ({ model | pageForm = Form.update formAction model.pageForm}, Effects.none)

    ModalFormAction formAction ->
      ({ model | modalForm = Form.update formAction model.modalForm}, Effects.none)

    SubmitPageUser user ->
      let
        updatedCollection = 
          user :: model.users
      in
        ({ model | pageUser = Just user, users = updatedCollection }, Effects.none)

    SubmitModalUser user ->
      let
        updatedCollection = 
          user :: model.users
      in
        ({ model | modalUser = Just user, users = updatedCollection }, Effects.none)

    EditUser user ->
      ( { model | modalUser = Just user
        , modalForm = Form.initial (setFormFields user) validate }
      , Effects.none )
