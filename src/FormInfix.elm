module FormInfix exposing ((:=), (?=), (|:)) 

{-| Form validation infix operators.

@docs (:=), (?=), (|:)
-}

import Form.Validate exposing (Validation, get, maybe, apply)


{-| Infix version of `apply`:

Form.succeed SomeRecord
|: ("foo" := string)
|: ("bar" := string)

-}
(|:) : Validation e (a -> b) -> Validation e a -> Validation e b
(|:) =
  apply


{-| Infix version of `get`.

    "name" := string
-}
(:=) : String -> Validation e a -> Validation e a
(:=) =
  get


{-| Access given field, wrapped in a `maybe` (Nothing if error).

    "hobby" ?= string
-}
(?=) : String -> Validation e a -> Validation e (Maybe a)
(?=) s v =
  maybe (get s v)
