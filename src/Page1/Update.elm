module Page1.Update (..) where

import Debug

import Dict exposing (Dict)

import Effects exposing (Effects)

import Maybe exposing (withDefault)

import Form exposing (Form)

import List.Extra exposing (find, last)

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

    -- Save the new user
    SubmitPageUser user ->
      let
        -- HACK: Until we persist we need to get a new ID
        newId = (Dict.keys model.users
                  |> last
                  |> withDefault 0) + 1

        updatedCollection = Dict.insert (newId) {user | id = newId} model.users
      in
        ({ model | pageUser = Nothing
          , pageForm = Form.initial initialFields validate
          , users = updatedCollection }, Effects.none)

    -- Save the modified user
    SubmitModalUser user ->
      let
        updatedCollection = Dict.insert (user.id) user model.users
      in
        ( { model | modalUser = Just user, users = updatedCollection }
        , Effects.none)

    -- Edit an existing user
    EditUser userId ->
      case (Dict.get userId model.users) of
        Just user ->
          ( { model | modalUser = Just user
            , modalForm = Form.initial (setFormFields user) validate }
          , Effects.none )

        Nothing ->
          ( { model | modalUser = Nothing
            , modalForm = Form.initial initialFields validate }
          , Effects.none )
