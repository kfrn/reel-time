module Messages exposing (..)

import Translate exposing (Language)
import Types exposing (..)
import Uuid exposing (Uuid)


type Msg
    = AddReel
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
