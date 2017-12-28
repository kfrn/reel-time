module Calculations exposing (..)

import Helpers exposing (reelInfo)
import Types exposing (..)


reelLengthInFeet : Reel -> Footage
reelLengthInFeet reel =
    case ( reel.diameter, reel.tapeThickness ) of
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


filesize : Reel -> Float
filesize reel =
    let
        multiplier =
            case reel.audioConfig of
                HalfTrackStereo ->
                    2

                QuarterTrackStereo ->
                    2

                _ ->
                    1

        ( _, passes ) =
            reelInfo reel.audioConfig

        duration =
            durationInMinutes reel

        mbPerMin =
            16.875
    in
    duration * mbPerMin * toFloat passes * multiplier
