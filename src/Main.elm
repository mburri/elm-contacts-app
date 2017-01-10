module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, init)
import Update.Update exposing (update, getContacts)
import View.View exposing (view)
import Subscriptions exposing (subscriptions)


main =
    Html.program
        { init = init getContacts
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
