module Page1.Update (..) where

import Debug

import List exposing (head, filter, foldr)

import Effects exposing (Effects)

import Form exposing (Form)

import List.Extra exposing (find)

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
        newId = foldr (\a b -> if a.id > b then a.id else b) 0 model.users

        updatedCollection = 
          { user | id = newId + 1 } :: model.users
      in
        ({ model | pageUser = Nothing
          , pageForm = Form.initial initialFields validate
          , users = updatedCollection }, Effects.none)

    -- Save the modified user
    SubmitModalUser user ->
      let
        updatedUser existing =
          if existing.id == user.id then
             user
          else
             existing

        updatedCollection =
          List.map updatedUser model.users
      in
        ( { model | modalUser = Just user, users = updatedCollection }
        , Effects.none)

    -- Edit an existing user
    EditUser userId ->
      case (find (\u -> u.id == userId) model.users) of
        Just user ->
          ( { model | modalUser = Just user
            , modalForm = Form.initial (setFormFields user) validate }
          , Effects.none )

        Nothing ->
          ( { model | modalUser = Nothing
            , modalForm = Form.initial initialFields validate }
          , Effects.none )
