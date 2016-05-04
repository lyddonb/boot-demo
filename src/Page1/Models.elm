module Page1.Models (..) where

import Dict exposing (Dict)
import String
import Maybe exposing (withDefault)

import Effects exposing (Effects)

import Form exposing (Form)
import Form.Error as Error exposing (Error(InvalidInt))
import Form.Field as Field
import Form.Validate as Validate exposing (..)

type alias ID = Int

type alias Page1Model = 
  { pageForm : Form CustomError User
  , modalForm : Form CustomError User
  , pageUser : Maybe User
  , modalUser : Maybe User
  , users : Dict ID User
  }

type CustomError
  = Ooops
  | Nope
  | AlreadyTaken
  | InvalidSuperpower

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

superpowerToString : Superpower -> String
superpowerToString superpower =
  case superpower of
    Flying -> "flying"
    Invisible -> "invisible"

initialFields : List ( String, Field.Field )
initialFields =
  [ ( "profile", Field.group
      [ ( "role", Field.Select "role1" )
      , ( "superpower", Field.Radio "flying" )
      ]
    )
  ]

setFormFields : User -> List ( String, Field.Field )
setFormFields user =
  [ ( "id", Field.Text ( toString user.id ) )
  , ( "name", Field.Text user.name )
  , ( "email", Field.Text user.email )
  , ( "admin", Field.Check user.admin )
  , ( "profile", Field.group
      [ ( "website", Field.Text (withDefault "" user.profile.website) ) 
      , ( "role", Field.Select user.profile.role )
      , ( "superpower", Field.Radio (superpowerToString user.profile.superpower) )
      , ( "age", Field.Text ( toString user.profile.age ) )
      , ( "bio", Field.Text user.profile.bio )
      ]
    )
  ]

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

-- TODO: Kill the init model
init : Page1Model
init =
  { pageForm = Form.initial initialFields validate
  , modalForm = Form.initial initialFields validate
  , pageUser = Nothing 
  , modalUser = Nothing
  , users = initialUsers
  }

-- VALIDATION

{-| Infix operators. See elm-simple-form-infix for a packaged version.
-}
(:=) =
  Validate.get
infixl 7 :=

(|:) =
  Validate.apply

{-| Return 0 for no ID as this input is not editable and Nothing is equivalent 
to a new entry.
-}
idValidator : Validation e Int
idValidator v =
  case Field.asString v of
    Just s ->
      if s == "NEW" then (Ok 0) else String.toInt s
         |> Result.formatError (\_ -> InvalidInt)

    Nothing ->
      Ok 0

validate : Validation CustomError User
validate =
  form5
    User
    ("id" := idValidator)
    ("name" := string `andThen` nonEmpty)
    ("email" := email `andThen` (asyncCheck True))
    ("admin" := bool |> defaultValue False)
    ("profile" := validateProfile)

validateProfile : Validation CustomError Profile
validateProfile =
  succeed Profile
    |: ("website"
          := oneOf
              [ emptyString |> map (\_ -> Nothing)
              , url |> map Just
              ]
       )
    |: ("role" := (string `andThen` (includedIn roles)))
    |: ("superpower" := validateSuperpower)
    |: ("age" := naturalInt)
    |: ("bio" := string |> defaultValue "")

validateSuperpower : Validation CustomError Superpower
validateSuperpower =
  customValidation
    string
    (\s ->
      case s of
        "flying" ->
          Ok Flying

        "invisible" ->
          Ok Invisible

        _ ->
          Err (customError InvalidSuperpower)
    )

-- eq. to: int `andThen` (minInt 0)

naturalInt : Validation CustomError Int
naturalInt =
  customValidation
    int
    (\i ->
      if i > 0 then
        Ok i
      else
        Err (customError Nope)
    )

asyncCheck : Bool -> String -> Validation CustomError String
asyncCheck serverIsOk s =
  if serverIsOk then
    succeed s
  else
    fail (customError AlreadyTaken)
