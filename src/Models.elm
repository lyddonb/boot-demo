module Models exposing (..) 

--import Dict exposing (Dict)

--import Focus exposing (..)

--import Identifier exposing (ID)

import Messages exposing (Page(..))

type alias Model =
  { page : Page }

initialModel : Model
initialModel =
  { page = Home }
