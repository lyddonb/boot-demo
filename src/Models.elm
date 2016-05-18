module Models (..) where

import Dict exposing (Dict)

import Focus exposing (..)

import Identifier exposing (ID)

import User.Models exposing (UserModel, init)
import Thing.Models exposing (ThingModel, init)

import Entities exposing (Entities, Thing, initialEntities, User, initialUsers)

type Page
  = User
  | ThingPage

type alias Pages = 
  { user : User.Models.UserModel
  , thing : Thing.Models.ThingModel
  , currentPage : Page
  }

type alias AppModel =
  { pages : Pages
  , entities : Entities
  }

initialPages : Pages
initialPages =
  { user = User.Models.init
  , thing = Thing.Models.init
  , currentPage = User
  }

-- TODO: Add things to the entities

initialModel : AppModel
initialModel =
  { pages = initialPages
  , entities = initialEntities
  }

pages : Focus { r | pages:a } a
pages = create .pages (\f r -> { r | pages = f r.pages })

user : Focus { r | user:a } a
user = create .user (\f r -> { r | user = f r.user })

thing : Focus { r | thing:a } a
thing = create .thing (\f r -> { r | thing = f r.thing })

currentPage : Focus { r | currentPage:a } a
currentPage = create .currentPage (\f r -> { r | currentPage = f r.currentPage })
