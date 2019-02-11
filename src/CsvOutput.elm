module CsvOutput exposing (dataForCSV)

import AppSettings exposing (SystemOfMeasurement(..))
import Audio.Model exposing (diameterImperialName, speedImperialName, tapeThicknessDisplayName)
import Audio.Reel.Model exposing (Reel, footageToInt, fullDuration, overallDuration, reelLengthInFeet, singleReelDuration)
import AudioFile exposing (FileType(..), fileTypeName, totalFilesize)
import Model exposing (Model)
import Translate exposing (AppString(..), Language, audioConfigDisplayName, directionString, translate)


dataForCSV : Model -> List (List String)
dataForCSV model =
    [ headerRow model.language ]
        ++ List.map (reelRow model.language model.system) model.reels
        ++ [ totalRow model.language model.reels
           , sizeRow model.language model.fileType model.reels
           ]


headerRow : Language -> List String
headerRow lang =
    [ translate lang TypeStr
    , translate lang DiameterStr
    , translate lang ThicknessStr
    , translate lang SpeedStr
    , translate lang QuantityStr
    , translate lang DirectionStr
    , translate lang PassesStr
    , translate lang FootagePerReelStr
    , translate lang (PerReelStr <| translate lang MinutesStr)
    , translate lang TotalDurationStr
    ]


reelRow : Language -> SystemOfMeasurement -> Reel -> List String
reelRow language system reel =
    [ translate language <| audioConfigDisplayName reel.audioConfig
    , diameterImperialName reel.diameter
    , tapeThicknessDisplayName system reel.tapeThickness
    , speedImperialName reel.recordingSpeed
    , String.fromInt reel.quantity
    , translate language (directionString reel.directionality)
    , String.fromInt reel.passes
    , String.fromInt <| footageToInt <| reelLengthInFeet reel
    , String.fromFloat <| singleReelDuration reel
    , String.fromFloat <| fullDuration reel
    ]


totalRow : Language -> List Reel -> List String
totalRow lang reels =
    List.repeat 7 ""
        ++ [ translate lang TotalDurationStr
           , ""
           , String.fromFloat <| overallDuration reels
           ]


sizeRow : Language -> FileType -> List Reel -> List String
sizeRow lang fileType reels =
    List.repeat 7 ""
        ++ [ translate lang FileSizeStr
           , fileTypeName fileType
           , translate lang (SizeInMegaBytesStr <| totalFilesize fileType reels)
           ]
