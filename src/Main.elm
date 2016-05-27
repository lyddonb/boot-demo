module Main exposing (..)

import Debug

import Html.App as App

import Navigation

import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)

import Messages exposing (..)
import Models exposing (..)
import Update exposing (urlUpdate)
import Update exposing (..)
import View exposing (..)

init : Result String Page -> (Model, Cmd Msg)
init result =
  urlUpdate result (Model Home)

main = 
  Navigation.program (Navigation.makeParser hashParser)
    { init = init
    , update = update
    , view = view
    , urlUpdate = urlUpdate
    , subscriptions = \_ -> Sub.none
    }

hashParser : Navigation.Location -> Result String Page
hashParser location =
  UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)

pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format Home (s "home")
    , format Users (s "users")
    ]
