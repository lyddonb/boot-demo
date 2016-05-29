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
import Cruddy.Messages as CruddyMessages

import Entities exposing (..)

import Users.Models exposing (..)
import Users.Messages exposing (Msg(..))

view : Model -> Html Msg
view model =
  cruddyPage (initializeCruddy "User" "Users" formFields) model

cruddyPage : CruddyPage User CustomError -> Model -> Html Msg
cruddyPage cruddyPage model =
  App.map CruddyMsg (
    page [ ("Add a " ++ cruddyPage.newTitle, (newForm cruddyPage.formFields model.cruddy)) 
         , ("View " ++ cruddyPage.listTitle, (listView (editForm cruddyPage.formFields model.cruddy) (table model)) )
         ]
       )

table : Model -> Html (CruddyMessages.Msg User)
table model =
  listTable (headers) (Dict.values model.entities.users) row

row : User -> List (Html msg)
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

formFields : Form CustomError User -> Html Form.Msg
formFields form =
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
