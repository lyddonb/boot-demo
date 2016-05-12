module Page.Components (..) where

import Dict exposing (Dict)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)

import Page.Actions exposing (..)
import Page.Bootstrap exposing (..)
import Page.Models exposing (..)

type alias Component a e = Signal.Address (Action a) -> Model a e -> Html

page : Signal.Address (Action a) -> Model a e -> Html
page address model =
  div 
    [ class "container" ] 
    [ panel pageForm address model
    , panel listView address model
    --, panel address model (listView thingTable) "View Things"
    ]

panel : Component a e -> Signal.Address (Action a) -> Model a e -> Html
panel component address model =
  div
    [ class "panel panel-default" ]
    [ div
      [ class "panel-heading" ]
      [ div
        [ class "panel-title" ]
        [ text model.title ]
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
      [ -- modal address model
      --, table
        table
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
    , Dict.values model.entities
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

pageForm : Component a e
pageForm address model =
  let
    formAddress = (Signal.forwardTo address PageFormAction)
  in
    div
      []
      [ model.fields formAddress model.pageForm 
      , formHandler address model
      --, formHandler resetFields formAddress (submitClick formAddress address model.pageForm SubmitPageEntity)
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
