module Main exposing (..)

import Calculations exposing (..)
import Helpers exposing (..)
import Html exposing (Html, button, div, h1, h2, hr, i, img, input, option, p, select, span, text)
import Html.Attributes exposing (class, classList, disabled, id, name, placeholder, selected, src, value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Json
import Maybe.Extra exposing (isNothing)
import Random.Pcg exposing (Seed, initialSeed, step)
import Translate exposing (AppString(..), Language(..), allLanguages, translate)
import Types exposing (..)
import Uuid exposing (Uuid, uuidGenerator)


---- Main ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



---- Model----


type alias Model =
    { currentSeed : Seed
    , reels : List Reel
    , selectorValues : SelectorValues
    , quantity : Maybe Quantity
    , system : SystemOfMeasurement
    , language : Language
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    let
        ( uuid, seed ) =
            step Uuid.uuidGenerator (initialSeed 19580607)

        initialSelectorValues =
            { audioConfig = FullTrackMono
            , diameter = Seven
            , tapeThickness = Mil1p5
            , recordingSpeed = IPS_7p5
            }
    in
    Model seed [] initialSelectorValues Nothing Imperial EN



---- UPDATE ----


type Msg
    = AddReel
    | DeleteRow Reel
    | ChangeAudioConfig String
    | ChangeDiameterInInches String
    | ChangeTapeThickness String
    | ChangeRecordingSpeed String
    | UpdateQuantity String
    | ChangeSystemOfMeasurement SystemOfMeasurement
    | ChangeLanguage Language
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddReel ->
            case model.quantity of
                Just q ->
                    let
                        ( uuid, newSeed ) =
                            step Uuid.uuidGenerator model.currentSeed

                        newReels =
                            model.reels ++ [ newReel uuid model.selectorValues q ]

                        newModel =
                            { model | currentSeed = newSeed, reels = newReels }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        DeleteRow reel ->
            let
                newReels =
                    List.filter (\r -> r.id /= reel.id) model.reels

                newModel =
                    { model | reels = newReels }
            in
            ( newModel, Cmd.none )

        ChangeAudioConfig str ->
            case audioConfigFromString str of
                Just config ->
                    let
                        updateSValues sValues newConfig =
                            { sValues | audioConfig = newConfig }

                        newSelectorValues =
                            updateSValues model.selectorValues config

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeDiameterInInches str ->
            case diameterFromString str of
                Just diameter ->
                    let
                        updateSValues sValues newDiameterInInches =
                            { sValues | diameter = newDiameterInInches }

                        newSelectorValues =
                            updateSValues model.selectorValues diameter

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeTapeThickness str ->
            case tapeThicknessFromString str of
                Just thickness ->
                    let
                        updateSValues sValues newThickness =
                            { sValues | tapeThickness = newThickness }

                        newSelectorValues =
                            updateSValues model.selectorValues thickness

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeRecordingSpeed str ->
            case recordingSpeedFromString str of
                Just speed ->
                    let
                        updateSValues sValues newSpeed =
                            { sValues | recordingSpeed = newSpeed }

                        newSelectorValues =
                            updateSValues model.selectorValues speed

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        UpdateQuantity quantity ->
            case String.toInt quantity of
                Ok q ->
                    ( { model | quantity = Just q }, Cmd.none )

                Err e ->
                    ( { model | quantity = Nothing }, Cmd.none )

        ChangeSystemOfMeasurement system ->
            case system of
                Metric ->
                    ( { model | system = Metric }, Cmd.none )

                Imperial ->
                    ( { model | system = Imperial }, Cmd.none )

        ChangeLanguage l ->
            ( { model | language = l }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        total =
            if List.length model.reels > 0 then
                [ totalRow model ]
            else
                []
    in
    div [ id "container", class "box container" ]
        [ div [ id "content" ]
            ([ systemControls model.system
             , hr [] []
             , languageControls model.language
             , hr [] []
             , h1 [ class "title" ] [ text "reel-to-reel" ]
             , h2 [ class "subtitle" ] [ text <| translate model.language CalculateStr ]
             , hr [] []
             , headingRow model.language
             , div [] (List.map (reelRow model.system model.language) model.reels)
             , selectorRow model
             ]
                ++ total
            )
        , responsiveWarning model.language
        ]


responsiveWarning : Language -> Html Msg
responsiveWarning language =
    div [ class "responsive-warning-container whiteout" ]
        [ div [ class "responsive-warning" ]
            [ p [ class "is-size-2" ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-exclamation-triangle" ] []
                    ]
                ]
            , p [] [ text <| translate language ResponsiveStr ]
            ]
        ]


systemControls : SystemOfMeasurement -> Html Msg
systemControls system =
    let
        makeButton sys =
            button
                [ classList
                    [ ( "button", True )
                    , ( "is-primary", sys == system )
                    ]
                , onClick (ChangeSystemOfMeasurement sys)
                ]
                [ text (toString sys) ]
    in
    div [] (List.map makeButton allSystemsOfMeasurement)


languageControls : Language -> Html Msg
languageControls language =
    let
        makeButton l =
            button
                [ classList
                    [ ( "button", True )
                    , ( "is-primary", l == language )
                    ]
                , onClick (ChangeLanguage l)
                ]
                [ text (toString l) ]
    in
    div [] (List.map makeButton allLanguages)


headingRow : Language -> Html Msg
headingRow language =
    div [ class "columns has-text-centered" ]
        [ div [ class "column has-text-centered" ] [ text <| translate language TypeStr ]
        , div [ class "column has-text-centered" ] [ text <| translate language DiameterStr ]
        , div [ class "column has-text-centered" ] [ text <| translate language ThicknessStr ]
        , div [ class "column has-text-centered" ] [ text <| translate language SpeedStr ]
        , div [ class "column is-1 has-text-centered" ] [ text <| translate language QuantityStr ]
        , div [ class "column is-2 has-text-centered" ] [ text <| translate language InfoHeaderStr ]
        , div [ class "column is-2 has-text-centered" ] [ text <| translate language DurationStr ]
        , div [ class "column is-1 has-text-centered" ] []
        ]


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
                    toString ft ++ "ft"

                Metric ->
                    toString metricLength ++ "m"

        perReel =
            translate language PerReelStr
    in
    div [] [ text (lengthText ++ " " ++ perReel) ]


directionAndPassCount : Language -> Direction -> Passes -> Html Msg
directionAndPassCount language direction passes =
    let
        passText =
            if passes == 1 then
                translate language SinglePassStr
            else
                toString passes ++ " " ++ translate language PassesStr

        directionString =
            case direction of
                Unidirectional ->
                    UnidirectionalStr

                Bidirectional ->
                    BidirectionalStr
    in
    div [] [ text (translate language directionString ++ ": " ++ passText) ]


durationData : Language -> DurationInMinutes -> Quantity -> Passes -> List (Html Msg)
durationData language mins quantity passes =
    let
        reelTime =
            mins * toFloat passes

        totalTime =
            reelTime * toFloat quantity
    in
    [ div [] [ text (toString reelTime ++ " min " ++ translate language PerReelStr) ]
    , div [] [ text (formatTime totalTime ++ " " ++ translate language TotalStr) ]
    ]


reelRow : SystemOfMeasurement -> Language -> Reel -> Html Msg
reelRow system language reel =
    let
        deleteRowButton r =
            button [ class "button", onClick (DeleteRow r) ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-trash" ] []
                    ]
                ]

        footage =
            reelLengthInFeet reel

        mins =
            durationInMinutes reel
    in
    div
        [ id (Uuid.toString reel.id), class "columns has-text-centered" ]
        [ div
            [ class "column has-text-centered" ]
            [ text <| translate language <| audioConfigDisplayName reel.audioConfig ]
        , div
            [ class "column has-text-centered" ]
            [ text (diameterDisplayName system <| reel.diameter) ]
        , div
            [ class "column has-text-centered" ]
            [ text (tapeThicknessDisplayName reel.tapeThickness) ]
        , div
            [ class "column has-text-centered" ]
            [ text (speedDisplayName system <| reel.recordingSpeed) ]
        , div
            [ class "column is-1 has-text-centered" ]
            [ text (toString reel.quantity) ]
        , div
            [ class "column is-2 has-text-centered" ]
            [ directionAndPassCount language reel.directionality reel.passes
            , lengthInfo system language footage
            ]
        , div
            [ class "column is-2 has-text-centered" ]
            (durationData language mins reel.quantity reel.passes)
        , div
            [ class "column is-1 has-text-centered" ]
            [ deleteRowButton reel ]
        ]


onChange : (String -> msg) -> Html.Attribute msg
onChange makeMessage =
    on "change" (Json.map makeMessage Html.Events.targetValue)


diameterDisplayName : SystemOfMeasurement -> (DiameterInInches -> String)
diameterDisplayName system =
    case system of
        Imperial ->
            diameterImperialName

        Metric ->
            diameterMetricName


audioConfigDisplayName : AudioConfig -> AppString
audioConfigDisplayName audioConfig =
    case audioConfig of
        FullTrackMono ->
            FullTrackMonoStr

        HalfTrackStereo ->
            HalfTrackStereoStr

        HalfTrackMono ->
            HalfTrackMonoStr

        QuarterTrackStereo ->
            QuarterTrackStereoStr

        QuarterTrackMono ->
            QuarterTrackMonoStr


speedDisplayName : SystemOfMeasurement -> (RecordingSpeed -> String)
speedDisplayName system =
    case system of
        Imperial ->
            speedImperialName

        Metric ->
            speedMetricName


selectorRow : Model -> Html Msg
selectorRow model =
    let
        createOption selectorMatcher displayer opt =
            option [ value (toString opt), selected (opt == selectorMatcher) ] [ text (displayer opt) ]

        sValues =
            model.selectorValues

        invalidQuantity =
            isNothing model.quantity
    in
    div [ class "columns" ]
        [ div [ class "column has-text-centered" ]
            [ select [ name "audio-config", class "select is-small", onChange ChangeAudioConfig ]
                (List.map
                    (\config -> option [ value (toString config), selected (config == sValues.audioConfig) ] [ text <| translate model.language <| audioConfigDisplayName config ])
                    allAudioConfigs
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select
                [ name "diameter", class "select is-small", onChange ChangeDiameterInInches ]
                (List.map
                    (createOption sValues.diameter <| diameterDisplayName model.system)
                    allDiameters
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select [ name "tape-thickness", class "select is-small", onChange ChangeTapeThickness ]
                (List.map
                    (createOption sValues.tapeThickness tapeThicknessDisplayName)
                    allThicknesses
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select [ name "recording-speed", class "select is-small", onChange ChangeRecordingSpeed ]
                (List.map
                    (createOption sValues.recordingSpeed <| speedDisplayName model.system)
                    allRecordingSpeeds
                )
            ]
        , div [ class "column is-2 has-text-centered" ]
            [ input
                [ classList [ ( "input", True ), ( "is-danger", invalidQuantity ) ]
                , placeholder "#"
                , onInput UpdateQuantity
                ]
                []
            ]
        , div [ class "column is-1 has-text-centered" ] []
        , div [ class "column is-2 has-text-centered" ] []
        , div [ class "column is-1 has-text-centered" ]
            [ button
                [ class "button", onClick AddReel, disabled invalidQuantity ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-plus" ] []
                    ]
                ]
            ]
        ]


totalRow : Model -> Html Msg
totalRow model =
    let
        totalMins =
            totalLength model.reels
    in
    div [ class "columns" ]
        [ div [ class "column is-1 is-offset-8" ] [ text <| translate model.language TotalStr ]
        , div [ class "column is-2" ]
            [ div [] [ text (toString totalMins ++ " mins, " ++ translate model.language OrStr) ]
            , div [] [ text (formatTime totalMins) ]
            ]
        ]
