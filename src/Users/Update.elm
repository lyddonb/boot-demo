module Users.Update exposing (..)

import Dict exposing (Dict)

import Maybe exposing (withDefault)

import Focus exposing (..)

import Form exposing (Form)

import List.Extra exposing (last)

import Cruddy.Messages as CruddyMessages
import Cruddy.Update as CruddyUpdate
import Cruddy.Models as CruddyModels

import Entities exposing (..)

import Users.Messages exposing (..)
import Users.Models exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    CruddyMsg cruddyMsg ->
      let
        (cruddyModel, _) = CruddyUpdate.update cruddyMsg model.cruddy
        (updatedModel, updatedCruddyMsg) = cruddyUpdate cruddyMsg { model | cruddy = cruddyModel }
      in
        updatedModel ! [ Cmd.map CruddyMsg updatedCruddyMsg ]

cruddyUpdate : CruddyMessages.Msg User -> Model -> ( Model, Cmd a )
cruddyUpdate msg model =
  case msg of

    CruddyMessages.SubmitEntity user ->
       let
        -- HACK: Until we persist we need to get a new ID
        newId = (Dict.keys model.entities.users
                  |> last
                  |> withDefault 0) + 1

        updatedUsers = Dict.insert (newId) {user | id = newId} model.entities.users

        updatedModel = model
                        |> set (entities => users) updatedUsers
      in
        ( updatedModel, Cmd.none)

    CruddyMessages.SubmitEditEntity item ->
      let
        _ = Debug.log "User" item
        updatedUsers = Dict.insert (item.id) item model.entities.users

        updatedModel = model
                        |> set (entities => users) updatedUsers
      in
        ( updatedModel, Cmd.none)

    CruddyMessages.EditEntity user ->
      ( model, Cmd.none )

    CruddyMessages.DeleteEntity user ->
      ( model, Cmd.none )

    _ ->
      ( model, Cmd.none )
