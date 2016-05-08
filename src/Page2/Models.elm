module Page2.Models (..) where

import Dict exposing (Dict)

import String

import Form exposing (Form)
import Form.Error as Error exposing (Error(InvalidInt))
import Form.Field as Field
import Form.Infix exposing ((:=), (|:))
import Form.Validate as Validate exposing (..)

import Identifier exposing (ID, idValidator)

type alias Page2Model = 
  { pageForm : Form CustomError Thing
  , modalForm : Form CustomError Thing
  , pageThing : Maybe Thing
  , modalThing : Maybe Thing
  , things : Dict ID Thing
  }

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
  , pageThing = Nothing 
  , modalThing = Nothing
  , things = initialThings
  }

