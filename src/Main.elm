module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
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


type Field
    = Firstname
    | Lastname
    | Phone


type Msg
    = NoOp
    | AddContact
    | Cancel
    | SelectContact Contact
    | Change Field String


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

        Change field value ->
            case field of
                Firstname ->
                    (updateSelectedContact
                        (\contact ->
                            { contact | firstname = value }
                        )
                        model
                    )
                        ! []

                Lastname ->
                    (updateSelectedContact
                        (\contact ->
                            { contact | lastname = value }
                        )
                        model
                    )
                        ! []

                Phone ->
                    (updateSelectedContact
                        (\contact ->
                            { contact | phone = value }
                        )
                        model
                    )
                        ! []


updateSelectedContact : (Contact -> Contact) -> Model -> Model
updateSelectedContact updateFunction model =
    let
        updatedContact =
            Maybe.map (updateFunction)
    in
        { model | selectedContact = updatedContact model.selectedContact }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row " ] [ h1 [] [ text "Contacts" ] ]
        , viewContactPanel model.selectedContact
        , viewToolbar
        , (viewContacts model.contacts)
        ]


viewToolbar : Html Msg
viewToolbar =
    div [ class "row" ]
        [ button
            [ class "button button-outline"
            , onClick AddContact
            ]
            [ text "Add" ]
        ]


viewContactPanel : Maybe Contact -> Html Msg
viewContactPanel contact =
    case contact of
        Nothing ->
            text ""

        Just c ->
            div [ class "contact-panel" ]
                [ viewInput c
                , button [ onClick Cancel ] [ text "Cancel" ]
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
