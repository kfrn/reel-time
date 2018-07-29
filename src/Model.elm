module Model exposing (Model, init)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..))
import Audio.Model exposing (AudioConfig(..), DiameterInInches(..), RecordingSpeed(..), SelectorValues, TapeThickness(..))
import Audio.Reel.Model exposing (Reel)
import AudioFile exposing (FileType(..))
import Random.Pcg exposing (Seed, initialSeed, step)
import Translate exposing (Language(..))
import Uuid exposing (uuidGenerator)


type alias Model =
    { currentSeed : Seed
    , reels : List Reel
    , selectorValues : SelectorValues
    , fileType : FileType
    , system : SystemOfMeasurement
    , language : Language
    , page : PageView
    }


init : ( Model, Cmd msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    let
        ( _, seed ) =
            step uuidGenerator (initialSeed 19580607)

        initialSelectorValues =
            { audioConfig = FullTrackMono
            , diameter = Seven
            , tapeThickness = Mil1p5
            , recordingSpeed = IPS_7p5
            , quantity = Nothing
            }
    in
    { currentSeed = seed
    , reels = []
    , selectorValues = initialSelectorValues
    , fileType = WAV_24_96
    , system = Imperial
    , language = EN
    , page = Calculator
    }
