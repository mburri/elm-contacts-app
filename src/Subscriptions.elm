module Subscriptions exposing (subscriptions)

import Model.Model exposing (Model)
import Update.Messages exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
