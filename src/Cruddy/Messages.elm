module Cruddy.Messages exposing (..)

import Form exposing (Form)

type Msg a
  = PageFormMsg Form.Msg
  | ModalFormMsg Form.Msg
  | SubmitPageEntity a
  | SubmitModalEntity a
  | EditEntity a
  | DeleteEntity a
  | NoOp
