module Cruddy.Components (..) where

import Dict exposing (Dict)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)

import Cruddy.Actions exposing (..)
import Bootstrap exposing (..)
import Cruddy.Models exposing (..)

type alias Component a e = Signal.Address (Action a) -> Model a e -> Html

page : Signal.Address (Action a) -> Model a e -> Html
page address model =
  div 
    [ class "container" ] 
    [ panel ("Add a " ++ model.title.single) pageForm address model
    , panel ("View " ++ model.title.plural) listView address model
    ]

panel : String -> Component a e -> Signal.Address (Action a) -> Model a e -> Html
panel title component address model =
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
      [ component address model 
      ]
    ]

listView : Component a e
listView address model =
  div
    []
    [ div
      []
      [ modal address model
      , table
        [ class "table table-striped table-hover table-condensed" ]
        (entityTable address model)
      ]
    ]

entityTable : Signal.Address (Action a) -> Model a e -> List Html.Html
entityTable address model =
  [ thead
    []
    [ tr
      []
      (tableHeaders address model)
    ]
    , model.entityAccessor model.entities
      |> Dict.values
      |> List.reverse
      |> List.map (tableRow address model)
      |> tbody []
  ]

tableHeaders : Signal.Address (Action a) -> Model a e -> List Html.Html
tableHeaders address model =
  List.append (List.map (\n -> fst n |> tableHeader) model.listFields) [ th [] [ text "Actions" ] ]

tableRow : Signal.Address (Action a) -> Model a e -> a -> Html.Html
tableRow address model entity =
  tr
    []
    (List.append (List.map (\n -> snd n |> tableCell entity) model.listFields) [ td [] [ editBtn address entity
   , deleteBtn address entity 
   ] 
   ])

editBtn : Signal.Address (Action a) -> a -> Html.Html
editBtn address model =
  button
    [ class "btn btn-primary btn-xs" 
    , type' "button"
    , attribute "data-toggle" "modal"
    , attribute "data-target" "#editModal"
    , onClick address (EditEntity model)
    ]
    [ i [class "fa fa-pencil mr1" ] [], text "Edit" ]

deleteBtn : Signal.Address (Action a) -> a -> Html.Html
deleteBtn address model =
  button
    [ class "btn btn-danger btn-xs" 
    , onClick address (DeleteEntity model) 
    ]
    [ i [class "fa fa-trash mr1" ] [], text "Delete" ]

tableCell : a -> ListField a -> Html
tableCell entity fieldF =
  td [] [ fieldF entity ]

tableHeader : String -> Html
tableHeader label =
  th [] [ text label ]

modal : Signal.Address (Action a) -> Model a e -> Html
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

modalForm : Signal.Address (Action a) -> Model a e -> List Html
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
        [ model.fields formAddress model.entities model.modalForm 
        ]
      ]
    , div
      [ class "modal-footer" ]
      [ modalFormHandler address model 
      ]
    ]

pageForm : Component a e
pageForm address model =
  let
    formAddress = (Signal.forwardTo address PageFormAction)
  in
    div
      []
      [ model.fields formAddress model.entities model.pageForm 
      , formHandler address model
      ]

formHandler : Signal.Address (Action a) -> Model a e -> Html
formHandler address {pageForm, pageFormEntity, initialFields} =
  let
    formAddress = (Signal.forwardTo address PageFormAction)

    submitClick =
    case Form.getOutput pageForm of
      Just pageFormEntity ->
        onClick address (SubmitPageEntity pageFormEntity)

      Nothing ->
        onClick formAddress Form.Submit
  in
    formActions
    [ button
      [ class "btn btn-primary"
      , submitClick
      ]
      [ text "Submit" ]
    , text " "
    , button
      [ onClick formAddress (Form.Reset initialFields)
      , class "btn btn-default"
      ]
      [ text "Reset" ]
    ]

modalFormHandler : Signal.Address (Action a) -> Model a e -> Html
modalFormHandler address model =
  let
    resetFunc = 
    case model.modalFormEntity of
      Just entity ->
        model.setFormFields entity
    
      Nothing ->
        model.initialFields

    formAddress = (Signal.forwardTo address ModalFormAction)

    submitClick =
    case Form.getOutput model.modalForm of
      Just modalFormEntity ->
        onClick address (SubmitModalEntity modalFormEntity)

      Nothing ->
        onClick formAddress Form.Submit
  in
    div
      []
      [
        formActions
        [ button
          [ submitClick
          , class "btn btn-primary"
          , attribute "data-dismiss" "modal"
          ]
          [ text "Submit" ]
        --, text " "
        , button
          [ onClick formAddress (Form.Reset resetFunc)
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
