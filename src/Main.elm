module Main exposing (..)

import Html exposing (Html, button, div, text, h1, ul, li)
import Html.Events exposing (onClick)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Contact =
    { firstname : String
    , lastname : String
    , phone : String
    }


type alias Model =
    { contacts : List Contact
    }


type Msg
    = NoOp
    | AddContact


init : ( Model, Cmd Msg )
init =
    ( { contacts = initContacts }
    , Cmd.none
    )



-- UPDATE


update msg model =
    case msg of
        NoOp ->
            model ! []

        AddContact ->
            model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Contacts" ]
        , button [ onClick AddContact ] [ text "Add" ]
        , (viewContacts model.contacts)
        ]


viewContacts : List Contact -> Html Msg
viewContacts contacts =
    ul []
        (List.map viewContact contacts)


viewContact : Contact -> Html Msg
viewContact contact =
    --li [] [ text (contact.firstname ++ ", " ++ contact.lastname ++ ", " ++ contact.phone) ]
    li [] [ toString contact |> text ]



-- Helpers


initContacts : List Contact
initContacts =
    [ { firstname = "Yvonne", lastname = "Gerardo", phone = "632-606-7173" }
    , { firstname = "Lois", lastname = "Liana", phone = "543-555-7743" }
    , { firstname = "Vladimir", lastname = "Ward", phone = "123-344-7145" }
    , { firstname = "Trace", lastname = "Route", phone = "631-406-5473" }
    ]
