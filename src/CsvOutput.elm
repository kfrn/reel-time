module CsvOutput exposing (dataForCSV)

import Calculations
import Helpers exposing (..)
import Translate exposing (AppString(..), Language, translate)
import Types exposing (..)


delimiter : String
delimiter =
    ","


dataForCSV : Language -> FileType -> List Reel -> String
dataForCSV lang fileType reels =
    let
        lineBreak =
            "\n"

        csvLines =
            [ headerRow lang ]
                ++ List.map (reelRow lang) reels
                ++ [ lineBreak
                   , totalRow lang reels
                   , sizeRow lang fileType reels
                   ]
    in
    String.concat <| List.intersperse lineBreak csvLines


headerRow : Language -> String
headerRow lang =
    String.join delimiter
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


reelRow : Language -> Reel -> String
reelRow language reel =
    String.join delimiter
        [ translate language <| audioConfigDisplayName reel.audioConfig
        , diameterImperialName reel.diameter
        , tapeThicknessDisplayName reel.tapeThickness
        , speedImperialName reel.recordingSpeed
        , toString reel.quantity
        , translate language (directionString reel.directionality)
        , toString reel.passes
        , toString <| footageToInt <| Calculations.reelLengthInFeet reel
        , toString <| Calculations.singleReelDuration reel
        , toString <| Calculations.fullDuration reel
        ]


totalRow : Language -> List Reel -> String
totalRow lang reels =
    String.repeat 7 delimiter
        ++ translate lang TotalDurationStr
        ++ String.repeat 2 delimiter
        ++ (toString <| Calculations.overallDuration reels)


sizeRow : Language -> FileType -> List Reel -> String
sizeRow lang fileType reels =
    String.repeat 7 delimiter
        ++ translate lang FileSizeStr
        ++ delimiter
        ++ fileTypeName fileType
        ++ delimiter
        ++ translate lang (SizeInMegaBytesStr <| Calculations.totalFilesize fileType reels)
