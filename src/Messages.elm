module Messages exposing (..)

import Contact exposing (Contact)


type Field
    = Firstname
    | Lastname
    | Phone


type Msg
    = NoOp
    | AddContact
    | SaveContact
    | DeleteContact
    | Cancel
    | Select Contact
    | Change Field String
    | GetContactsSuccedd (List Contact)
    | GetContactsFailed
    | PostContactSucceed
    | PostContactFailed
    | PutContactSucceed
    | PutContactFailed
    | DeleteContactSucceed
    | DeleteContactFailed
