module Models (..) where

import Dict exposing (Dict)

import Focus exposing (..)

import Identifier exposing (ID)

import Page1.Models exposing (Page1Model, init, User, initialUsers)
import Page2.Models exposing (Page2Model, init)
import Thing.Models exposing (ThingModel, init)

type Page
  = Page1
  | Page2
  | ThingPage

type alias Pages = 
  { page1 : Page1.Models.Page1Model
  , page2 : Page2.Models.Page2Model
  , thing : Thing.Models.ThingModel
  , currentPage : Page
  }

type alias Entities =
  { users : Dict ID Page1.Models.User }

type alias AppModel =
  { pages : Pages
  , entities : Entities
  }

initialPages : Pages
initialPages =
  { page1 = Page1.Models.init
  , page2 = Page2.Models.init
  , thing = Thing.Models.init
  , currentPage = Page1
  }

-- TODO: Add things to the entities

initialEntities : Entities
initialEntities =
  { users = initialUsers }

initialModel : AppModel
initialModel =
  { pages = initialPages
  , entities = initialEntities
  }

pages : Focus { r | pages:a } a
pages = create .pages (\f r -> { r | pages = f r.pages })

page1 : Focus { r | page1:a } a
page1 = create .page1 (\f r -> { r | page1 = f r.page1 })

page2 : Focus { r | page2:a } a
page2 = create .page2 (\f r -> { r | page2 = f r.page2 })

thing : Focus { r | thing:a } a
thing = create .thing (\f r -> { r | thing = f r.thing })

currentPage : Focus { r | currentPage:a } a
currentPage = create .currentPage (\f r -> { r | currentPage = f r.currentPage })

entities : Focus { r | entities:a } a
entities = create .entities (\f r -> { r | entities = f r.entities })

users : Focus { r | users:a } a
users = create .users (\f r -> { r | users = f r.users })
