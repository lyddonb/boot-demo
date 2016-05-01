module Page1.Form (..) where

import String exposing (toUpper)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Input

import Page1.Actions exposing (..)
import Page1.Bootstrap exposing (..)
import Page1.Models exposing (..)
import Page1.Update exposing (..)

modalForm : Signal.Address Page1Action -> Page1Model -> List Html
modalForm address {modalForm, modalUser} =
  let
    formAddress = (Signal.forwardTo address ModalFormAction)
  in
    [ div
      [ class "modal-header" ]
      [ button
        [ class "close"
        , attribute "data-dismiss" "modal"
        , attribute "aria-label" "Close"
        ]
        [ span
          [ attribute "aria-hidden" "true" ]
          --[ text "&times;" ]
          [ text "×" ]
        ]
      , h4
        [ class "modal-title"
        , id "userEditModalLabel"
        ]
        [ text "Edit User" ]
      ]
    , div
      [ class "modal-body" ]
      [ p
        []
        [ formComponent formAddress address modalForm modalUser ]
      ]
    , div
      [ class "modal-footer" ]
      [ modalFormHandler formAddress (
        submitClick formAddress address modalForm SubmitModalUser)
        modalUser
      ]
    ]

pageForm : Signal.Address Page1Action -> Page1Model -> Html
pageForm address {pageForm, pageUser} =
  let
    formAddress = (Signal.forwardTo address PageFormAction)
  in
    div
      []
      [ formComponent formAddress address pageForm pageUser 
      , formHandler formAddress (submitClick formAddress address pageForm SubmitPageUser)
      ]

type alias SubmitFormClick a = Signal.Address Form.Action -> Signal.Address Page1Action -> Form CustomError a -> (a -> Page1Action) -> Attribute 

submitClick : SubmitFormClick a
submitClick formAddress address form submitAction =
  case Form.getOutput form of
    Just user ->
      onClick address (submitAction user)

    Nothing ->
      onClick formAddress Form.Submit
 
formComponent : Signal.Address Form.Action -> Signal.Address Page1Action -> Form CustomError a -> Maybe a -> Html
formComponent formAddress address form userMaybe =
  let
    roleOptions =
      ("", "--") :: (List.map (\i -> (i, String.toUpper i)) roles)

    superpowerOptions =
      List.map (\i -> (i, String.toUpper i)) superpowers

 in
    div
      [ class "form-horizontal" ]
      [ spanGroup "Id" formAddress
        (Form.getFieldAsString "id" form)
        
      , textGroup "Name" formAddress
        (Form.getFieldAsString "name" form)

      , textGroup "Email address" formAddress
        (Form.getFieldAsString "email" form)

      , checkboxGroup "Administrator" formAddress
        (Form.getFieldAsBool "admin" form)

      , textGroup "Website" formAddress
        (Form.getFieldAsString "profile.website" form)

      , selectGroup roleOptions "Role" formAddress
        (Form.getFieldAsString "profile.role" form)

      , radioGroup superpowerOptions "Superpower" formAddress
        (Form.getFieldAsString "profile.superpower" form)

      , textGroup "Age" formAddress
        (Form.getFieldAsString "profile.age" form)

      , textAreaGroup "Bio" formAddress
        (Form.getFieldAsString "profile.bio" form)

      --, case userMaybe of
          --Just user ->
            --p [ class "alert alert-success" ] [ text (toString user) ]
          --Nothing ->
            --text ""
      ]

formHandler : Signal.Address Form.Action -> Attribute -> Html
formHandler address submit =
  formActions
  [ button
    [ submit
    , class "btn btn-primary"
    ]
    [ text "Submit" ]
  , text " "
  , button
    [ onClick address (Form.Reset initialFields)
    , class "btn btn-default"
    ]
    [ text "Reset" ]
  ]

modalFormHandler : Signal.Address Form.Action -> Attribute -> Maybe User -> Html
modalFormHandler address submit maybeUser =
  let
    reset = case maybeUser of 
      Just user ->
        setFormFields user
      Nothing ->
        initialFields
  in
    div
      []
      [
        formActions
        [ button
          [ submit
          , class "btn btn-primary"
          , attribute "data-dismiss" "modal"
          ]
          [ text "Submit" ]
        --, text " "
        , button
          [ onClick address (Form.Reset reset)
          , class "btn btn-default"
          ]
          [ text "Reset" ]
        , button
          [ class "btn btn-default"
          , type' "button"
          , attribute "data-dismiss" "modal"
          ]
          [ text "Close" ]
        ]
      ]
