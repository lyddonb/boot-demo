module Page.Components (..) where

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

pageForm : Signal.Address (Action a) -> Model a e -> Html
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
