module Identifier (..) where

import String

import Form.Error as Error exposing (Error(InvalidInt))
import Form.Field as Field
import Form.Validate as Validate exposing (..)

type alias ID = Int

-- TODO: Figure out how to swtich InvalidInt to an InvalidID error type

{-| Return 0 for no ID as this input is not editable and Nothing is equivalent 
to a new entry.
-}
idValidator : Validation e Int
idValidator v =
  case Field.asString v of
    Just s ->
      if s == "NEW" then (Ok 0) else String.toInt s
         |> Result.formatError (\_ -> InvalidInt)

    Nothing ->
      Ok 0
