module View.ContactPanel exposing (view)

import Html exposing (..)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Messages exposing (..)
import Contact exposing (Contact)


view : Maybe Contact -> Html Msg
view contact =
    case contact of
        Nothing ->
            text ""

        Just c ->
            div [ class "contact-panel" ]
                [ viewInput c
                , button [ onClick SaveContact ] [ text "Save" ]
                , button [ onClick Cancel ] [ text "Cancel" ]
                , button [ onClick DeleteContact ] [ text "Delete" ]
                ]


viewInput : Contact -> Html Msg
viewInput contact =
    fieldset []
        [ label [] [ text "First name" ]
        , input
            [ type_ "text"
            , onInput (Change Firstname)
            , value contact.firstname
            ]
            []
        , label [] [ text "Last name" ]
        , input
            [ type_ "text"
            , value contact.lastname
            , onInput (Change Lastname)
            ]
            []
        , label [] [ text "Phone" ]
        , input
            [ type_ "text"
            , onInput (Change Phone)
            , value contact.phone
            ]
            []
        ]
