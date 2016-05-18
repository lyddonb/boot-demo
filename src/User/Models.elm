module User.Models (..) where

import Dict exposing (Dict)
import String
import Maybe exposing (withDefault)

import Effects exposing (Effects)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Form exposing (Form)
import Form.Field as Field
import Form.Infix exposing ((:=), (|:))
import Form.Validate as Validate exposing (..)

import Bootstrap exposing (..)

import Cruddy.Models exposing (Model, FieldsComponent, init, ListFields, setTitle)

import Entities exposing (..)

import Identifier exposing (ID, idValidator)

type alias UserModel = Cruddy.Models.Model User CustomError

type CustomError
  = Ooops
  | Nope
  | AlreadyTaken
  | InvalidSuperpower

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

-- VALIDATION

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

listFields : ListFields User
listFields =
  [ ("Id", \n -> .id n |> toString |> text )
  , ("Name", \n -> .name n |> text )
  , ("Email", \n -> .email n |> text )
  , ("Admin", \n -> .admin n |> toString |> text )
  ]

fieldsCompoment : Signal.Address Form.Action -> Entities -> Form e a -> Html
fieldsCompoment address entities form =
  let
    roleOptions =
      ("", "--") :: (List.map (\i -> (i, String.toUpper i)) roles)

    superpowerOptions =
      List.map (\i -> (i, String.toUpper i)) superpowers

  in
    div
      [ class "form-horizontal" ]
      [ spanGroup "Id" address
        (Form.getFieldAsString "id" form)
        
      , textGroup "Name" address
        (Form.getFieldAsString "name" form)

      , textGroup "Email address" address
        (Form.getFieldAsString "email" form)

      , checkboxGroup "Administrator" address
        (Form.getFieldAsBool "admin" form)

      , textGroup "Website" address
        (Form.getFieldAsString "profile.website" form)

      , selectGroup roleOptions "Role" address
        (Form.getFieldAsString "profile.role" form)

      , radioGroup superpowerOptions "Superpower" address
        (Form.getFieldAsString "profile.superpower" form)

      , textGroup "Age" address
        (Form.getFieldAsString "profile.age" form)

      , textAreaGroup "Bio" address
        (Form.getFieldAsString "profile.bio" form)

      --, case userMaybe of
          --Just user ->
            --p [ class "alert alert-success" ] [ text (toString user) ]
          --Nothing ->
            --text ""
      ]

init : UserModel
init =
  Cruddy.Models.init (setTitle "User" "Users") listFields setFormFields validate fieldsCompoment .users
