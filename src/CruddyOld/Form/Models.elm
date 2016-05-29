module Cruddy.Form.Models exposing (..)

type alias Model a e = 
  { title : Title
  , form : Form e a 
  , formEntity : Maybe a
  , fields : FieldsComponent a e 
  , initialFields : List ( String, Field.Field )
  , setFormFields : a -> List ( String, Field.Field )
  , validation : Validation e a
  , listFields : ListFields a
  }

init : List ( String, Field.Field ) -> ListFields a -> (a -> List ( String, Field.Field )) -> Validation e a -> FieldsComponent a e -> Model a e 
init title initialFields listFields setFormFields validation fields = 
  { title = title
  , pageForm = Form.initial initialFields validation 
  , pageFormEntity = Nothing
  , modalForm = Form.initial initialFields validation
  , modalFormEntity = Nothing
  , fields = fields
  , initialFields = initialFields
  , setFormFields = setFormFields
  , validation = validation
  , listFields = listFields
  }
