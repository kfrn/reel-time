module Helpers exposing (..)

import Types exposing (..)
import Uuid exposing (Uuid)


newReel : Uuid.Uuid -> SelectorValues -> ReelEntry
newReel uuid selectorValues =
    { id = uuid
    , audioConfig = selectorValues.audioConfig
    , diameter = selectorValues.diameter
    , thickness = selectorValues.thickness
    , recordingSpeed = selectorValues.recordingSpeed
    , quantity = 1
    }


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


diameterFromString : String -> Maybe Diameter
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


audioConfigDisplayName : AudioConfig -> String
audioConfigDisplayName audioConfig =
    case audioConfig of
        FullTrackMono ->
            "full-track mono"

        HalfTrackStereo ->
            "half-track stereo"

        HalfTrackMono ->
            "half-track mono"

        QuarterTrackStereo ->
            "quarter-track stereo"

        QuarterTrackMono ->
            "quarter-track mono"


diameterDisplayName : Diameter -> String
diameterDisplayName diameter =
    case diameter of
        Five ->
            "5\" / 12.7cm"

        Seven ->
            "7\" / 17.8cm"

        TenPtFive ->
            "10.5\" / 26.7cm"


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


speedDisplayName : RecordingSpeed -> String
speedDisplayName speed =
    case speed of
        IPS_1p875 ->
            "1.875 ips"

        IPS_3p75 ->
            "3.75 ips"

        IPS_7p5 ->
            "7.5 ips"

        IPS_15 ->
            "15 ips"

        IPS_30 ->
            "30 ips"
