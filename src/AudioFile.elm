module AudioFile exposing (..)

import Audio.Model exposing (AudioConfig(..))
import Audio.Reel.Model exposing (Reel, fullDuration)


type FileType
    = WAV_24_96
    | WAV_24_48
    | WAV_16_48


allFileTypes : List FileType
allFileTypes =
    [ WAV_24_96, WAV_24_48, WAV_16_48 ]


filesize : FileType -> Reel -> Float
filesize fileType reel =
    let
        channels =
            case reel.audioConfig of
                HalfTrackStereo ->
                    2

                QuarterTrackStereo ->
                    2

                Quadraphonic ->
                    4

                _ ->
                    1

        mbPerMin =
            case fileType of
                WAV_24_96 ->
                    16.875

                WAV_24_48 ->
                    8.4375

                WAV_16_48 ->
                    5.625

        duration =
            fullDuration reel
    in
    duration * mbPerMin * channels


totalFilesize : FileType -> List Reel -> Float
totalFilesize fileType reels =
    List.sum <| List.map (filesize fileType) reels


fileTypeName : FileType -> String
fileTypeName ft =
    case ft of
        WAV_24_96 ->
            "24/96 WAV"

        WAV_24_48 ->
            "24/48 WAV"

        WAV_16_48 ->
            "16/48 WAV"
