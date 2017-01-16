module Update.ContactHttp exposing (getContacts, saveContact, deleteContact)

import Http
import HttpBuilder
import Model.Model exposing (Model)
import Model.Contact as Contact exposing (Contact)
import Update.Messages exposing (..)


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
