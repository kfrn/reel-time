module Messages exposing (Msg(..))

import AppSettings exposing (PageView, SystemOfMeasurement)
import Audio.Model exposing (AudioConfig, DiameterInInches, RecordingSpeed, TapeThickness)
import AudioFile exposing (FileType)
import Translate exposing (Language)
import Uuid exposing (Uuid)


type Msg
    = AddReel
    | ChangeLanguage Language
    | ChangeSystemOfMeasurement SystemOfMeasurement
    | DeleteReel Uuid
    | KeyDown Int
    | NoOp
    | SetAudioConfig AudioConfig
    | SetDiameterInInches DiameterInInches
    | SetFileType FileType
    | SetQuantity String
    | SetRecordingSpeed RecordingSpeed
    | SetTapeThickness TapeThickness
    | StartExport
    | TogglePageView PageView
