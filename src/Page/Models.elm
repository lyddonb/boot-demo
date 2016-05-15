module Page.Models (..) where

import Dict exposing (Dict)

import Html exposing (..)

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (Validation)

import Identifier exposing (ID)

import Entities exposing (Entities, initialEntities)

type alias FieldsComponent a e = Signal.Address Form.Action -> Entities -> Form e a -> Html

type alias ListField a = a -> Html

type alias ListFields a = List ( String, ListField a )

type alias Title = 
  { single : String
  , plural : String
  }

setTitle : String -> String -> Title
setTitle x y =
  { single = x
  , plural = y
  }

initialFields : List ( String, Field.Field )
initialFields = []

type alias Model a e =
  { title : Title 
  , pageForm : Form e a
  , pageFormEntity : Maybe a
  , modalForm : Form e a
  , modalFormEntity : Maybe a
  , fields : FieldsComponent a e
  , initialFields : List ( String, Field.Field )
  , setFormFields : a -> List ( String, Field.Field )
  , validation : Validation e a
  , listFields : ListFields a
  , entities : Entities
  , entityAccessor : Entities -> Dict ID a
  }

init : Title -> ListFields a -> (a -> List ( String, Field.Field )) -> Validation e a -> FieldsComponent a e -> (Entities -> Dict ID a) -> Model a e
init title listFields setFormFields validation fields entityAccessor =
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
  , entities = initialEntities
  , entityAccessor = entityAccessor
  }
