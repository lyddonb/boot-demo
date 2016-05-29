module Cruddy.Messages exposing (Msg(..))

import Form exposing (Form)

type Msg a
  = NoOp
  | FormMsg Form.Msg
  | SubmitEntity a
  | EditEntity a
  | DeleteEntity a
