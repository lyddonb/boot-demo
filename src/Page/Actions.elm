module Page.Actions (..) where

import Form exposing (Form)

--import Identifier exposing (ID)

type Action a
  = NoOp
  | PageFormAction Form.Action
  | SubmitPageEntity a
