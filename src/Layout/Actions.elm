module Layout.Actions (..) where

import Form exposing (Form)

import Identifier exposing (ID)

type LayoutAction a
  = NoOp
  | PageFormAction Form.Action
  | ModalFormAction Form.Action
  | SubmitPageEntity a
  | SubmitModalEntity a
  | EditEntity ID
