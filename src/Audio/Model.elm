module Audio.Model exposing (..)

import AppSettings exposing (SystemOfMeasurement(..))


type alias SelectorValues =
    { audioConfig : AudioConfig
    , diameter : DiameterInInches
    , tapeThickness : TapeThickness
    , recordingSpeed : RecordingSpeed
    , quantity : Maybe Quantity
    }


type alias Quantity =
    Int


type AudioConfig
    = FullTrackMono
    | HalfTrackStereo
    | HalfTrackMono
    | QuarterTrackStereo
    | QuarterTrackMono
    | Quadraphonic


allAudioConfigs : List AudioConfig
allAudioConfigs =
    [ FullTrackMono, HalfTrackStereo, HalfTrackMono, QuarterTrackStereo, QuarterTrackMono, Quadraphonic ]


type alias Passes =
    Int


type Direction
    = Unidirectional
    | Bidirectional


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

        Quadraphonic ->
            ( Unidirectional, 1 )


type DiameterInInches
    = Three
    | Five
    | Seven
    | TenPtFive


allDiameters : List DiameterInInches
allDiameters =
    [ Three, Five, Seven, TenPtFive ]


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
        Three ->
            "3\""

        Five ->
            "5\""

        Seven ->
            "7\""

        TenPtFive ->
            "10.5\""


diameterMetricName : DiameterInInches -> String
diameterMetricName diameter =
    case diameter of
        Three ->
            "7.6cm"

        Five ->
            "12.7cm"

        Seven ->
            "17.8cm"

        TenPtFive ->
            "26.7cm"


type TapeThickness
    = Mil1p5
    | Mil1p0
    | Mil0p5Double
    | Mil0p5Triple


allThicknesses : List TapeThickness
allThicknesses =
    [ Mil1p5, Mil1p0, Mil0p5Double, Mil0p5Triple ]


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


type RecordingSpeed
    = IPS_0p9375
    | IPS_1p875
    | IPS_3p75
    | IPS_7p5
    | IPS_15
    | IPS_30


allRecordingSpeeds : List RecordingSpeed
allRecordingSpeeds =
    [ IPS_0p9375, IPS_1p875, IPS_3p75, IPS_7p5, IPS_15, IPS_30 ]


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
        IPS_0p9375 ->
            "15/16ips"

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
        IPS_0p9375 ->
            "2.38cm/s"

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
