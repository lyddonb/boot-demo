module Layout.Components (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import Identifier exposing (ID)

import Layout.Actions exposing (..)
import Layout.Bootstrap exposing (..)
import Layout.Models exposing (..)

type alias FormComponent a e = Signal.Address Form.Action -> Signal.Address (LayoutAction a) -> Form e a -> Maybe a -> Html

type alias SubmitFormClick a e = Signal.Address Form.Action -> Signal.Address (LayoutAction a) -> Form e a -> (a -> (LayoutAction a)) -> Attribute 

type alias FieldsResult = (List ( String, Field.Field ))

type alias Table a e = Signal.Address (LayoutAction a) -> LayoutModel a e -> List Html.Html

panel : Signal.Address a -> m -> (Signal.Address a -> m -> Html) -> String -> Html
panel address model panelView title =
  div
    [ class "panel panel-default" ]
    [ div
      [ class "panel-heading" ]
      [ div
        [ class "panel-title" ]
        [ text title ]
      ]
    , div
      [ class "panel-body" ]
      [ panelView address model ]
    ]

listView : Table a e -> Signal.Address (LayoutAction a) -> LayoutModel a e -> Html
listView tab address model =
  div
    []
    [ div
      []
      [ modal address model
      , table
        [ class "table table-striped table-hover table-condensed" ]
        (tab address model)
      ]
    ]

editBtn : Signal.Address (LayoutAction a) -> { a | id : Identifier.ID } -> Html.Html
editBtn address model =
  button
    [ class "btn btn-primary btn-xs" 
    , type' "button"
    , attribute "data-toggle" "modal"
    , attribute "data-target" "#editModal"
    , onClick address (EditEntity model.id)
    ]
    [ i [class "fa fa-pencil mr1" ] [], text "Edit" ]

deleteBtn : Signal.Address (LayoutAction a) -> { a | id : Identifier.ID } -> Html.Html
deleteBtn address model =
  button
    [ class "btn btn-danger btn-xs" 
    --, onClick address (DeletePlayerIntent user) 
    ]
    [ i [class "fa fa-trash mr1" ] [], text "Delete" ]

modal : Signal.Address (LayoutAction a) -> LayoutModel a e -> Html
modal address model =
  div
    [ class "modal fade"
    , id "editModal"
    , attribute "tabindex" "-1"
    , attribute "role" "dialog"
    , attribute "aria-labelledby" "editModalLabel"
    , attribute "tabindex" "-1"
    ]
    [ div
      [ class "modal-dialog" 
      , attribute "role" "document" 
      ]
      [ div
        [ class "modal-content" ]
        (modalForm address model)
      ]
    ]

modalForm : Signal.Address (LayoutAction a) -> LayoutModel a e -> List Html
modalForm address model =
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
        [ text "Edit ..TODO..." ]
      ]
    , div
      [ class "modal-body" ]
      [ p
        []
        [ model.fieldsFunc formAddress model.modalForm ]
      ]
    , div
      [ class "modal-footer" ]
      [ modalFormHandler model formAddress ( submitClick formAddress address model.modalForm SubmitModalEntity )
      ]
    ]

modalFormHandler : LayoutModel a e -> Signal.Address Form.Action -> Attribute -> Html
modalFormHandler model address submit =
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
        [ onClick address (Form.Reset (model.resetFunc model.modalEntity))
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

pageForm : FieldsResult -> Signal.Address (LayoutAction a) -> LayoutModel a e -> Html
pageForm resetFields address model =
  let
    formAddress = (Signal.forwardTo address PageFormAction)
  in
    div
      []
      [ model.fieldsFunc formAddress model.pageForm 
      , formHandler resetFields formAddress (submitClick formAddress address model.pageForm SubmitPageEntity)
      ]

formHandler : FieldsResult -> Signal.Address Form.Action -> Attribute -> Html
formHandler resetFields address submit =
  formActions
  [ button
    [ submit
    , class "btn btn-primary"
    ]
    [ text "Submit" ]
  , text " "
  , button
    [ onClick address (Form.Reset resetFields)
    , class "btn btn-default"
    ]
    [ text "Reset" ]
  ]

submitClick : SubmitFormClick a e
submitClick formAddress address form submitAction =
  case Form.getOutput form of
    Just entity ->
      onClick address (submitAction entity)

    Nothing ->
      onClick formAddress Form.Submit
 
