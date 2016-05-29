module Update exposing (..) 

import Navigation
--import Focus exposing (..)

import Messages exposing (..)
import Models exposing (..)

--import Entities exposing (..)
import Users.Update as UsersUpdate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of

    UserMsg userMsg ->
      let
        pModel = model.user

        -- Pass the users from the AppModel down to the UserModel
        ( pageModel, fx ) =
          UsersUpdate.update userMsg ({ pModel | entities = model.entities })

        -- Update user and users on the AppModel
        updatedModel = { model | entities = pageModel.entities
                               , user = pageModel}
      in
        ( updatedModel, Cmd.map UserMsg fx )

    NoOp ->
      ( model, Cmd.none )

-- Navigation Update
urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
  case Debug.log "result" result of
    Err _ ->
      ( model, Navigation.modifyUrl (toHash model.page) )

    Ok page ->
      ( { model | page = page }, Cmd.none )
