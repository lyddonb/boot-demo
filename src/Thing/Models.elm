module Thing.Models (..) where

import Dict exposing (Dict)

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Error as Error exposing (Error(InvalidInt))
import Form.Field as Field
import Form.Infix exposing ((:=), (|:))
import Form.Validate as Validate exposing (..)

import Identifier exposing (ID, idValidator)

import Entities exposing (Entities)

import Page.Bootstrap exposing (..)
import Page.Models exposing (Model, FieldsComponent, init, ListFields, setTitle)

import Page1.Models exposing (User, initialUsers)

import Entities exposing (Thing, initialThings)

type CustomError
  = Ooops
  | Nope
  | AlreadyTaken

validateUserId : Validation CustomError ID
validateUserId v =
  case Field.asString v of
    Just s ->
      String.toInt s 
        |> isValidUser
        |> Result.formatError (\_ -> InvalidInt)

    Nothing ->
      Ok 0

isValidUser : Result String Int -> Result String ID
isValidUser res =
  case res of
    Ok v ->
      -- TODO: Check dict of users to see if it exists
      Ok v

    Err err ->
      Err err

validate : Validation CustomError Thing
validate =
  form3
    Thing
    ("id" := idValidator)
    ("name" := string `andThen` nonEmpty)
    ("userId" := validateUserId)

listFields : ListFields Thing
listFields =
  [ ("Id", \n -> .id n |> toString |> text )
  , ("Name", \n -> .name n |> text )
  , ("User", \n -> .userId n |> toString |> text )
  ]

setFormFields : Thing -> List ( String, Field.Field )
setFormFields thing =
  [ ( "id", Field.Text ( toString thing.id ) )
  , ( "name", Field.Text thing.name )
  , ( "userId", Field.Text ( toString thing.userId ) )
  ]

type alias ThingModel = Page.Models.Model Thing CustomError

fieldsCompoment : Signal.Address Form.Action -> Entities -> Form e a -> Html
fieldsCompoment address entities form =
  let
    userOptions =
      ("0", "--") :: (Dict.foldl (\id val acc -> (toString id, val.name) :: acc) [] entities.users)
  in
    div
      [ class "form-horizontal" ]
      [ spanGroup "Id" address
        (Form.getFieldAsString "id" form)
        
      , textGroup "Name" address
        (Form.getFieldAsString "name" form)

      , selectGroup userOptions "User" address
        (Form.getFieldAsString "userId" form)

      ]

init : ThingModel
init =
  Page.Models.init (setTitle "Thing" "Things") listFields setFormFields validate fieldsCompoment .things
