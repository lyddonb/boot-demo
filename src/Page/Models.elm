module Page.Models (..) where

import Dict exposing (Dict)

import Html exposing (..)

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (Validation)

import Identifier exposing (ID)

type alias FieldsComponent a e = Signal.Address Form.Action -> Form e a -> Html

type alias ListField a = a -> Html

type alias ListFields a = List ( String, ListField a )

type alias Model a e =
  { title : String 
  , pageForm : Form e a
  , pageFormEntity : Maybe a
  , modalForm : Form e a
  , modalFormEntity : Maybe a
  , fields : FieldsComponent a e
  , initialFields : List ( String, Field.Field )
  , setFormFields : a -> List ( String, Field.Field )
  , validation : Validation e a
  , listFields : ListFields a
  , entities : Dict ID a
  }

init : String -> Dict ID a -> ListFields a -> List ( String, Field.Field ) -> (a -> List ( String, Field.Field )) -> Validation e a -> FieldsComponent a e -> Model a e
init title entities listFields initialFields setFormFields validation fields =
  { title = title 
  , pageForm = Form.initial initialFields validation
  , pageFormEntity = Nothing
  , modalForm = Form.initial initialFields validation
  , modalFormEntity = Nothing
  , fields = fields
  , initialFields = initialFields
  , setFormFields = setFormFields
  , validation = validation
  , listFields = listFields
  , entities = entities
  }
