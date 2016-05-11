module Page.Models (..) where

import Html exposing (..)

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (Validation)

--import Page.Actions exposing (..)

--type alias TableView a : Signal.Address (LayoutAction a) -> PageModel -> List Html.Html

--type alias FormFields a e = Signal.Address Form.Action -> Form e a -> Html

--type Page kkk

--type alias Model a e = 
  --{ form : Form e a
  --, entity : Maybe a
  --, table : TableView a
  --, fields : FormFields a e
  --}

type alias FieldsComponent a e = Signal.Address Form.Action -> Form e a -> Html

type alias Model a e =
  { title : String 
  , pageForm : Form e a
  , pageFormEntity : Maybe a
  , fields : FieldsComponent a e
  , initialFields : List ( String, Field.Field )
  , validation : Validation e a
  }

init : String -> List ( String, Field.Field ) -> Validation e a -> FieldsComponent a e -> Model a e
init title initialFields validation fields =
  { title = title 
  , pageForm = Form.initial initialFields validation
  , pageFormEntity = Nothing
  , fields = fields
  , initialFields = initialFields
  , validation = validation
  }
