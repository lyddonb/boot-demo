module Thing.Components (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import Page.Bootstrap exposing (..)

fieldsCompoment : Signal.Address Form.Action -> Form e a -> Html
fieldsCompoment address form =
  div
    [ class "form-horizontal" ]
    [ spanGroup "Id" address
      (Form.getFieldAsString "id" form)
      
    , textGroup "Name" address
      (Form.getFieldAsString "name" form)

    , textGroup "User" address
      (Form.getFieldAsString "userId" form)
    --, selectGroup roleOptions "Role" formAddress
      --(Form.getFieldAsString "profile.role" form)

    ]

--thingTable : Signal.Address ThingAction -> ThingModel -> List Html.Html
--thingTable address model =
  --[ thead
    --[]
    --[ tr
      --[]
      --[ th [] [ text "Id" ]
      --, th [] [ text "Name" ]
      --, th [] [ text "User" ]
      --, th [] [ text "Actions" ]
      --]
    --]
    --, Dict.values model.entities
      --|> List.reverse
      --|> List.map (thingRow address model)
      --|> tbody []
  --]

--thingRow : Signal.Address ThingAction -> ThingModel -> Thing -> Html.Html
--thingRow address model thing =
  --tr
    --[]
    --[ td [] [ text (toString thing.id) ]
    --, td [] [ text thing.name ]
    --, td [] [ text (toString thing.userId) ]
    --, td 
        --[] 
        --[ editBtn address thing
        --, deleteBtn address thing
        --]
    --]
