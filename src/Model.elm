module Model exposing (Model, init)

import Contact exposing (Contact)


type alias Model =
    { contacts : List Contact
    , selectedContact : Maybe Contact
    }


init : Cmd msg -> ( Model, Cmd msg )
init command =
    ( { contacts = []
      , selectedContact = Nothing
      }
    , command
    )
