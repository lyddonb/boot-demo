module Users.Models exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App

import Maybe exposing (withDefault)

import String

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (..)

import Bootstrap exposing (..)

--import Cruddy.Messages exposing (Msg(PageFormMsg))
--import Cruddy.Models as CruddyModels

import Entities exposing (..)

import FormInfix exposing ((:=), (|:))

import Identifier exposing (ID, idValidator)

import Users.Messages exposing (Msg)

type CustomError
  = Ooops
  | Nope
  | AlreadyTaken
  | InvalidSuperpower

type alias Model =
  { form : Form CustomError User
  , userMaybe : Maybe User
  , entities : Entities
  }

init : Model
init =
  { form = Form.initial initialFields validate
  , userMaybe = Nothing 
  , entities = initialEntities
  }


--type alias Model = CruddyModels.Model User CustomError 

--init : Model
--init = CruddyModels.init initTitle initialFields listFields setFormFields validate mapFieldsComponent .users

--initTitle : CruddyModels.Title
--initTitle = 
  --{ single = "User"
  --, plural = "Users"
  --}

initialFields : List ( String, Field.Field )
initialFields =
  [ ( "profile", Field.group
      [ ( "role", Field.Select "role1" )
      , ( "superpower", Field.Radio "flying" )
      ]
    )
  ]

superpowerToString : Superpower -> String
superpowerToString superpower =
  case superpower of
    Flying -> "flying"
    Invisible -> "invisible"

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

--listFields : CruddyModels.ListFields User
--listFields =
  --[ ("Id", \n -> .id n |> toString |> text )
  --, ("Name", \n -> .name n |> text )
  --, ("Email", \n -> .email n |> text )
  --, ("Admin", \n -> .admin n |> toString |> text )
  --]

--mapFieldsComponent : Entities -> Form e a -> Html (Cruddy.Messages.Msg a)
--mapFieldsComponent entities form =
  --App.map PageFormMsg (fieldsCompoment entities form)

-- VALIDATION

validate : Validation CustomError User
validate =
  form5
    User
    ("id" := idValidator)
    ("name" := string `andThen` nonEmpty)
    ("email" := email `andThen` (asyncCheck True))
    ("admin" := bool |> Validate.defaultValue False)
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
    |: ("bio" := string |> Validate.defaultValue "")

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

asyncCheck : Bool -> String -> Validation CustomError String
asyncCheck serverIsOk s =
  if serverIsOk then
    succeed s
  else
    fail (customError AlreadyTaken)

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
