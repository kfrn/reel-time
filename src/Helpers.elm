module Helpers exposing (..)

import Translate exposing (AppString(..))
import Types exposing (..)
import Uuid exposing (Uuid)


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


reelInfo : AudioConfig -> ( Direction, Passes )
reelInfo config =
    case config of
        FullTrackMono ->
            ( Unidirectional, 1 )

        HalfTrackStereo ->
            ( Unidirectional, 1 )

        HalfTrackMono ->
            ( Bidirectional, 2 )

        QuarterTrackStereo ->
            ( Bidirectional, 2 )

        QuarterTrackMono ->
            ( Bidirectional, 4 )


audioConfigFromString : String -> Maybe AudioConfig
audioConfigFromString name =
    case name of
        "FullTrackMono" ->
            Just FullTrackMono

        "HalfTrackStereo" ->
            Just HalfTrackStereo

        "HalfTrackMono" ->
            Just HalfTrackMono

        "QuarterTrackStereo" ->
            Just QuarterTrackStereo

        "QuarterTrackMono" ->
            Just QuarterTrackMono

        _ ->
            Nothing


audioConfigDisplayName : AudioConfig -> AppString
audioConfigDisplayName audioConfig =
    case audioConfig of
        FullTrackMono ->
            FullTrackMonoStr

        HalfTrackStereo ->
            HalfTrackStereoStr

        HalfTrackMono ->
            HalfTrackMonoStr

        QuarterTrackStereo ->
            QuarterTrackStereoStr

        QuarterTrackMono ->
            QuarterTrackMonoStr


diameterFromString : String -> Maybe DiameterInInches
diameterFromString name =
    case name of
        "Five" ->
            Just Five

        "Seven" ->
            Just Seven

        "TenPtFive" ->
            Just TenPtFive

        _ ->
            Nothing


tapeThicknessFromString : String -> Maybe TapeThickness
tapeThicknessFromString name =
    case name of
        "Mil1p5" ->
            Just Mil1p5

        "Mil1p0" ->
            Just Mil1p0

        "Mil0p5Double" ->
            Just Mil0p5Double

        "Mil0p5Triple" ->
            Just Mil0p5Triple

        _ ->
            Nothing


recordingSpeedFromString : String -> Maybe RecordingSpeed
recordingSpeedFromString name =
    case name of
        "IPS_1p875" ->
            Just IPS_1p875

        "IPS_3p75" ->
            Just IPS_3p75

        "IPS_7p5" ->
            Just IPS_7p5

        "IPS_15" ->
            Just IPS_15

        "IPS_30" ->
            Just IPS_30

        _ ->
            Nothing


diameterDisplayName : SystemOfMeasurement -> (DiameterInInches -> String)
diameterDisplayName system =
    case system of
        Imperial ->
            diameterImperialName

        Metric ->
            diameterMetricName


diameterImperialName : DiameterInInches -> String
diameterImperialName diameter =
    case diameter of
        Five ->
            "5\""

        Seven ->
            "7\""

        TenPtFive ->
            "10.5\""


diameterMetricName : DiameterInInches -> String
diameterMetricName diameter =
    case diameter of
        Five ->
            "12.7cm"

        Seven ->
            "17.8cm"

        TenPtFive ->
            "26.7cm"


tapeThicknessDisplayName : TapeThickness -> String
tapeThicknessDisplayName thickness =
    case thickness of
        Mil1p5 ->
            "1.5 mil"

        Mil1p0 ->
            "1.0 mil"

        Mil0p5Double ->
            "0.5 mil double"

        Mil0p5Triple ->
            "0.5 mil triple"


speedDisplayName : SystemOfMeasurement -> (RecordingSpeed -> String)
speedDisplayName system =
    case system of
        Imperial ->
            speedImperialName

        Metric ->
            speedMetricName


speedImperialName : RecordingSpeed -> String
speedImperialName speed =
    case speed of
        IPS_1p875 ->
            "1.875ips"

        IPS_3p75 ->
            "3.75ips"

        IPS_7p5 ->
            "7.5ips"

        IPS_15 ->
            "15ips"

        IPS_30 ->
            "30ips"


speedMetricName : RecordingSpeed -> String
speedMetricName speed =
    case speed of
        IPS_1p875 ->
            "4.75cm/s"

        IPS_3p75 ->
            "9.5cm/s"

        IPS_7p5 ->
            "19cm/s"

        IPS_15 ->
            "38cm/s"

        IPS_30 ->
            "76cm/s"


footageToInt : Footage -> LengthInFeet
footageToInt footage =
    case footage of
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
