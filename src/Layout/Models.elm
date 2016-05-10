module Layout.Models (..) where

import Dict exposing (Dict)

import Html exposing (..)

import Form exposing (Form)
import Form.Field as Field

import Identifier exposing (ID)

type alias EditReset a = Maybe a -> List ( String, Field.Field )

type alias FormFields a e = Signal.Address Form.Action -> Form e a -> Html

type alias LayoutModel a e = 
  { pageForm : Form e a
  , modalForm : Form e a
  , pageEntity : Maybe a
  , modalEntity : Maybe a
  , entities : Dict ID a
  -- TODO: This should just be an "action" that is reacted to vs passing a function through as "state"
  , resetFunc : EditReset a
  , fieldsFunc : FormFields a e
  }
