module Cruddy.Form.Messages exposing (..)

import Form exposing (Form)

type Msg a
  = FormMsg Form.Msg
  | SubmitEntity a
  | NoOp
