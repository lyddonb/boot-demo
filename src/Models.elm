module Models (..) where

import Page1.Models exposing (Page1Model, init)
import Page2.Page exposing (Page2Model, init)

type Page
  = Page1
  | Page2

type alias AppModel =
  { page1 : Page1.Models.Page1Model
  , page2 : Page2.Page.Page2Model
  , currentPage : Page
  }

initialModel : AppModel
initialModel =
  { page1 = Page1.Models.init
  , page2 = Page2.Page.init
  , currentPage = Page1
  }
