module View.View exposing (view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class, type_)
import Model.Model exposing (Model)
import Update.Messages exposing (..)
import View.Toolbar as Toolbar
import View.ContactsList as ContactsList
import View.ContactPanel as ContactPanel


toolbarConfig : Toolbar.Config Msg
toolbarConfig =
    { addMessage = AddContact }


contactsListConfig : ContactsList.Config Msg
contactsListConfig =
    ContactsList.config { selectMsg = Select }


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row " ] [ h1 [] [ text "Contacts" ] ]
        , ContactPanel.view model.selectedContact
        , Toolbar.view toolbarConfig
        , (ContactsList.view contactsListConfig model.contacts)
        ]
