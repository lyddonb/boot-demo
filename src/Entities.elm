module Entities exposing (..) 

import Dict exposing (Dict)

import Focus exposing (..)

import Identifier exposing (ID, idValidator)

type alias Thing =
  { id : ID
  , name : String
  , userId : ID
  }

initialThings : Dict ID Thing
initialThings = Dict.empty

type alias Entities =
  { users : Dict ID User
  , things : Dict ID Thing
  }

initialEntities : Entities
initialEntities =
  { users = initialUsers
  , things = initialThings
  }

type alias User =
  { id : ID
  , name : String
  , email : String
  , admin : Bool
  , profile : Profile
  }

type alias Profile =
  { website : Maybe String
  , role : String
  , superpower : Superpower
  , age : Int
  , bio : String
  }

type Superpower
  = Flying
  | Invisible

roles : List String
roles =
  [ "role1", "role2" ]

superpowers : List String
superpowers =
  [ "flying", "invisible" ]

initialUsers : Dict ID User
initialUsers = 
  Dict.insert 1 { id = 1
                , name = "Beau"
                , email = "lyddonb@gmail.com"
                , admin = True
                , profile = { website = Just "http://www.google.com"
                            , role = "role1"
                            , superpower = Flying
                            , age = 21
                            , bio = "The man!"
                            }
                } 
                Dict.empty

entities : Focus { r | entities:a } a
entities = create .entities (\f r -> { r | entities = f r.entities })

users : Focus { r | users:a } a
users = create .users (\f r -> { r | users = f r.users })

things : Focus { r | things:a } a
things = create .things (\f r -> { r | things = f r.things })
