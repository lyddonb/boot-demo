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
