module Users.View exposing (..)

import Dict exposing (Dict)

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field

import Bootstrap exposing (..)
--import Cruddy.Page as CruddyPage
import Cruddy.Components exposing (..)

import Entities exposing (..)

import Users.Models exposing (..)
import Users.Messages exposing (Msg(..))

view : Model -> Html Msg
view model =
  page [ panel "Add a User" [ form model ]
       , panel "List Users" [ listView (headers) (Dict.values model.entities.users) row ]
       ]
  --App.map PageMsg (CruddyPage.page model)

form : Model -> Html Msg 
form model =
  div
    []
    [ App.map FormMsg (formFields model)
    , formHandler (submitClick model.form) FormMsg initialFields
    ]

row : User -> List (Html Msg)
row user =
  [ user.id |> toString |> text |> tableCell
  , user.name |> text |> tableCell
  , user.email |> text |> tableCell
  , user.admin |> toString |> text |> tableCell
  ]

headers : List String
headers = 
  [ "Id"
  , "Name"
  , "Email"
  , "Admin"
  ]

submitClick : Form a User -> Attribute Msg
submitClick pageForm=
  case Form.getOutput pageForm of
    Just pageFormEntity ->
      onClick (SubmitUser pageFormEntity)

    Nothing ->
      onClick (FormMsg Form.Submit)

formFields : Model -> Html Form.Msg
formFields {form} =
  let
    roleOptions =
      ("", "--") :: (List.map (\i -> (i, String.toUpper i)) roles)

    superpowerOptions =
      List.map (\i -> (i, String.toUpper i)) superpowers

  in
    div
      [ class "form-horizontal" ]
      [ spanGroup "Id" 
        (Form.getFieldAsString "id" form)
        
      , textGroup "Name" 
        (Form.getFieldAsString "name" form)

      , textGroup "Email address" 
        (Form.getFieldAsString "email" form)

      , checkboxGroup "Administrator" 
        (Form.getFieldAsBool "admin" form)

      , textGroup "Website" 
        (Form.getFieldAsString "profile.website" form)

      , selectGroup roleOptions "Role" 
        (Form.getFieldAsString "profile.role" form)

      , radioGroup superpowerOptions "Superpower" 
        (Form.getFieldAsString "profile.superpower" form)

      , textGroup "Age" 
        (Form.getFieldAsString "profile.age" form)

      , textAreaGroup "Bio" 
        (Form.getFieldAsString "profile.bio" form)

      --, case userMaybe of
          --Just user ->
            --p [ class "alert alert-success" ] [ text (toString user) ]
          --Nothing ->
            --text ""
      ]
