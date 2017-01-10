module Update.Update exposing (update, getContacts)

import Http
import HttpBuilder
import Contact exposing (Contact)
import Messages exposing (..)
import Model exposing (Model)


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
