module View.ReelTable.Mobile exposing (mobileReelTable)

import AppSettings exposing (SystemOfMeasurement(..))
import Audio.Model exposing (allAudioConfigs, allDiameters, allRecordingSpeeds, allThicknesses, diameterDisplayName, speedDisplayName, tapeThicknessDisplayName)
import Audio.Reel.Model exposing (Reel, footageToInt, formatTime, fullDuration, overallDuration, reelLengthInFeet, singleReelDuration)
import AudioFile exposing (FileType, allFileTypes, fileTypeName, totalFilesize)
import Html exposing (Html, button, div, h2, i, input, span, text)
import Html.Attributes exposing (class, classList, disabled, id, placeholder)
import Html.Events exposing (onClick, onInput)
import Maybe.Extra exposing (isNothing)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Translate exposing (AppString(..), Language, audioConfigDisplayName, directionString, translate)
import View.Helpers exposing (onKeyDown, renderSelect)


mobileReelTable : Model -> Html Msg
mobileReelTable model =
    let
        reelData =
            if List.isEmpty model.reels then
                []

            else
                [ div
                    [ id "reel-data" ]
                    (reelList
                        ++ [ totals model.language model.reels model.fileType ]
                    )
                ]

        reelList =
            [ div [ id "reel-list" ]
                (List.map
                    (addedReel model.language model.system)
                    model.reels
                )
            ]

        reelTable =
            div [] ([ addReel model ] ++ reelData)
    in
    div [ class "is-hidden-desktop", id "mobile-reel-table" ]
        ([ reelTable ] ++ startNotice model.reels model.language)


startNotice : List Reel -> Language -> List (Html Msg)
startNotice reels language =
    if List.isEmpty reels then
        [ div [ class "prompt has-text-centered" ] [ text <| translate language CalcPromptAboveStr ] ]

    else
        []


addReel : Model -> Html Msg
addReel model =
    let
        invalidQuantity =
            isNothing model.selectorValues.quantity || model.selectorValues.quantity == Just 0
    in
    div [ id "add-reel" ]
        [ div [ class "reel-option" ]
            [ reelLabel <| translate model.language TypeStr
            , div [ class "select" ]
                [ renderSelect
                    (translate model.language <| audioConfigDisplayName model.selectorValues.audioConfig)
                    ChangeAudioConfig
                    (\a -> translate model.language <| audioConfigDisplayName a)
                    allAudioConfigs
                ]
            ]
        , div [ class "reel-option" ]
            [ reelLabel <| translate model.language DiameterStr
            , div [ class "select" ]
                [ renderSelect
                    (diameterDisplayName model.system model.selectorValues.diameter)
                    ChangeDiameterInInches
                    (diameterDisplayName model.system)
                    allDiameters
                ]
            ]
        , div [ class "reel-option" ]
            [ reelLabel <| translate model.language ThicknessStr
            , div [ class "select" ]
                [ renderSelect
                    (tapeThicknessDisplayName model.selectorValues.tapeThickness)
                    ChangeTapeThickness
                    tapeThicknessDisplayName
                    allThicknesses
                ]
            ]
        , div [ class "reel-option" ]
            [ reelLabel <| translate model.language SpeedStr
            , div [ class "select" ]
                [ renderSelect
                    (speedDisplayName model.system model.selectorValues.recordingSpeed)
                    ChangeRecordingSpeed
                    (speedDisplayName model.system)
                    allRecordingSpeeds
                ]
            ]
        , div [ class "reel-option" ]
            [ reelLabel <| translate model.language QuantityStr
            , input
                [ classList [ ( "input", True ), ( "is-danger", invalidQuantity ) ]
                , id "quantity"
                , placeholder "#"
                , onInput UpdateQuantity
                , onKeyDown KeyDown
                ]
                []
            ]
        , button
            [ class "button is-primary", onClick AddReel, disabled invalidQuantity ]
            [ span [ id "add-reel-button-text", class "button-label" ] [ text <| translate model.language AddReelStr ]
            , span [ class "icon" ]
                [ i [ class "fa fa-plus" ] []
                ]
            ]
        ]


addedReel : Language -> SystemOfMeasurement -> Reel -> Html Msg
addedReel language system reel =
    let
        summary =
            String.concat <|
                (String.fromInt reel.quantity ++ "x ")
                    :: List.intersperse ", "
                        [ translate language <| audioConfigDisplayName reel.audioConfig
                        , diameterDisplayName system reel.diameter
                        , tapeThicknessDisplayName reel.tapeThickness
                        , speedDisplayName system reel.recordingSpeed
                        ]

        footage =
            footageToInt <| reelLengthInFeet reel

        ( length, unit ) =
            case system of
                Metric ->
                    ( toFloat footage * 0.3048, "m" )

                Imperial ->
                    ( toFloat footage, "ft" )

        lengthStr l u =
            String.fromFloat l ++ u
    in
    div [ class "added-reel" ]
        [ div [ class "summary" ] [ text summary ]
        , div []
            [ div []
                [ div [ class "reel-option" ]
                    [ span [] [ text <| translate language (directionString reel.directionality) ]
                    , span [] [ text <| translate language (NumPassesStr reel.passes) ]
                    ]
                , div [ class "reel-option" ]
                    [ span [] [ text <| translate language (PerReelStr <| lengthStr length unit) ]
                    , span []
                        [ text <| lengthStr (length * toFloat reel.quantity) unit ++ " " ++ translate language TotalStr ]
                    ]
                , div [ class "reel-option" ]
                    [ span [] [ text <| translate language (PerReelStr <| String.fromFloat (singleReelDuration reel) ++ "min") ]
                    , span [] [ text <| formatTime (fullDuration reel) ++ " " ++ translate language TotalStr ]
                    ]
                ]
            , button [ class "button is-dark", onClick <| DeleteReel reel.id ]
                [ span [ id "add-reel-button-text", class "button-label" ] [ text <| translate language RemoveReelStr ]
                , span [ class "icon" ]
                    [ i [ class "fa fa-trash" ] []
                    ]
                ]
            ]
        ]


totals : Language -> List Reel -> FileType -> Html Msg
totals language reels fileType =
    let
        totalMins =
            overallDuration reels

        formattedTime =
            formatTime totalMins
    in
    div [ id "totals" ]
        [ h2 [ class "subtitle" ] [ text <| translate language TotalStr ]
        , div [ class "reel-option" ]
            [ reelLabel <| translate language DurationStr
            , span [] [ text <| translate language (DurationSummaryStr totalMins formattedTime) ]
            ]
        , div [ class "reel-option" ]
            [ reelLabel <| translate language FileSizeStr
            , div [ class "select is-small", id "filetype" ]
                [ renderSelect
                    (fileTypeName fileType)
                    ChangeFileType
                    fileTypeName
                    allFileTypes
                ]
            , span [] [ text <| translate language (SizeInMegaBytesStr <| totalFilesize fileType reels) ]
            ]
        , button [ class "button is-primary", onClick StartExport ]
            [ span [ class "button-label" ] [ text <| translate language DownloadStr ]
            , span [ class "icon" ]
                [ i [ class "fa fa-download" ] []
                ]
            ]
        ]


reelLabel : String -> Html msg
reelLabel label =
    span [ class "reel-label" ] [ text label ]
