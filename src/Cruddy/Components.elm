module Cruddy.Components exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import Bootstrap exposing (..)

import Cruddy.Messages exposing (Msg(..))
import Cruddy.Models exposing (..)

type alias FormFields a e = (Form e a -> Html Form.Msg)
type alias RowFields a = (a -> List (Html (Msg a)))

type alias CruddyPage a e =
  { newTitle : String
  , listTitle : String
  , formFields : FormFields a e
  , headers : List String
  , rowFields : RowFields a 
  }

initializeCruddy : String -> String -> FormFields a e -> List String -> RowFields a -> CruddyPage a e
initializeCruddy newTitle listTitle formFields headers rowFields = 
  { newTitle = newTitle
  , listTitle = listTitle
  , formFields = formFields
  , headers = headers
  , rowFields = rowFields
  }

page : CruddyPage a e -> Model a e -> Html (Msg a)
page cp model =
  container 
    [ panel ("Add a " ++ cp.newTitle) (newForm cp.formFields model)
    , panel ("View " ++ cp.listTitle) (listView cp model) 
    ]

panel : String -> Html msg -> Html (msg)
panel title content =
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
      [ content ] 
    ]

newForm : FormFields a e -> Model a e -> Html (Msg a)
newForm fields model =
  div
    []
    [ App.map FormMsg (fields model.form)
    , formHandler model.form model.initialFields
    ]

formHandler : Form e a -> List ( String, Field.Field ) -> Html (Msg a)
formHandler pageForm initialFields =
  let
    submitClick =
    case Form.getOutput pageForm of
      Just pageFormEntity ->
        onClick (SubmitEntity pageFormEntity)

      Nothing ->
        onClick (FormMsg Form.Submit)
  in
    formActions
    [ button
      [ class "btn btn-primary"
      , submitClick
      ]
      [ text "Submit" ]
    , text " "
    , button
      [ onClick (FormMsg (Form.Reset initialFields))
      , class "btn btn-default"
      ]
      [ text "Reset" ]
    ]

listView : CruddyPage a e -> Model a e -> Html (Msg a)
listView cp model =
  div
    []
    [ div
      []
      [ editForm cp.formFields model
      , listTable cp model
      ]
    ]

listTable : CruddyPage a e -> Model a e -> Html (Msg a)
listTable cp model =
  table
    [ class "table table-striped table-hover table-condensed" ]
    [ thead
      []
      [ tr
        []
        (tableHeaders cp.headers)
      ]
      , tbody [] (List.map tableRow (rows model.listItems cp.rowFields))
    ]

editForm : (Form e a -> Html Form.Msg) -> Model a e -> Html (Msg a)
editForm formFields model =
  let
    form = App.map EditFormMsg (formFields model.editForm)
  in
    modal form model

modal : Html (Msg a) -> Model a e -> Html (Msg a)
modal form model =
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
            [ form ]
          ]
        , div
          [ class "modal-footer" ]
          [ modalFormHandler model 
          ]
        ]
      ]
    ]

modalFormHandler : Model a e -> Html (Msg a)
modalFormHandler model =
  let
    resetFunc = 
    case model.editEntityMaybe of
      Just entity ->
        model.setEditFormFields entity

      Nothing ->
        model.initialFields


    submitClick =
    case Form.getOutput model.editForm of
      Just modalFormEntity ->
        onClick (SubmitEditEntity (Debug.log "Form ent" modalFormEntity))

      Nothing ->
        onClick (EditFormMsg Form.Submit)
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
          [ onClick (EditFormMsg (Form.Reset resetFunc))
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

rows : List a -> (a -> List (Html (Msg a))) -> List (List (Html (Msg a)))
rows items rowFunc =
  items
  |> List.reverse
  |> List.map (\a -> rowWithButtons a rowFunc)

rowWithButtons : a -> (a -> List (Html (Msg a))) -> List (Html (Msg a))
rowWithButtons entity rowFunc =
    (List.append (rowFunc entity) [ editBtn entity 
                                  , deleteBtn entity 
                                  ]
    )

tableRow : List (Html msg) -> Html msg
tableRow content =
  tr
    []
    content

tableCell : Html msg -> Html msg
tableCell content =
  td [] [ content ]

editBtn : a -> Html (Msg a)
editBtn entity =
  button
    [ class "btn btn-primary btn-xs" 
    , type' "button"
    , attribute "data-toggle" "modal"
    , attribute "data-target" "#editModal"
    , onClick (EditEntity entity)
    ]
    [ i [class "fa fa-pencil mr1" ] [], text "Edit" ]

deleteBtn : a -> Html (Msg a)
deleteBtn model =
  button
    [ class "btn btn-danger btn-xs" 
    , onClick (DeleteEntity model) 
    ]
    [ i [class "fa fa-trash mr1" ] [], text "Delete" ]

tableHeaders : List String -> List (Html msg)
tableHeaders headers =
  List.append (List.map tableHeader headers) [ th [] [ text "Actions" ] ]

tableHeader : String -> Html msg
tableHeader label =
  th [] [ text label ]
