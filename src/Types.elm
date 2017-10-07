module Types exposing (..)


type alias RecordingType =
    { audioConfig : String
    , direction : String
    , passes : Int
    }


type alias AudioReel =
    { diameterInches : Float
    , diameterMetric : Float
    , footage : List FootageInfo
    }


type alias FootageInfo =
    { thickness : String
    , totalFootageFeet : Int
    , totalFootageMetric : Float
    }
