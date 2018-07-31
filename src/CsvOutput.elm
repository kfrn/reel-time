module CsvOutput exposing (dataForCSV)

import Audio.Model exposing (diameterImperialName, speedImperialName, tapeThicknessDisplayName)
import Audio.Reel.Model exposing (Reel, footageToInt, fullDuration, overallDuration, reelLengthInFeet, singleReelDuration)
import AudioFile exposing (FileType(..), fileTypeName, totalFilesize)
import Translate exposing (AppString(..), Language, audioConfigDisplayName, directionString, translate)


dataForCSV : Language -> FileType -> List Reel -> List (List String)
dataForCSV lang fileType reels =
    [ headerRow lang ]
        ++ List.map (reelRow lang) reels
        ++ [ totalRow lang reels
           , sizeRow lang fileType reels
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


reelRow : Language -> Reel -> List String
reelRow language reel =
    [ translate language <| audioConfigDisplayName reel.audioConfig
    , diameterImperialName reel.diameter
    , tapeThicknessDisplayName reel.tapeThickness
    , speedImperialName reel.recordingSpeed
    , toString reel.quantity
    , translate language (directionString reel.directionality)
    , toString reel.passes
    , toString <| footageToInt <| reelLengthInFeet reel
    , toString <| singleReelDuration reel
    , toString <| fullDuration reel
    ]


totalRow : Language -> List Reel -> List String
totalRow lang reels =
    List.repeat 7 ""
        ++ [ translate lang TotalDurationStr
           , ""
           , toString <| overallDuration reels
           ]


sizeRow : Language -> FileType -> List Reel -> List String
sizeRow lang fileType reels =
    List.repeat 7 ""
        ++ [ translate lang FileSizeStr
           , fileTypeName fileType
           , translate lang (SizeInMegaBytesStr <| totalFilesize fileType reels)
           ]
