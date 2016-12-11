module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Http
import HttpBuilder
import Json.Decode as Decode
import Json.Encode as Encode
import Debug
import Contact exposing (Contact)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


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
    | GetContactsSuccedd (List Contact)
    | GetContactsFailed
    | PostContactSucceed
    | PostContactFailed
    | PutContactSucceed
    | PutContactFailed


init : ( Model, Cmd Msg )
init =
    ( { contacts = [], selectedContact = Nothing }
    , loadContacts
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddContact ->
            { model | selectedContact = Just Contact.empty } ! []

        SaveContact ->
            case model.selectedContact of
                Nothing ->
                    model ! []

                Just contact ->
                    case contact.id of
                        Nothing ->
                            ( model, postContact contact )

                        Just id ->
                            ( model, putContact id contact )

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

        GetContactsSuccedd contacts ->
            ( { model | contacts = contacts }, Cmd.none )

        GetContactsFailed ->
            model ! []

        PostContactSucceed ->
            ( { model | selectedContact = Nothing }, loadContacts )

        PostContactFailed ->
            model ! []

        PutContactSucceed ->
            ( { model | selectedContact = Nothing }, loadContacts )

        PutContactFailed ->
            model ! []


updateSelectedContact : (Contact -> Contact) -> Model -> Model
updateSelectedContact updateFunction model =
    let
        updatedContact =
            Maybe.map (updateFunction)
    in
        { model | selectedContact = updatedContact model.selectedContact }


loadContacts : Cmd Msg
loadContacts =
    let
        url =
            "http://localhost:3030/contacts"
    in
        HttpBuilder.get url
            |> HttpBuilder.withExpect (Http.expectJson Contact.decodeList)
            |> HttpBuilder.send handleGetContactsComplete


handleGetContactsComplete : Result Http.Error (List Contact) -> Msg
handleGetContactsComplete result =
    case result of
        Ok contacts ->
            GetContactsSuccedd contacts

        Err _ ->
            GetContactsFailed


putContact : Int -> Contact -> Cmd Msg
putContact id contact =
    let
        url =
            "http://localhost:3030/contacts/" ++ (toString id)
    in
        HttpBuilder.put url
            |> HttpBuilder.withJsonBody (Contact.encode contact)
            |> HttpBuilder.withExpect (Http.expectJson Contact.decode)
            |> HttpBuilder.send handlePutContactRequestComplete


handlePutContactRequestComplete : Result Http.Error Contact -> Msg
handlePutContactRequestComplete result =
    case result of
        Ok contact ->
            PutContactSucceed

        Err _ ->
            PutContactFailed


postContact : Contact -> Cmd Msg
postContact contact =
    let
        url =
            "http://localhost:3030/contacts"
    in
        HttpBuilder.post url
            |> HttpBuilder.withJsonBody (Contact.encode contact)
            |> HttpBuilder.withExpect (Http.expectJson Contact.decode)
            |> HttpBuilder.send handlePostContactComplete


handlePostContactComplete : Result Http.Error Contact -> Msg
handlePostContactComplete result =
    case result of
        Ok contact ->
            PostContactSucceed

        Err _ ->
            PostContactFailed



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
