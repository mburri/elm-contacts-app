module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, init)
import Update.Update exposing (update)
import View.View exposing (view)
import Subscriptions exposing (subscriptions)
import Update.ContactHttp as ContactHttp


main =
    Html.program
        { init = init ContactHttp.getContacts
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
