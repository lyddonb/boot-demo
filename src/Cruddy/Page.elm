module Cruddy.Page exposing (..)

import Dict exposing (Dict)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (..)

import Form exposing (Form)

import Bootstrap exposing (..)

import Cruddy.Messages exposing (..)
import Cruddy.Models exposing (..)

type alias Component a e = Model a e -> Html (Msg a)

page : Model a e -> Html (Msg a)
page model =
  div 
    [ class "container" ] 
    [ panel ("Add a " ++ model.title.single) pageForm model
    , panel ("View " ++ model.title.plural) listView model
    ]

panel : String -> Component a e -> Model a e -> Html (Msg a)
panel title component model =
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
      [ component model 
      ]
    ]

listView : Component a e
listView model =
  div
    []
    [ div
      []
      [ modal model
      , table
        [ class "table table-striped table-hover table-condensed" ]
        (entityTable model)
      ]
    ]

entityTable : Model a e -> List (Html (Msg a))
entityTable model =
  [ thead
    []
    [ tr
      []
      (tableHeaders model)
    ]
    , model.entityAccessor model.entities
      |> Dict.values
      |> List.reverse
      |> List.map (tableRow model)
      |> tbody []
  ]

tableRow : Model a e -> a -> Html (Msg a)
tableRow model entity =
  tr
    []
    (List.append (List.map (\n -> snd n |> tableCell entity) model.listFields) [ td [] [ editBtn entity
   , deleteBtn entity 
   ] 
   ])

tableCell : a -> ListField a -> Html (Msg a)
tableCell entity fieldF =
  td [] [ fieldF entity ]

editBtn : a -> Html (Msg a)
editBtn model =
  button
    [ class "btn btn-primary btn-xs" 
    , type' "button"
    , attribute "data-toggle" "modal"
    , attribute "data-target" "#editModal"
    , onClick (EditEntity model)
    ]
    [ i [class "fa fa-pencil mr1" ] [], text "Edit" ]

deleteBtn : a -> Html (Msg a)
deleteBtn model =
  button
    [ class "btn btn-danger btn-xs" 
    , onClick (DeleteEntity model) 
    ]
    [ i [class "fa fa-trash mr1" ] [], text "Delete" ]

tableHeaders : Model a e -> List (Html (Msg a))
tableHeaders model =
  List.append (List.map (\n -> fst n |> tableHeader) model.listFields) [ th [] [ text "Actions" ] ]

tableHeader : String -> Html (Msg a)
tableHeader label =
  th [] [ text label ]

modal : Model a e -> Html (Msg a)
modal model =
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
        (modalForm model)
      ]
    ]

modalForm : Model a e -> List (Html (Msg a))
modalForm model =
  [ div
    [ class "modal-header" ]
    [ button
      [ class "close"
      , attribute "data-dismiss" "modal"
      , attribute "aria-label" "Close"
      ]
      [ span
        [ attribute "aria-hidden" "true" ]
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
      [ model.fields model.entities model.modalForm 
      ]
    ]
  , div
    [ class "modal-footer" ]
    [ modalFormHandler model 
    ]
  ]

modalFormHandler : Model a e -> Html (Msg a)
modalFormHandler model =
  let
    resetFunc = 
    case model.modalFormEntity of
      Just entity ->
        model.setFormFields entity
    
      Nothing ->
        model.initialFields

    submitClick =
    case Form.getOutput model.modalForm of
      Just modalFormEntity ->
        onClick (SubmitModalEntity (Debug.log "Form ent" modalFormEntity))

      Nothing ->
        onClick (ModalFormMsg Form.Submit)
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
          [ onClick (ModalFormMsg (Form.Reset resetFunc))
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

pageForm : Component a e 
pageForm model =
  div
    []
    [ model.fields model.entities model.pageForm 
    , formHandler model
    ]

formHandler :  Model a e -> Html (Msg a)
formHandler {pageForm, pageFormEntity, initialFields} =
  let
    submitClick =
    case Form.getOutput pageForm of
      Just pageFormEntity ->
        onClick (SubmitPageEntity pageFormEntity)

      Nothing ->
        onClick (PageFormMsg Form.Submit)
  in
    formActions
    [ button
      [ class "btn btn-primary"
      , submitClick
      ]
      [ text "Submit" ]
    , text " "
    , button
      [ onClick (PageFormMsg (Form.Reset initialFields))
      , class "btn btn-default"
      ]
      [ text "Reset" ]
    ]
