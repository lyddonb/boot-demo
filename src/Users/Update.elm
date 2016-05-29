module Users.Update exposing (..)

import Dict exposing (Dict)

import Maybe exposing (withDefault)

import Focus exposing (..)

import Form exposing (Form)

import List.Extra exposing (last)

import Cruddy.Messages as CruddyMessages
--import Cruddy.Update as CruddyUpdate
--import Cruddy.Models as CruddyUpdate

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
        (model, cmd) = cruddyUpdate cruddyMsg model
      in
        model ! [ cmd ]

--cruddyUpdate : CruddyMessages.Msg {b | id: a} -> Model -> ( Model, Cmd msg )
cruddyUpdate msg model =
  case msg of
    CruddyMessages.NoOp ->
      ( model, Cmd.none )

    CruddyMessages.FormMsg formMsg ->
      ({ model | form = Form.update formMsg model.form}, Cmd.none)

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

    CruddyMessages.EditEntity user ->
      ( model, Cmd.none )

    CruddyMessages.DeleteEntity user ->
      ( model, Cmd.none )
     --let
        --( pageModel, _ ) = CruddyUpdate.update msg model
        --( updatedModel, fx ) = updateForm msg pageModel
      --in
        --( updatedModel, fx )


--updateForm : CruddyMessages.Msg User -> Model -> ( Model, Cmd Msg )
--updateForm msg model =
  --case msg of

    --CruddyMessages.SubmitPageEntity item ->
      --let
        ---- HACK: Until we persist we need to get a new ID
        --newId = (Dict.keys model.entities.users
                  --|> last
                  --|> withDefault 0) + 1

        --updatedUsers = Dict.insert (newId) {item | id = newId} model.entities.users

        --updatedModel = model
                        --|> set (entities => users) updatedUsers
      --in
        --( updatedModel, Cmd.none)

    --CruddyMessages.SubmitModalEntity item ->
      --let
        --_ = Debug.log "User" item
        --updatedUsers = Dict.insert (item.id) item model.entities.users

        --updatedModel = model
                        --|> set (entities => users) updatedUsers
      --in
        --( updatedModel, Cmd.none)

    --_ ->
      --( model, Cmd.none )
