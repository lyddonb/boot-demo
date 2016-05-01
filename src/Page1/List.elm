module Page1.List (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Page1.Actions exposing (..)
import Page1.Form exposing (..)
import Page1.Models exposing (..)


modal : Signal.Address Page1Action -> Page1Model -> Html
modal address model =
  div
    [ class "modal fade"
    , id "userEditModal"
    , attribute "tabindex" "-1"
    , attribute "role" "dialog"
    , attribute "aria-labelledby" "userEditModalLabel"
    , attribute "tabindex" "-1"
    ]
    [ div
      [ class "modal-dialog" 
      , attribute "role" "document" 
      ]
      [ div
        [ class "modal-content" ]
        (modalForm address model)
      ]
    ]

listView : Signal.Address Page1Action -> Page1Model -> Html
listView address model =
  div 
    [ ] 
    [ list address model
    ]
 
list : Signal.Address Page1Action -> Page1Model -> Html.Html
list address model =
  div
    []
    [ modal address model
    , table
      [ class "table table-striped table-hover table-condensed" ]
      [ thead
        []
        [ tr
          []
          [ th [] [ text "Id" ]
          , th [] [ text "Name" ]
          , th [] [ text "Email" ]
          , th [] [ text "Admin" ]
          , th [] [ text "Actions" ]
          ]
        ]
        , tbody [] (List.map (userRow address model) model.users)
      ]
    ]

userRow : Signal.Address Page1Action -> Page1Model -> User -> Html.Html
userRow address model user =
  tr
    []
    [ td [] [ text (toString user.id) ]
    , td [] [ text user.name ]
    , td [] [ text user.email ]
    , td [] [ text (toString user.admin) ]
    , td 
        [] 
        [ editBtn address user
        , deleteBtn address user
        ]
    ]

editBtn : Signal.Address Page1Action -> User -> Html.Html
editBtn address user =
  button
    [ class "btn btn-primary btn-xs" 
    , type' "button"
    , attribute "data-toggle" "modal"
    , attribute "data-target" "#userEditModal"
    , onClick address (EditUser user.id)
    ]
    [ i [class "fa fa-pencil mr1" ] [], text "Edit" ]

deleteBtn : Signal.Address Page1Action -> User -> Html.Html
deleteBtn address user =
  button
    [ class "btn btn-danger btn-xs" 
    --, onClick address (DeletePlayerIntent user) 
    ]
    [ i [class "fa fa-trash mr1" ] [], text "Delete" ]

