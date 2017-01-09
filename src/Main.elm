module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, init)
import Messages exposing (..)
import Update exposing (..)
import View exposing (view)


main =
    Html.program
        { init = init getContacts
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
