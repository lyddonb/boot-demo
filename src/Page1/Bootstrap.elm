module Page1.Bootstrap where

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)

import Form exposing (Form, FieldState, Action (Focus, Blur))
import Form.Input as Input exposing (..)
import Form.Error exposing (Error)
import Form.Field exposing (Field(Radio))

import Page1.Models exposing (..)

row : List Html -> Html
row content =
  div [ class "row" ] content

col' : Int -> List Html -> Html
col' i content =
  div [ class ("col-xs-" ++ toString i) ] content


type alias GroupBuilder a = String -> Signal.Address Form.Action -> FieldState CustomError a -> Html


formGroup : String -> Maybe (Error CustomError) -> List Html -> Html
formGroup label' maybeError inputs =
  div
    [ class ("row form-group " ++ (errorClass maybeError)) ]
    [ col' 3
        [ label [ class "control-label" ] [ text label' ] ]
    , col' 5
         inputs
    , col' 4
        [ errorMessage maybeError ]
    ]


formActions : List Html -> Html
formActions content =
  row
    [ div [ class "col-xs-offset-3 col-xs-9" ] content ]


textGroup : GroupBuilder String
textGroup label' address state =
  formGroup label' state.liveError
    [ Input.textInput state address [ class "form-control" ] ]


textAreaGroup : GroupBuilder String
textAreaGroup label' address state =
  formGroup label' state.liveError
    [ Input.textArea state address [ class "form-control" ] ]


checkboxGroup : GroupBuilder Bool
checkboxGroup label' address state =
  formGroup "" state.liveError
    [ div
        [ class "checkbox" ]
        [ label []
            [ Input.checkboxInput state address []
            , text label'
            ]
        ]
    ]


selectGroup : List (String, String) -> GroupBuilder String
selectGroup options label' address state =
  formGroup label' state.liveError
    [ Input.selectInput options state address [ class "form-control" ] ]

{-| Fixed Radio input.
  TODO: Fix up the form repo and PR back
-}
fixedRadioInput : String -> Input e String
fixedRadioInput value state addr attrs =
  let
    formAttrs =
      [ type' "radio"
      , HtmlAttr.name state.path
      , checked (state.value == Just value)
      , onFocus addr (Focus state.path)
      , onBlur addr (Blur state.path)
      , on
          "change"
          targetValue
          (\v -> Signal.message addr (Form.Input state.path (Radio v)))
      ]
  in
    input (formAttrs ++ attrs) []

radioGroup : List (String, String) -> GroupBuilder String
radioGroup options label' address state =
  let
    item (v, l) =
      label
        [ class "radio-inline" ]
        [ Input.radioInput v state address [ value v ]
        , text l
        ]
  in
    formGroup label' state.liveError
      (List.map item options)


errorClass : Maybe error -> String
errorClass maybeError =
  Maybe.map (\_ -> "has-error") maybeError |> Maybe.withDefault ""


errorMessage : Maybe (Error CustomError) -> Html
errorMessage maybeError =
  case maybeError of
    Just error ->
      p
        [ class "help-block" ]
        [ text (toString error) ]
    Nothing ->
      span
        [ class "help-block" ]
        [ text " " ] -- &#8199;
