module View.ContactsList exposing (Config, view, config)

import Html exposing (Html, table, tbody, tr, td, text)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Model.Contact exposing (Contact)


type Config msg
    = Config { selectMsg : Contact -> msg }


config : { selectMsg : Contact -> msg } -> Config msg
config { selectMsg } =
    Config { selectMsg = selectMsg }


view : Config msg -> List Contact -> Html msg
view config contacts =
    table []
        [ tbody []
            (List.map (viewContact config) contacts)
        ]


viewContact : Config msg -> Contact -> Html msg
viewContact (Config { selectMsg }) contact =
    tr [ onClick <| selectMsg contact ]
        [ td []
            [ text contact.firstname ]
        , td []
            [ text contact.lastname ]
        , td []
            [ text contact.phone ]
        ]
