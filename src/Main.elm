module Main exposing (..)

import Html exposing (Html, button, div, text, h1, table, tbody, td, tr)
import Html.Events exposing (onClick)
import Debug


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Contact =
    { id : Int
    , firstname : String
    , lastname : String
    , phone : String
    }


type alias Model =
    { contacts : List Contact
    , selectedContact : Maybe Contact
    }


type Msg
    = NoOp
    | AddContact
    | Cancel
    | SelectContact Contact


init : ( Model, Cmd Msg )
init =
    ( { contacts = initContacts, selectedContact = Nothing }
    , Cmd.none
    )



-- UPDATE


update msg model =
    case msg of
        NoOp ->
            model ! []

        AddContact ->
            model ! []

        Cancel ->
            { model | selectedContact = Nothing } ! []

        SelectContact contact ->
            ( { model | selectedContact = Just contact }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Contacts" ]
        , viewSelectedContact model.selectedContact
        , button [ onClick AddContact ] [ text "Add" ]
        , button [ onClick Cancel ] [ text "Cancel" ]
        , (viewContacts model.contacts)
        ]


viewSelectedContact : Maybe Contact -> Html Msg
viewSelectedContact contact =
    case contact of
        Nothing ->
            text ""

        Just c ->
            div []
                [ text "selected contact"
                , toString contact |> text
                ]


viewContacts : List Contact -> Html Msg
viewContacts contacts =
    table []
        [ tbody []
            (List.map viewContact contacts)
        ]


viewContact : Contact -> Html Msg
viewContact contact =
    tr [ onClick <| SelectContact contact ]
        [ td []
            [ text contact.firstname ]
        , td []
            [ text contact.lastname ]
        , td []
            [ text contact.phone ]
        ]



-- Helpers


initContacts : List Contact
initContacts =
    [ { id = 1, firstname = "Yvonne", lastname = "Gerardo", phone = "632-606-7173" }
    , { id = 2, firstname = "Lois", lastname = "Liana", phone = "543-555-7743" }
    , { id = 3, firstname = "Vladimir", lastname = "Ward", phone = "123-344-7145" }
    , { id = 4, firstname = "Trace", lastname = "Route", phone = "631-406-5473" }
    ]
