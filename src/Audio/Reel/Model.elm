module Audio.Reel.Model exposing (..)

import Audio.Model exposing (AudioConfig, DiameterInInches(..), Direction, Passes, Quantity, RecordingSpeed(..), SelectorValues, TapeThickness(..), reelInfo)
import Uuid


type alias Reel =
    { id : Uuid.Uuid
    , audioConfig : AudioConfig
    , diameter : DiameterInInches
    , tapeThickness : TapeThickness
    , recordingSpeed : RecordingSpeed
    , quantity : Quantity
    , passes : Passes
    , directionality : Direction
    }


type Footage
    = Ft150
    | Ft225
    | Ft300
    | Ft375
    | Ft600
    | Ft900
    | Ft1200
    | Ft1800
    | Ft2400
    | Ft3600
    | Ft4800
    | Ft7200


footageToInt : Footage -> Int
footageToInt footage =
    case footage of
        Ft150 ->
            150

        Ft225 ->
            225

        Ft300 ->
            300

        Ft375 ->
            375

        Ft600 ->
            600

        Ft900 ->
            900

        Ft1200 ->
            1200

        Ft1800 ->
            1800

        Ft2400 ->
            2400

        Ft3600 ->
            3600

        Ft4800 ->
            4800

        Ft7200 ->
            7200


type alias DurationInMinutes =
    Float


formatTime : DurationInMinutes -> String
formatTime mins =
    let
        padNumber num =
            if num < 10 then
                "0" ++ toString num
            else
                toString num

        totalSeconds =
            round <| mins * 60

        hours =
            totalSeconds // 3600

        minutes =
            (totalSeconds - (hours * 3600)) // 60

        seconds =
            totalSeconds - (hours * 3600) - (minutes * 60)
    in
    padNumber hours ++ ":" ++ padNumber minutes ++ ":" ++ padNumber seconds


newReel : Uuid.Uuid -> SelectorValues -> Quantity -> Reel
newReel uuid selectorValues quantity =
    let
        ( direction, passes ) =
            reelInfo selectorValues.audioConfig
    in
    { id = uuid
    , audioConfig = selectorValues.audioConfig
    , diameter = selectorValues.diameter
    , tapeThickness = selectorValues.tapeThickness
    , recordingSpeed = selectorValues.recordingSpeed
    , quantity = quantity
    , passes = passes
    , directionality = direction
    }


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


baseDuration : Reel -> Float
baseDuration reel =
    -- The baseDuration is the duration of the reel if recorded at the maximum speed of 30ips, for a single pass.
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


singleReelDuration : Reel -> DurationInMinutes
singleReelDuration reel =
    -- This is the full duration for a single reel, i.e. quantity = 1.
    -- It takes into account the actual recording speed, and the number of passes.
    let
        baseDur =
            baseDuration reel

        speedAdjustedDur =
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
    in
    toFloat reel.passes * speedAdjustedDur


fullDuration : Reel -> DurationInMinutes
fullDuration reel =
    -- This calculation takes into account the quantity.
    singleReelDuration reel * toFloat reel.quantity


overallDuration : List Reel -> DurationInMinutes
overallDuration reels =
    List.sum <| List.map fullDuration reels
