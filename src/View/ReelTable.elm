module View.ReelTable exposing (reelTable)

import AppSettings exposing (SystemOfMeasurement(..))
import Audio.Model exposing (Direction, Passes, allAudioConfigs, allDiameters, allRecordingSpeeds, allThicknesses, diameterDisplayName, speedDisplayName, tapeThicknessDisplayName)
import Audio.Reel.Model exposing (Footage, Reel, footageToInt, formatTime, fullDuration, overallDuration, reelLengthInFeet, singleReelDuration)
import AudioFile exposing (FileType(..), allFileTypes, fileTypeName, totalFilesize)
import Html exposing (..)
import Html.Attributes exposing (class, classList, disabled, id, placeholder)
import Html.Events exposing (onClick, onInput)
import Maybe.Extra exposing (isNothing)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Translate exposing (AppString(..), Language(..), audioConfigDisplayName, directionString, translate)
import Uuid
import View.Desktop.ReelTable exposing (desktopReelTable)
import View.Helpers exposing (renderSelect)


reelTable : Model -> Html Msg
reelTable model =
    desktopReelTable model
