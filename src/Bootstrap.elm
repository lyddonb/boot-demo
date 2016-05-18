module Bootstrap where

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)

import Form exposing (Form, FieldState, Action (Focus, Blur))
import Form.Input as Input exposing (..)
import Form.Error exposing (Error)
import Form.Field exposing (Field(Radio, Text))

row : List Html -> Html
row content =
  div [ class "row" ] content

col' : Int -> List Html -> Html
col' i content =
  div [ class ("col-xs-" ++ toString i) ] content


type alias GroupBuilder a e = String -> Signal.Address Form.Action -> FieldState e a -> Html


formGroup : String -> Maybe (Error e) -> List Html -> Html
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

hiddenInput : Input e String
hiddenInput =
  Input.baseInput "hidden" Text

spanGroup : GroupBuilder String e
spanGroup label' address state =
  formGroup label' state.liveError
    [ hiddenInput state address [ class "form-control" ]
    , span
        [ ]
        [ text (Maybe.withDefault "NEW" state.value) ]
    ]

textGroup : GroupBuilder String e
textGroup label' address state =
  formGroup label' state.liveError
    [ Input.textInput state address [ class "form-control" ] ]


textAreaGroup : GroupBuilder String e
textAreaGroup label' address state =
  formGroup label' state.liveError
    [ Input.textArea state address [ class "form-control" ] ]


checkboxGroup : GroupBuilder Bool e
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


selectGroup : List (String, String) -> GroupBuilder String e
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

radioGroup : List (String, String) -> GroupBuilder String e
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


errorMessage : Maybe (Error e) -> Html
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
