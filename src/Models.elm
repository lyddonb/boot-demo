module Models (..) where

import Dict exposing (Dict)

import Focus exposing (..)

import Identifier exposing (ID)

import Page1.Models exposing (Page1Model, init, User, initialUsers)
import Thing.Models exposing (ThingModel, init)

import Entities exposing (Entities, Thing, initialEntities)

type Page
  = Page1
  | ThingPage

type alias Pages = 
  { page1 : Page1.Models.Page1Model
  , thing : Thing.Models.ThingModel
  , currentPage : Page
  }

type alias AppModel =
  { pages : Pages
  , entities : Entities
  }

initialPages : Pages
initialPages =
  { page1 = Page1.Models.init
  , thing = Thing.Models.init
  , currentPage = Page1
  }

-- TODO: Add things to the entities

initialModel : AppModel
initialModel =
  { pages = initialPages
  , entities = initialEntities
  }

pages : Focus { r | pages:a } a
pages = create .pages (\f r -> { r | pages = f r.pages })

page1 : Focus { r | page1:a } a
page1 = create .page1 (\f r -> { r | page1 = f r.page1 })

thing : Focus { r | thing:a } a
thing = create .thing (\f r -> { r | thing = f r.thing })

currentPage : Focus { r | currentPage:a } a
currentPage = create .currentPage (\f r -> { r | currentPage = f r.currentPage })
