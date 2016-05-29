module Cruddy.Messages exposing (Msg(..))

import Form exposing (Form)

type Msg a
  = NoOp
  | FormMsg Form.Msg
  | EditFormMsg Form.Msg
  | SubmitEntity a
  | SubmitEditEntity a
  | EditEntity a
  | DeleteEntity a
