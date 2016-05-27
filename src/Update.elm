module Update exposing (..) 

import Navigation
--import Focus exposing (..)

import Messages exposing (..)
import Models exposing (..)

--import Entities exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of

    NoOp ->
      ( model, Cmd.none )

    --ShowPage page ->
      --( set (pages => currentPage) page model, Effects.none )

    --UserAction subAction ->
      --let
        --pModel = model.pages.user

        ---- Pass the users from the AppModel down to the UserModel
        --( pageModel, fx ) =
          --User.Update.update subAction ({ pModel | entities = model.entities })

        ---- Update user and users on the AppModel
        --updatedModel = { model | entities = pageModel.entities }
                        --|> set (pages => user) pageModel
      --in
        --( updatedModel, Effects.map UserAction fx )
        
    --ThingAction subAction ->
      --let
        --tModel = model.pages.thing

        --( pageModel, fx ) =
          --Thing.Update.update subAction ({ tModel | entities = model.entities })

        --updatedModel = { model | entities = pageModel.entities }
                        --|> set (pages => thing) pageModel
      --in
        --( updatedModel, Effects.map ThingAction fx )

-- Navigation Update
urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
  case Debug.log "result" result of
    Err _ ->
      ( model, Navigation.modifyUrl (toHash model.page) )

    Ok page ->
      ( { model | page = page }, Cmd.none )
