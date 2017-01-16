module Update.Update exposing (update)

import Http
import HttpBuilder
import Model.Contact as Contact exposing (Contact)
import Model.Model exposing (Model)
import Update.Messages exposing (..)
import Update.ContactHttp as ContactHttp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        AddContact ->
            { model | selectedContact = Just Contact.empty } ! []

        Select contact ->
            { model | selectedContact = Just contact } ! []

        SaveContact ->
            ContactHttp.saveContact model

        DeleteContact ->
            ContactHttp.deleteContact model

        Cancel ->
            { model | selectedContact = Nothing } ! []

        Change field value ->
            changeInput field value model

        GetContactsSuccedd contacts ->
            ( { model | contacts = contacts }, Cmd.none )

        GetContactsFailed ->
            model ! []

        PostContactSucceed ->
            ( { model | selectedContact = Nothing }, ContactHttp.getContacts )

        PostContactFailed ->
            model ! []

        PutContactSucceed ->
            ( { model | selectedContact = Nothing }, ContactHttp.getContacts )

        PutContactFailed ->
            model ! []

        DeleteContactSucceed ->
            ( { model | selectedContact = Nothing }, ContactHttp.getContacts )

        DeleteContactFailed ->
            model ! []


changeInput : Field -> String -> Model -> ( Model, Cmd Msg )
changeInput field value model =
    case model.selectedContact of
        Just contact ->
            let
                updated =
                    updateContact field value contact
            in
                ( { model | selectedContact = Just updated }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


updateContact : Field -> String -> Contact -> Contact
updateContact field value contact =
    case field of
        Firstname ->
            { contact | firstname = value }

        Lastname ->
            { contact | lastname = value }

        Phone ->
            { contact | phone = value }
