module Update.Update exposing (update)

import Http
import HttpBuilder
import Contact exposing (Contact)
import Messages exposing (..)
import Model exposing (Model)
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


updateContact : (Contact -> Contact) -> Model -> Model
updateContact updateFunction model =
    let
        updatedContact =
            Maybe.map (updateFunction)
    in
        { model | selectedContact = updatedContact model.selectedContact }


changeInput : Field -> String -> Model -> ( Model, Cmd Msg )
changeInput field value model =
    case field of
        Firstname ->
            (updateContact
                (\c ->
                    { c | firstname = value }
                )
                model
            )
                ! []

        Lastname ->
            (updateContact
                (\c ->
                    { c | lastname = value }
                )
                model
            )
                ! []

        Phone ->
            (updateContact
                (\c ->
                    { c | phone = value }
                )
                model
            )
                ! []
