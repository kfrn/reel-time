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
    | SetFileType FileType
    | SetAudioConfig AudioConfig
    | SetDiameterInInches DiameterInInches
    | SetTapeThickness TapeThickness
    | SetRecordingSpeed RecordingSpeed
    | SetQuantity String
    | ChangeSystemOfMeasurement SystemOfMeasurement
    | ChangeLanguage Language
    | TogglePageView PageView
    | StartExport
    | NoOp
