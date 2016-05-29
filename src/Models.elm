module Models exposing (..) 

import Focus exposing (..)
--import Dict exposing (Dict)

--import Identifier exposing (ID)
import Entities exposing (..)

import Messages exposing (Page(..))

import Users.Models as UserModels

type alias Model =
  { page : Page
  , user : UserModels.Model
  , entities : Entities
  }

initialModel : Model
initialModel =
  { page = Home
  , user = UserModels.init
  , entities = initialEntities
  }

page : Focus { r | page:a } a
page = create .page (\f r -> { r | page = f r.page })

user : Focus { r | user:a } a
user = create .user (\f r -> { r | user = f r.user })
