module Types exposing (..)

import Json.Decode exposing (..)


type alias Info =
    { elmVersion : String
    }


decoder : Decoder Info
decoder =
    map Info
        (field "elm-version" string)
