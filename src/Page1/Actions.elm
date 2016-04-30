module Page1.Actions (..) where

import Form exposing (Form)

import Page1.Models exposing (User)

type Page1Action
  = NoOp
  | PageFormAction Form.Action
  | ModalFormAction Form.Action
  | SubmitPageUser User
  | SubmitModalUser User
  | EditUser User
