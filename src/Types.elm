module Types exposing (..)

import Uuid exposing (Uuid)


type alias Direction =
    String


type alias Passes =
    Int


type alias LengthInFeet =
    Int


type alias DurationInMinutes =
    Float


type alias Reel =
    { id : Uuid.Uuid
    , audioConfig : AudioConfig
    , diameter : DiameterInInches
    , tapeThickness : TapeThickness
    , recordingSpeed : RecordingSpeed
    , quantity : Int
    }


type alias SelectorValues =
    { audioConfig : AudioConfig
    , diameter : DiameterInInches
    , tapeThickness : TapeThickness
    , recordingSpeed : RecordingSpeed
    }


type AudioConfig
    = FullTrackMono
    | HalfTrackStereo
    | HalfTrackMono
    | QuarterTrackStereo
    | QuarterTrackMono


allAudioConfigs : List AudioConfig
allAudioConfigs =
    [ FullTrackMono, HalfTrackStereo, HalfTrackMono, QuarterTrackStereo, QuarterTrackMono ]


type DiameterInInches
    = Five
    | Seven
    | TenPtFive


allDiameters : List DiameterInInches
allDiameters =
    [ Five, Seven, TenPtFive ]


type TapeThickness
    = Mil1p5
    | Mil1p0
    | Mil0p5Double
    | Mil0p5Triple


allThicknesses : List TapeThickness
allThicknesses =
    [ Mil1p5, Mil1p0, Mil0p5Double, Mil0p5Triple ]


type RecordingSpeed
    = IPS_1p875
    | IPS_3p75
    | IPS_7p5
    | IPS_15
    | IPS_30


allRecordingSpeeds : List RecordingSpeed
allRecordingSpeeds =
    [ IPS_1p875, IPS_3p75, IPS_7p5, IPS_15, IPS_30 ]


type Footage
    = Ft600
    | Ft900
    | Ft1200
    | Ft1800
    | Ft2400
    | Ft3600
    | Ft4800
    | Ft7200
