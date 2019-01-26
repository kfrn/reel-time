module Messages exposing (Msg(..))

import AppSettings exposing (PageView, SystemOfMeasurement)
import Audio.Model exposing (AudioConfig, DiameterInInches, RecordingSpeed, TapeThickness)
import AudioFile exposing (FileType)
import Translate exposing (Language)
import Uuid exposing (Uuid)


type Msg
    = KeyDown Int
    | AddReel
    | DeleteReel Uuid
    | ChangeFileType FileType
    | ChangeAudioConfig AudioConfig
    | ChangeDiameterInInches DiameterInInches
    | ChangeTapeThickness TapeThickness
    | ChangeRecordingSpeed RecordingSpeed
    | UpdateQuantity String
    | ChangeSystemOfMeasurement SystemOfMeasurement
    | ChangeLanguage Language
    | TogglePageView PageView
    | StartExport
    | NoOp
