module Cruddy.Form.View exposing (..)

view : Model a e -> Html (Msg a) 
view model =
  div
    []
    [ model.fields model.entities model.pageForm 
    , formHandler model
    ]

modalForm : Model a e -> List (Html (Msg a))
modalForm model =
  [ div
    [ class "modal-header" ]
    [ button
      [ class "close"
      , attribute "data-dismiss" "modal"
      , attribute "aria-label" "Close"
      ]
      [ span
        [ attribute "aria-hidden" "true" ]
        [ text "×" ]
      ]
    , h4
      [ class "modal-title"
      , id "userEditModalLabel"
      ]
      [ text "Edit ..TODO..." ]
    ]
  , div
    [ class "modal-body" ]
    [ p
      []
      [ model.fields model.entities model.modalForm 
      ]
    ]
  , div
    [ class "modal-footer" ]
    [ modalFormHandler model 
    ]
  ]

modalFormHandler : Model a e -> Html (Msg a)
modalFormHandler model =
  let
    resetFunc = 
    case model.modalFormEntity of
      Just entity ->
        model.setFormFields entity
    
      Nothing ->
        model.initialFields

    submitClick =
    case Form.getOutput model.modalForm of
      Just modalFormEntity ->
        onClick (SubmitModalEntity (Debug.log "Form ent" modalFormEntity))

      Nothing ->
        onClick (ModalFormMsg Form.Submit)
  in
    div
      []
      [
        formActions
        [ button
          [ submitClick
          , class "btn btn-primary"
          , attribute "data-dismiss" "modal"
          ]
          [ text "Submit" ]
        --, text " "
        , button
          [ onClick (ModalFormMsg (Form.Reset resetFunc))
          , class "btn btn-default"
          ]
          [ text "Reset" ]
        , button
          [ class "btn btn-default"
          , type' "button"
          , attribute "data-dismiss" "modal"
          ]
          [ text "Close" ]
        ]
      ]

formHandler :  Model a e -> Html (Msg a)
formHandler {pageForm, pageFormEntity, initialFields} =
  let
    submitClick =
    case Form.getOutput pageForm of
      Just pageFormEntity ->
        onClick (SubmitPageEntity pageFormEntity)

      Nothing ->
        onClick (PageFormMsg Form.Submit)
  in
    formActions
    [ button
      [ class "btn btn-primary"
      , submitClick
      ]
      [ text "Submit" ]
    , text " "
    , button
      [ onClick (PageFormMsg (Form.Reset initialFields))
      , class "btn btn-default"
      ]
      [ text "Reset" ]
    ]
