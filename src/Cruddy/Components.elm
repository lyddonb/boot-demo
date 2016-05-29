module Cruddy.Components exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import Bootstrap exposing (..)

page : List (Html msg) -> Html msg
page content =
  container content

panel : String -> List (Html msg) -> Html (msg)
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
      content 
    ]

formHandler : Attribute msg -> (Form.Msg -> msg) -> List ( String, Field.Field ) -> Html msg
formHandler submitClick formMsg initialFields =
    formActions
    [ button
      [ class "btn btn-primary"
      , submitClick
      ]
      [ text "Submit" ]
    , text " "
    , button
      [ onClick (formMsg (Form.Reset initialFields))
      , class "btn btn-default"
      ]
      [ text "Reset" ]
    ]

listView : List String -> List a -> (a -> List (Html msg)) -> Html msg
listView headers items rowFunc =
  div
    []
    [ div
      []
      [ --modal model
      --, table
      table
        [ class "table table-striped table-hover table-condensed" ]
        [ thead
          []
          [ tr
            []
            (tableHeaders headers)
          ]
          , tbody [] (List.map tableRow (rows items rowFunc))
        ]
      ]
    ]

rows : List a -> (a -> List (Html msg)) -> List (List (Html msg))
rows items rowFunc =
  items
  |> List.reverse
  |> List.map rowFunc

tableRow : List (Html msg) -> Html msg
tableRow content =
  tr
    []
    content
    -- TODO: Add row buttons

tableCell : Html msg -> Html msg
tableCell content =
  td [] [ content ]

--editBtn : a -> Html msg
--editBtn model =
  --button
    --[ class "btn btn-primary btn-xs" 
    --, type' "button"
    --, attribute "data-toggle" "modal"
    --, attribute "data-target" "#editModal"
    --, onClick (EditEntity model)
    --]
    --[ i [class "fa fa-pencil mr1" ] [], text "Edit" ]

--deleteBtn : a -> Html msg
--deleteBtn model =
  --button
    --[ class "btn btn-danger btn-xs" 
    --, onClick (DeleteEntity model) 
    --]
    --[ i [class "fa fa-trash mr1" ] [], text "Delete" ]

tableHeaders : List String -> List (Html msg)
tableHeaders headers =
  List.append (List.map tableHeader headers) [ th [] [ text "Actions" ] ]

tableHeader : String -> Html msg
tableHeader label =
  th [] [ text label ]
