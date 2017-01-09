module View.Toolbar exposing (view)

import Html exposing (Html, div, button, text)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)


view : { addMessage : msg } -> Html msg
view config =
    div [ class "row" ]
        [ button
            [ class "button button-outline"
            , onClick config.addMessage
            ]
            [ text "Add" ]
        ]
