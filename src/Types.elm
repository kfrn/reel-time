module Types exposing (..)

import Uuid


type alias Passes =
    Int


type alias LengthInFeet =
    Int


type alias DurationInMinutes =
    Float


type alias Quantity =
    Int


type SystemOfMeasurement
    = Metric
    | Imperial


type Direction
    = Unidirectional
    | Bidirectional


type PageView
    = Calculator
    | Info


allSystemsOfMeasurement : List SystemOfMeasurement
allSystemsOfMeasurement =
    [ Metric, Imperial ]


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


type alias SelectorValues =
    { audioConfig : AudioConfig
    , diameter : DiameterInInches
    , tapeThickness : TapeThickness
    , recordingSpeed : RecordingSpeed
    , quantity : Maybe Quantity
    }


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


type DiameterInInches
    = Three
    | Five
    | Seven
    | TenPtFive


allDiameters : List DiameterInInches
allDiameters =
    [ Three, Five, Seven, TenPtFive ]


type TapeThickness
    = Mil1p5
    | Mil1p0
    | Mil0p5Double
    | Mil0p5Triple


allThicknesses : List TapeThickness
allThicknesses =
    [ Mil1p5, Mil1p0, Mil0p5Double, Mil0p5Triple ]


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


type FileType
    = WAV_24_96
    | WAV_24_48
    | WAV_16_48


allFileTypes : List FileType
allFileTypes =
    [ WAV_24_96, WAV_24_48, WAV_16_48 ]
