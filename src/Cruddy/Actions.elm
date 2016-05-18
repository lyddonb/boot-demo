module Cruddy.Actions (..) where

import Form exposing (Form)

type Action a
  = NoOp
  | PageFormAction Form.Action
  | ModalFormAction Form.Action
  | SubmitPageEntity a
  | SubmitModalEntity a
  | EditEntity a
  | DeleteEntity a
