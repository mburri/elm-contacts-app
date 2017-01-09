module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Contact exposing (Contact)
import Model exposing (Model)
import Messages exposing (..)
import View.Toolbar as Toolbar


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row " ] [ h1 [] [ text "Contacts" ] ]
        , viewContactPanel model.selectedContact
        , Toolbar.view { addMessage = AddContact }
        , (viewContacts model.contacts)
        ]


viewContactPanel : Maybe Contact -> Html Msg
viewContactPanel contact =
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


viewContacts : List Contact -> Html Msg
viewContacts contacts =
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
