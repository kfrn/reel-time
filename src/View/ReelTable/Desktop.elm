module View.ReelTable.Desktop exposing (desktopReelTable)

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
import View.Helpers exposing (onKeyDown, renderSelect)


desktopReelTable : Model -> Html Msg
desktopReelTable model =
    let
        total =
            if List.length model.reels > 0 then
                [ totalRow model.language model.reels model.fileType ]

            else
                []

        reelRows =
            List.map (reelRow model.system model.language) model.reels

        reelTable =
            table [ class "table is-fullwidth" ]
                ([ thead [] [ selectorRow model ]
                 , tbody [] reelRows
                 ]
                    ++ total
                )
    in
    div [ class "is-hidden-touch", id "desktop-reel-table" ] ([ reelTable ] ++ startNotice model.reels model.language)


startNotice : List Reel -> Language -> List (Html Msg)
startNotice reels language =
    if List.isEmpty reels then
        [ div [ class "has-text-centered" ] [ text <| translate language CalcPromptAboveStr ] ]

    else
        []


selectorRow : Model -> Html Msg
selectorRow model =
    let
        invalidQuantity =
            isNothing model.selectorValues.quantity || model.selectorValues.quantity == Just 0
    in
    tr [ class "table-header main-row" ]
        [ th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language TypeStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (translate model.language <| audioConfigDisplayName model.selectorValues.audioConfig)
                    SetAudioConfig
                    (\a -> translate model.language <| audioConfigDisplayName a)
                    allAudioConfigs
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading is-size-6" ] [ text <| translate model.language DiameterStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (diameterDisplayName model.system model.selectorValues.diameter)
                    SetDiameterInInches
                    (diameterDisplayName model.system)
                    allDiameters
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language ThicknessStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (tapeThicknessDisplayName model.system model.selectorValues.tapeThickness)
                    SetTapeThickness
                    (tapeThicknessDisplayName model.system)
                    allThicknesses
                ]
            ]
        , th [ class "pc5" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language SpeedStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (speedDisplayName model.system model.selectorValues.recordingSpeed)
                    SetRecordingSpeed
                    (speedDisplayName model.system)
                    allRecordingSpeeds
                ]
            ]
        , th [ class "pc125 has-text-centered" ]
            [ div [ class "select-heading is-size-6" ] [ text <| translate model.language QuantityStr ]
            , input
                [ classList [ ( "input is-small", True ), ( "is-danger", invalidQuantity ) ]
                , id "quantity"
                , placeholder "#"
                , onInput SetQuantity
                , onKeyDown KeyDown
                ]
                []
            ]
        , th [ class "pc225" ] [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language InfoHeaderStr ] ]
        , th [ class "pc25" ] [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language DurationStr ] ]
        , th [ class "pc5 has-text-centered" ]
            [ div [ class "select-heading invisible" ] [ text "." ]
            , button
                [ class "button is-small", onClick AddReel, disabled invalidQuantity ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-plus" ] []
                    ]
                ]
            ]
        ]


reelRow : SystemOfMeasurement -> Language -> Reel -> Html Msg
reelRow system language reel =
    let
        deleteRowButton reelID =
            button [ class "button is-small", onClick <| DeleteReel reelID ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-trash" ] []
                    ]
                ]

        footage =
            reelLengthInFeet reel
    in
    tr [ id (Uuid.toString reel.id) ]
        [ td [] [ text <| translate language <| audioConfigDisplayName reel.audioConfig ]
        , td [] [ text <| diameterDisplayName system reel.diameter ]
        , td [] [ text <| tapeThicknessDisplayName system reel.tapeThickness ]
        , td [] [ text <| speedDisplayName system reel.recordingSpeed ]
        , td [ class "has-text-centered" ]
            [ button
                [ class "button is-small margin-right-small", onClick (DecrementReelQuantity reel.id) ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-minus" ] []
                    ]
                ]
            , text <| String.fromInt reel.quantity
            , button
                [ class "button is-small margin-left-small", onClick (IncrementReelQuantity reel.id) ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-plus" ] []
                    ]
                ]
            ]
        , td []
            [ directionAndPassCount language reel.directionality reel.passes
            , lengthInfo system language footage
            ]
        , td [] (durationData language reel)
        , td [] [ deleteRowButton reel.id ]
        ]


directionAndPassCount : Language -> Direction -> Passes -> Html Msg
directionAndPassCount language direction passes =
    let
        passText =
            translate language (NumPassesStr passes)

        fullDirectionString =
            translate language (directionString direction)
    in
    div [] [ text (fullDirectionString ++ ": " ++ passText) ]


lengthInfo : SystemOfMeasurement -> Language -> Footage -> Html Msg
lengthInfo system language footage =
    let
        ft =
            footageToInt footage

        metricLength =
            toFloat ft * 0.3048

        lengthText =
            case system of
                Imperial ->
                    String.fromInt ft ++ " ft"

                Metric ->
                    String.fromFloat metricLength ++ " m"

        perReel =
            translate language (PerReelStr lengthText)
    in
    div [] [ text perReel ]


durationData : Language -> Reel -> List (Html Msg)
durationData language reel =
    [ div []
        [ text <|
            translate language (PerReelStr <| String.fromFloat (singleReelDuration reel) ++ " min")
        ]
    , div []
        [ text <|
            formatTime (fullDuration reel)
                ++ " "
                ++ translate language TotalStr
        ]
    ]


totalRow : Language -> List Reel -> FileType -> Html Msg
totalRow language reels fileType =
    let
        totalMins =
            overallDuration reels

        formattedTime =
            formatTime totalMins
    in
    tfoot []
        [ tr [ class "main-row" ]
            [ td [ class "has-text-weight-bold is-size-6" ] [ text <| translate language TotalStr ]
            , td [] []
            , td [] []
            , td [] []
            , td [] []
            , td [ class "duration-filesize" ]
                [ div [ class "total-top has-text-weight-bold" ] [ text <| translate language DurationStr ]
                , div []
                    [ span [ class "has-text-weight-bold" ] [ text <| translate language FileSizeStr ]
                    , div [ class "select is-small", id "filetype" ]
                        [ renderSelect
                            (fileTypeName fileType)
                            SetFileType
                            fileTypeName
                            allFileTypes
                        ]
                    ]
                ]
            , td []
                [ div [ class "total-top" ] [ text <| translate language (DurationSummaryStr totalMins formattedTime) ]
                , div [] [ text <| translate language (SizeInMegaBytesStr <| totalFilesize fileType reels) ]
                ]
            , td []
                [ button [ class "button is-small", onClick StartExport ]
                    [ span [ class "icon" ]
                        [ i [ class "fa fa-download" ] []
                        ]
                    ]
                ]
            ]
        ]
