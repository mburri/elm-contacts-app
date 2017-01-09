module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, class, type_)
import Html.Events exposing (onClick, onInput)
import Http
import HttpBuilder
import Contact exposing (Contact)
import Model exposing (Model, init)


main =
    Html.program
        { init = init getContacts
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- UPDATE


type Field
    = Firstname
    | Lastname
    | Phone


type Msg
    = NoOp
    | AddContact
    | SaveContact
    | DeleteContact
    | Cancel
    | Select Contact
    | Change Field String
    | GetContactsSuccedd (List Contact)
    | GetContactsFailed
    | PostContactSucceed
    | PostContactFailed
    | PutContactSucceed
    | PutContactFailed
    | DeleteContactSucceed
    | DeleteContactFailed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddContact ->
            { model | selectedContact = Just Contact.empty } ! []

        SaveContact ->
            saveContact model

        DeleteContact ->
            deleteContact model

        Cancel ->
            { model | selectedContact = Nothing } ! []

        Select contact ->
            { model | selectedContact = Just contact } ! []

        Change field value ->
            changeInput field value model

        GetContactsSuccedd contacts ->
            ( { model | contacts = contacts }, Cmd.none )

        GetContactsFailed ->
            model ! []

        PostContactSucceed ->
            ( { model | selectedContact = Nothing }, getContacts )

        PostContactFailed ->
            model ! []

        PutContactSucceed ->
            ( { model | selectedContact = Nothing }, getContacts )

        PutContactFailed ->
            model ! []

        DeleteContactSucceed ->
            ( { model | selectedContact = Nothing }, getContacts )

        DeleteContactFailed ->
            model ! []


updateSelectedContact : (Contact -> Contact) -> Model -> Model
updateSelectedContact updateFunction model =
    let
        updatedContact =
            Maybe.map (updateFunction)
    in
        { model | selectedContact = updatedContact model.selectedContact }


changeInput : Field -> String -> Model -> ( Model, Cmd Msg )
changeInput field value model =
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


saveContact : Model -> ( Model, Cmd Msg )
saveContact model =
    case model.selectedContact of
        Nothing ->
            model ! []

        Just contact ->
            case contact.id of
                Nothing ->
                    ( model, postContact contact )

                Just id ->
                    ( model, putContact id contact )


deleteContact : Model -> ( Model, Cmd Msg )
deleteContact model =
    case model.selectedContact of
        Nothing ->
            model ! []

        Just contact ->
            case contact.id of
                Nothing ->
                    model ! []

                Just id ->
                    ( model, deleteContactRequest id )


deleteContactRequest : Int -> Cmd Msg
deleteContactRequest id =
    let
        url =
            "http://localhost:3030/contacts/" ++ (toString id)
    in
        HttpBuilder.delete url
            |> HttpBuilder.send handleDeleteContact


handleDeleteContact result =
    case result of
        Ok _ ->
            DeleteContactSucceed

        Err _ ->
            DeleteContactFailed


getContacts : Cmd Msg
getContacts =
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
