module Users.Messages exposing (..)

import Form exposing (Form)

import Entities exposing (User)

type Msg
  = NoOp
  | FormMsg Form.Msg
  | SubmitUser User
