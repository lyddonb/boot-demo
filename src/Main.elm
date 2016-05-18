module Main (..) where

import Debug
import Task exposing (Task)

import Effects exposing (Effects)

import Html exposing (..)
import Html.Attributes exposing (..)

import StartApp

import RouteHash exposing (HashUpdate)

import Actions exposing (..)
import Menu exposing (menu)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)

import User.Page exposing (delta2update, location2action)
import Thing.Page exposing (delta2update, location2action)



-- RUN THIS SUCKA!

{- This is needed for the router (route-hash) to get it's mailbox into StartApp
-}
messages : Signal.Mailbox Action
messages =
  Signal.mailbox NoOp

init : (AppModel, Effects Action)
init =
  let
      fxs =
        [ --Effects.map PlayersAction Players.Effects.fetchAll
        ]

      fx =
        Effects.batch fxs
  in
    (initialModel, fx)

app : StartApp.App AppModel
app =
  StartApp.start
   { init = init
   , inputs = [ messages.signal
              ]
   , update = update
   , view = view
   }

main : Signal.Signal Html.Html
main =
  app.html


-- ROUTER

delta2update : AppModel -> AppModel -> Maybe HashUpdate
delta2update previous current =
  case (Debug.log "Current Page: " current.pages.currentPage) of
    User ->
      -- First, we ask the submodule for a HashUpdate. Then, we use
      -- `map` to prepend something to the URL.
      RouteHash.map ((::) "page-1") <|
        User.Page.delta2update previous.pages.user current.pages.user

    ThingPage ->
      RouteHash.map ((::) "thing") <|
        Thing.Page.delta2update previous.pages.thing current.pages.thing

location2action : List String -> List Action
location2action list =
  case (Debug.log "Page Location: " list) of
    "user" :: rest ->
      -- We give the User module a chance to interpret the rest of
      -- the URL, and then we prepend an action for the part we
      -- interpreted.
      ( ShowPage User ) :: List.map UserAction ( 
        User.Page.location2action rest )
    
    "thing" :: rest ->
      ( ShowPage ThingPage ) :: List.map ThingAction ( 
        Thing.Page.location2action rest )

    _ ->
      ( ShowPage User ) :: List.map UserAction ( 
        User.Page.location2action [] )

port routeTasks : Signal (Task () ())
port routeTasks =
    RouteHash.start
        { prefix = RouteHash.defaultPrefix
        , models = app.model
        , delta2update = delta2update 
        , address = messages.address
        , location2action = location2action
        }



