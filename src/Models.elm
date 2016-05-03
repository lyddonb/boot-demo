module Models (..) where

import Focus exposing (..)

import Page1.Models exposing (Page1Model, init)
import Page2.Page exposing (Page2Model, init)

type Page
  = Page1
  | Page2

type alias Pages = 
  { page1 : Page1.Models.Page1Model
  , page2 : Page2.Page.Page2Model
  , currentPage : Page
  }

type alias AppModel =
  { pages : Pages
  }

initialPages : Pages
initialPages =
  { page1 = Page1.Models.init
  , page2 = Page2.Page.init
  , currentPage = Page1
  }

initialModel : AppModel
initialModel =
  { pages = initialPages
  }

pages : Focus { r | pages:a } a
pages = create .pages (\f r -> { r | pages = f r.pages })

page1 : Focus { r | page1:a } a
page1 = create .page1 (\f r -> { r | page1 = f r.page1 })

page2 : Focus { r | page2:a } a
page2 = create .page2 (\f r -> { r | page2 = f r.page2 })

currentPage : Focus { r | currentPage:a } a
currentPage = create .currentPage (\f r -> { r | currentPage = f r.currentPage })
