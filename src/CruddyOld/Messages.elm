module Cruddy.Messages exposing (..)

import Form exposing (Form)

import Cruddy.Form.Messages as CruddyFormMessages

type Msg a
  = NewFormMsg CruddyFormMessages.Msg
  | EditFormMsg CruddyFormMessages.Msg
  | EditEntity a
  | DeleteEntity a
  | NoOp
