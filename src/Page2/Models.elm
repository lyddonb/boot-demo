module Page2.Models (..) where

import Dict exposing (Dict)

import Html exposing (..)
import Html.Attributes exposing (..)

import String

import Form exposing (Form)
import Form.Error as Error exposing (Error(InvalidInt))
import Form.Field as Field
import Form.Infix exposing ((:=), (|:))
import Form.Validate as Validate exposing (..)

import Identifier exposing (ID, idValidator)

import Layout.Bootstrap exposing (..)
import Layout.Models exposing (..)

type alias Page2Model = LayoutModel Thing CustomError
  --{ pageForm : Form CustomError Thing
  --, modalForm : Form CustomError Thing
  --, pageThing : Maybe Thing
  --, modalThing : Maybe Thing
  --, things : Dict ID Thing
  --}

type CustomError
  = Ooops
  | Nope
  | AlreadyTaken

type alias Thing =
  { id : ID
  , name : String
  , userId : ID
  }

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

initialFields : List ( String, Field.Field )
initialFields = []

initialThings : Dict ID Thing
initialThings = Dict.empty

init : Page2Model
init =
  { pageForm = Form.initial initialFields validate
  , modalForm = Form.initial initialFields validate
  , pageEntity = Nothing 
  , modalEntity = Nothing
  , entities = initialThings
  , resetFunc = editReset
  , fieldsFunc = formFieldsFunc
  }

setFormFields : Thing -> List ( String, Field.Field )
setFormFields thing =
  [ ( "id", Field.Text ( toString thing.id ) )
  , ( "name", Field.Text thing.name )
  , ( "user", Field.Text ( toString thing.userId ) )
  ]

formFieldsFunc : FormFields Thing CustomError
formFieldsFunc address form =
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

editReset : EditReset Thing
editReset maybeThing = 
  case maybeThing of 
    Just thing ->
      setFormFields thing
    Nothing ->
      initialFields
