module Audio.Model exposing (AudioConfig(..), DiameterInInches(..), Direction(..), Passes, Quantity, RecordingSpeed(..), SelectorValues, TapeThickness(..), allAudioConfigs, allDiameters, allRecordingSpeeds, allThicknesses, diameterDisplayName, diameterImperialName, diameterMetricName, reelInfo, speedDisplayName, speedImperialName, speedMetricName, tapeThicknessDisplayName)

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
    let
        cmString float =
            String.fromFloat float ++ " cm"
    in
    case diameter of
        Three ->
            cmString 7.6

        Five ->
            cmString 12.7

        Seven ->
            cmString 17.8

        TenPtFive ->
            cmString 26.7


type TapeThickness
    = Mil1p5
    | Mil1p0
    | Mil0p5Double
    | Mil0p5Triple


allThicknesses : List TapeThickness
allThicknesses =
    [ Mil1p5, Mil1p0, Mil0p5Double, Mil0p5Triple ]


tapeThicknessDisplayName : SystemOfMeasurement -> TapeThickness -> String
tapeThicknessDisplayName system thickness =
    case ( thickness, system ) of
        ( Mil1p5, Imperial ) ->
            "1.5 mil"

        ( Mil1p0, Imperial ) ->
            "1.0 mil"

        ( Mil0p5Double, Imperial ) ->
            "0.5 mil double"

        ( Mil0p5Triple, Imperial ) ->
            "0.5 mil triple"

        ( Mil1p5, Metric ) ->
            "50 μm (single)"

        ( Mil1p0, Metric ) ->
            "35 μm (long)"

        ( Mil0p5Double, Metric ) ->
            "25 μm (double)"

        ( Mil0p5Triple, Metric ) ->
            "18 μm (triple)"


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
    let
        ipsString num =
            num ++ " ips"
    in
    case speed of
        IPS_0p9375 ->
            ipsString "15/16"

        IPS_1p875 ->
            ipsString "1.875"

        IPS_3p75 ->
            ipsString "3.75"

        IPS_7p5 ->
            ipsString "7.5"

        IPS_15 ->
            ipsString "15"

        IPS_30 ->
            ipsString "30"


speedMetricName : RecordingSpeed -> String
speedMetricName speed =
    let
        cmsString float =
            String.fromFloat float ++ " cm/s"
    in
    case speed of
        IPS_0p9375 ->
            cmsString 2.38

        IPS_1p875 ->
            cmsString 4.75

        IPS_3p75 ->
            cmsString 9.5

        IPS_7p5 ->
            cmsString 19

        IPS_15 ->
            cmsString 38

        IPS_30 ->
            cmsString 76
