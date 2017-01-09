module Model exposing (Model)

import Contact exposing (Contact)


type alias Model =
    { contacts : List Contact
    , selectedContact : Maybe Contact
    }
