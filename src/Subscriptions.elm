module Subscriptions exposing (..)

import Model exposing (Model)
import Messages exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
