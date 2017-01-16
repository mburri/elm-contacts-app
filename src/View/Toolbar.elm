module View.Toolbar exposing (Config, config, view)

import Html exposing (Html, div, button, text)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)


type Config msg
    = Config { addMessage : msg }


config : { addMessage : msg } -> Config msg
config { addMessage } =
    Config { addMessage = addMessage }


view : Config msg -> Html msg
view (Config { addMessage }) =
    div [ class "row" ]
        [ button
            [ class "button button-outline"
            , onClick addMessage
            ]
            [ text "Add" ]
        ]
