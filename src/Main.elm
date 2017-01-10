module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, init)
import Update.Update exposing (update)
import View.View exposing (view)
import Subscriptions exposing (subscriptions)
import Update.ContactRequests as ContactRequests


main =
    Html.program
        { init = init ContactRequests.getContacts
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
