module Calculations exposing (..)

import Helpers exposing (reelInfo)
import Types exposing (..)


reelLengthInFeet : Reel -> Footage
reelLengthInFeet reel =
    case ( reel.diameter, reel.tapeThickness ) of
        ( Three, Mil1p5 ) ->
            Ft150

        ( Three, Mil1p0 ) ->
            Ft225

        ( Three, Mil0p5Double ) ->
            Ft300

        ( Three, Mil0p5Triple ) ->
            Ft375

        ( Five, Mil1p5 ) ->
            Ft600

        ( Five, Mil1p0 ) ->
            Ft900

        ( Five, Mil0p5Double ) ->
            Ft1200

        ( Five, Mil0p5Triple ) ->
            Ft1800

        ( Seven, Mil1p5 ) ->
            Ft1200

        ( Seven, Mil1p0 ) ->
            Ft1800

        ( Seven, Mil0p5Double ) ->
            Ft2400

        ( Seven, Mil0p5Triple ) ->
            Ft3600

        ( TenPtFive, Mil1p5 ) ->
            Ft2400

        ( TenPtFive, Mil1p0 ) ->
            Ft3600

        ( TenPtFive, Mil0p5Double ) ->
            Ft4800

        ( TenPtFive, Mil0p5Triple ) ->
            Ft7200



-- The baseDuration is the duration of the reel if recorded at the maximum speed of 30ips.


baseDuration : Reel -> Float
baseDuration reel =
    let
        footage =
            reelLengthInFeet reel
    in
    case footage of
        Ft150 ->
            0.9375

        Ft225 ->
            1.40625

        Ft300 ->
            1.875

        Ft375 ->
            2.34375

        Ft600 ->
            3.75

        Ft900 ->
            5.625

        Ft1200 ->
            7.5

        Ft1800 ->
            11.25

        Ft2400 ->
            15

        Ft3600 ->
            22.5

        Ft4800 ->
            30

        Ft7200 ->
            45


durationInMinutes : Reel -> DurationInMinutes
durationInMinutes reel =
    let
        baseDur =
            baseDuration reel
    in
    case reel.recordingSpeed of
        IPS_0p9375 ->
            baseDur * 32

        IPS_1p875 ->
            baseDur * 16

        IPS_3p75 ->
            baseDur * 8

        IPS_7p5 ->
            baseDur * 4

        IPS_15 ->
            baseDur * 2

        IPS_30 ->
            baseDur


fullDuration : Reel -> DurationInMinutes
fullDuration reel =
    toFloat reel.passes * durationInMinutes reel


totalLength : List Reel -> DurationInMinutes
totalLength reels =
    let
        reelDuration r =
            fullDuration r * toFloat r.quantity
    in
    List.sum <| List.map reelDuration reels


filesize : FileType -> Reel -> Float
filesize fileType reel =
    let
        multiplier =
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

        ( _, passes ) =
            reelInfo reel.audioConfig

        duration =
            durationInMinutes reel
    in
    duration * mbPerMin * toFloat passes * multiplier
