module Bootstrap exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)

import Json.Decode as Json

import Form exposing (Form, FieldState, Msg (Focus, Blur))
import Form.Input as Input exposing (..)
import Form.Error exposing (Error)
import Form.Field exposing (Field(Radio, Text))

container : List (Html msg) -> Html msg
container content =
  div [ class "container" ] content

row : List (Html msg) -> Html msg
row content =
  div [ class "row" ] content

col' : Int -> List (Html Msg) -> Html Msg
col' i content =
  div [ class ("col-xs-" ++ toString i) ] content


type alias GroupBuilder a e = String -> FieldState e a -> Html Msg


formGroup : String -> Maybe (Error e) -> List (Html Msg) -> Html Msg
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


formActions : List (Html msg) -> Html msg
formActions content =
  row
    [ div [ class "col-xs-offset-3 col-xs-9" ] content ]

hiddenInput : Input e String
hiddenInput =
  Input.baseInput "hidden" Text

spanGroup : GroupBuilder String e
spanGroup label' state =
  formGroup label' state.liveError
    [ hiddenInput state [ class "form-control" ]
    , span
        [ ]
        [ text (Maybe.withDefault "NEW" state.value) ]
    ]

textGroup : GroupBuilder String e
textGroup label' state =
  formGroup label' state.liveError
    [ Input.textInput state [ class "form-control" ] ]


textAreaGroup : GroupBuilder String e
textAreaGroup label' state =
  formGroup label' state.liveError
    [ Input.textArea state [ class "form-control" ] ]


checkboxGroup : GroupBuilder Bool e
checkboxGroup label' state =
  formGroup "" state.liveError
    [ div
        [ class "checkbox" ]
        [ label []
            [ Input.checkboxInput state []
            , text label'
            ]
        ]
    ]


selectGroup : List (String, String) -> GroupBuilder String e
selectGroup options label' state =
  formGroup label' state.liveError
    [ Input.selectInput options state [ class "form-control" ] ]

{-| Fixed Radio input.
  TODO: Fix up the form repo and PR back
-}
fixedRadioInput : String -> Input e String
fixedRadioInput value state attrs =
  let
    formAttrs =
      [ type' "radio"
      , HtmlAttr.name state.path
      , checked (state.value == Just value)
      , onFocus (Focus state.path)
      , onBlur (Blur state.path)
      , on
          "change"
          (targetValue |> Json.map (Radio >> (Form.Input state.path)))
      ]
  in
    input (formAttrs ++ attrs) []

radioGroup : List (String, String) -> GroupBuilder String e
radioGroup options label' state =
  let
    item (v, l) =
      label
        [ class "radio-inline" ]
        [ Input.radioInput v state [ value v ]
        , text l
        ]
  in
    formGroup label' state.liveError
      (List.map item options)


errorClass : Maybe error -> String
errorClass maybeError =
  Maybe.map (\_ -> "has-error") maybeError |> Maybe.withDefault ""


errorMessage : Maybe (Error e) -> Html Msg
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
