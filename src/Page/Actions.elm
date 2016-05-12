module Page.Actions (..) where

import Form exposing (Form)

type Action a
  = NoOp
  | PageFormAction Form.Action
  | SubmitPageEntity a
  | EditEntity a
  | DeleteEntity a
