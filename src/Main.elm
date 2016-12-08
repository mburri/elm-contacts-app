module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
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
    { id : Maybe Int
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
    | SaveContact
    | Cancel
    | Select Contact
    | Change Field String
    | LoadContacts (Result Http.Error (List Contact))


init : ( Model, Cmd Msg )
init =
    ( { contacts = [], selectedContact = Nothing }
    , loadContacts
    )


newContact : Contact
newContact =
    Contact Nothing "" "" ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddContact ->
            { model | selectedContact = Just newContact } ! []

        SaveContact ->
            case model.selectedContact of
                Nothing ->
                    model ! []

                Just contact ->
                    case contact.id of
                        Nothing ->
                            postContact contact model

                        Just id ->
                            putContact id contact model

        Cancel ->
            { model | selectedContact = Nothing } ! []

        Select contact ->
            ( { model | selectedContact = Just contact }, Cmd.none )

        Change field value ->
            case field of
                Firstname ->
                    (updateSelectedContact
                        (\c ->
                            { c | firstname = value }
                        )
                        model
                    )
                        ! []

                Lastname ->
                    (updateSelectedContact
                        (\c ->
                            { c | lastname = value }
                        )
                        model
                    )
                        ! []

                Phone ->
                    (updateSelectedContact
                        (\c ->
                            { c | phone = value }
                        )
                        model
                    )
                        ! []

        LoadContacts (Ok contacts) ->
            { model | contacts = contacts } ! []

        LoadContacts (Err _) ->
            ( model, Cmd.none )


saveContact : List Contact -> Contact -> List Contact
saveContact contacts newContact =
    case newContact.id of
        Nothing ->
            addContact contacts newContact

        Just id ->
            let
                replace contact =
                    if contact.id == newContact.id then
                        newContact
                    else
                        contact
            in
                List.map (replace) contacts


addContact : List Contact -> Contact -> List Contact
addContact contacts newContact =
    let
        nextId =
            Just 6
    in
        { newContact | id = nextId } :: contacts


updateSelectedContact : (Contact -> Contact) -> Model -> Model
updateSelectedContact updateFunction model =
    let
        updatedContact =
            Maybe.map (updateFunction)
    in
        { model | selectedContact = updatedContact model.selectedContact }


loadContacts : Cmd Msg
loadContacts =
    Http.send LoadContacts getContacts


getContacts : Http.Request (List Contact)
getContacts =
    Http.get "http://localhost:3030/contacts" decodeContacts


contactToJson : Contact -> String
contactToJson contact =
    let
        contactObject =
            Encode.object
                [ ( "first_name", Encode.string contact.firstname )
                , ( "last_name", Encode.string contact.lastname )
                , ( "phone", Encode.string contact.phone )
                ]
    in
        Encode.encode 0 contactObject


putContact : Int -> Contact -> Model -> ( Model, Cmd Msg )
putContact id contact model =
    model ! []


postContact : Contact -> Model -> ( Model, Cmd Msg )
postContact contact model =
    model ! []


decodeContacts : Decode.Decoder (List Contact)
decodeContacts =
    Decode.list decodeContact


decodeContact : Decode.Decoder Contact
decodeContact =
    Decode.map4 Contact
        (Decode.nullable (Decode.field "id" Decode.int))
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)
        (Decode.field "phone" Decode.string)



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
                , button [ onClick SaveContact ] [ text "Save" ]
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
    tr [ onClick <| Select contact ]
        [ td []
            [ text contact.firstname ]
        , td []
            [ text contact.lastname ]
        , td []
            [ text contact.phone ]
        ]
