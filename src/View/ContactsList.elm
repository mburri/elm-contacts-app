module View.ContactsList exposing (view)

import Html exposing (Html, table, tbody, tr, td, text)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Messages exposing (..)
import Contact exposing (Contact)


view : List Contact -> Html Msg
view contacts =
    table []
        [ tbody []
            (List.map viewContact contacts)
        ]


viewContact : Contact -> Html Msg
viewContact contact =
    tr [ onClick <| Select contact ]
        [ td []
            [ text contact.firstname ]
        , td []
            [ text contact.lastname ]
        , td []
            [ text contact.phone ]
        ]
