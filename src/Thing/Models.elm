module Thing.Models (..) where

import Dict exposing (Dict)

import String

import Html exposing (..)

import Form exposing (Form)
import Form.Error as Error exposing (Error(InvalidInt))
import Form.Field as Field
import Form.Infix exposing ((:=), (|:))
import Form.Validate as Validate exposing (..)

import Identifier exposing (ID, idValidator)

import Page.Models exposing (Model, FieldsComponent, init, ListFields)

import Thing.Components exposing (..)

type alias Thing =
  { id : ID
  , name : String
  , userId : ID
  }

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

initialFields : List ( String, Field.Field )
initialFields = []

initialThings : Dict ID Thing
initialThings = Dict.empty

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

type alias ThingModel =
  { page : Page.Models.Model Thing CustomError
  , things : Dict ID Thing
  }

init : ThingModel
init =
  { page = Page.Models.init "Thing Page" initialThings listFields initialFields setFormFields validate fieldsCompoment 
  , things = initialThings
  }
