module Calculations exposing (..)

import Types exposing (..)


reelLengthInFeet : ReelEntry -> LengthInFeet
reelLengthInFeet reel =
    case ( reel.diameter, reel.thickness ) of
        ( Five, Mil1p5 ) ->
            600

        ( Five, Mil1p0 ) ->
            900

        ( Five, Mil0p5Double ) ->
            1200

        ( Five, Mil0p5Triple ) ->
            1800

        ( Seven, Mil1p5 ) ->
            1200

        ( Seven, Mil1p0 ) ->
            1800

        ( Seven, Mil0p5Double ) ->
            2400

        ( Seven, Mil0p5Triple ) ->
            3600

        ( TenPtFive, Mil1p5 ) ->
            2400

        ( TenPtFive, Mil1p0 ) ->
            3600

        ( TenPtFive, Mil0p5Double ) ->
            4800

        ( TenPtFive, Mil0p5Triple ) ->
            7200
