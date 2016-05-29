module Cruddy.Models exposing (..)

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (..)

type alias Model a e = 
  { form : Form e a 
  , editForm : Form e a
  , entityMaybe : Maybe a
  , editEntityMaybe : Maybe a
  , initialFields : List ( String, Field.Field )
  , validation : Validation e a
  , setEditFormFields : a -> List ( String, Field.Field )
  }

init : List ( String, Field.Field ) -> Validation e a -> (a -> List ( String, Field.Field )) -> Model a e
init initialFields validate setEditFormFields =
  { form = Form.initial initialFields validate
  , editForm = Form.initial initialFields validate
  , entityMaybe = Nothing 
  , editEntityMaybe = Nothing
  , initialFields = initialFields
  , validation = validate
  , setEditFormFields = setEditFormFields
  }
