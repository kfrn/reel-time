module Calculations exposing (..)

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
        multiplier =
            baseDuration reel
    in
    case reel.recordingSpeed of
        IPS_1p875 ->
            multiplier * 16

        IPS_3p75 ->
            multiplier * 8

        IPS_7p5 ->
            multiplier * 4

        IPS_15 ->
            multiplier * 2

        IPS_30 ->
            multiplier
