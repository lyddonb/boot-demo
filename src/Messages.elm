module Messages exposing (..) 

import Users.Messages as UserMessages
--import Models exposing (Page)
--import User.Actions exposing (..)
--import Thing.Actions exposing (..)

type Page = Home | Users

toHash : Page -> String
toHash page =
  case page of
    Home ->
      "#home"

    Users ->
      "#users"

type Msg
  = UserMsg UserMessages.Msg
  | NoOp
  --= UserAction User.Actions.UserAction
  --| ThingAction Thing.Actions.ThingAction
  --| ShowPage Page
  --| NoOp
