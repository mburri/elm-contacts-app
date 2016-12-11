module Contact exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode


type alias Contact =
    { id : Maybe Int
    , firstname : String
    , lastname : String
    , phone : String
    }


empty : Contact
empty =
    Contact Nothing "" "" ""


encode : Contact -> Encode.Value
encode contact =
    Encode.object
        [ ( "first_name", Encode.string contact.firstname )
        , ( "last_name", Encode.string contact.lastname )
        , ( "phone", Encode.string contact.phone )
        ]


decode : Decode.Decoder Contact
decode =
    Decode.map4 Contact
        (Decode.nullable (Decode.field "id" Decode.int))
        (Decode.field "first_name" Decode.string)
        (Decode.field "last_name" Decode.string)
        (Decode.field "phone" Decode.string)


decodeList : Decode.Decoder (List Contact)
decodeList =
    Decode.list decode
