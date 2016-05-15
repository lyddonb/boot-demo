module Entities (..) where

import Dict exposing (Dict)

import Focus exposing (..)

import Identifier exposing (ID, idValidator)

import Page1.Models exposing (User, initialUsers)

type alias Thing =
  { id : ID
  , name : String
  , userId : ID
  }

initialThings : Dict ID Thing
initialThings = Dict.empty

type alias Entities =
  { users : Dict ID Page1.Models.User
  , things : Dict ID Thing
  }

initialEntities : Entities
initialEntities =
  { users = initialUsers
  , things = initialThings
  }

entities : Focus { r | entities:a } a
entities = create .entities (\f r -> { r | entities = f r.entities })

users : Focus { r | users:a } a
users = create .users (\f r -> { r | users = f r.users })

things : Focus { r | things:a } a
things = create .things (\f r -> { r | things = f r.things })
