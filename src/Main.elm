module Main exposing (..)

import Calculations exposing (..)
import Helpers exposing (..)
import Html exposing (Html, button, div, h1, img, input, option, p, select, span, text)
import Html.Attributes exposing (class, id, name, placeholder, selected, src, value)
import Html.Events exposing (on, onClick)
import Json.Decode as Json
import Random.Pcg exposing (Seed, initialSeed, step)
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
    , reels : List ReelEntry
    , selectorValues : SelectorValues
    , testing : String
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
            , thickness = Mil1p5
            , recordingSpeed = IPS_7p5
            }
    in
    Model seed [] initialSelectorValues "nothing"



---- UPDATE ----


type Msg
    = AddNewRow
    | DeleteRow ReelEntry
    | ChangeAudioConfig String
    | ChangeDiameter String
    | ChangeTapeThickness String
    | ChangeRecordingSpeed String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddNewRow ->
            let
                ( uuid, newSeed ) =
                    step Uuid.uuidGenerator model.currentSeed

                newReels =
                    model.reels ++ [ newReel uuid model.selectorValues ]

                newModel =
                    { model | currentSeed = newSeed, reels = newReels }
            in
            ( newModel, Cmd.none )

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
                        update sValues newConfig =
                            { sValues | audioConfig = newConfig }

                        newSelectorValues =
                            update model.selectorValues config

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeDiameter str ->
            case diameterFromString str of
                Just diameter ->
                    let
                        update sValues newDiameter =
                            { sValues | diameter = newDiameter }

                        newSelectorValues =
                            update model.selectorValues diameter

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
                        update sValues newThickness =
                            { sValues | thickness = newThickness }

                        newSelectorValues =
                            update model.selectorValues thickness

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
                        update sValues newSpeed =
                            { sValues | recordingSpeed = newSpeed }

                        newSelectorValues =
                            update model.selectorValues speed

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ id "container", class "box container" ]
        [ h1 [ class "title" ] [ text "reel-to-reel" ]
        , headingRow
        , div [] (List.map reelOptionsRow model.reels)
        , selectorRow model
        ]


headingRow : Html Msg
headingRow =
    div [ class "columns has-text-centered" ]
        [ div [ class "column has-text-centered" ] [ text "type" ]
        , div [ class "column has-text-centered" ] [ text "diameter" ]
        , div [ class "column has-text-centered" ] [ text "thickness" ]
        , div [ class "column has-text-centered" ] [ text "speed" ]
        , div [ class "column has-text-centered" ] [ text "quantity" ]
        , div [ class "column has-text-centered" ] [ text "info" ]
        , div [ class "column has-text-centered" ] [ text "length" ]
        , div [ class "column has-text-centered" ] [ text "delete button" ]
        ]


reelData : ReelEntry -> LengthInFeet -> List (Html Msg)
reelData reel footage =
    let
        ( direction, passes ) =
            reelInfo reel.audioConfig

        passInfo =
            if passes == 1 then
                "1 pass"
            else
                toString passes ++ " passes"

        metricFootage =
            toFloat footage * 0.3048

        footageInfo =
            toString footage ++ "ft / " ++ toString metricFootage ++ "m per reel"
    in
    [ div [] [ text direction ]
    , div [] [ text passInfo ]
    , div [] [ text footageInfo ]
    ]


reelOptionsRow : ReelEntry -> Html Msg
reelOptionsRow reel =
    let
        deleteRowButton r =
            button [ class "button", onClick (DeleteRow r) ] [ text "delete" ]

        footage =
            reelLengthInFeet reel
    in
    div
        [ id (Uuid.toString reel.id), class "columns has-text-centered" ]
        [ div
            [ class "column has-text-centered" ]
            [ text (audioConfigDisplayName reel.audioConfig) ]
        , div
            [ class "column has-text-centered" ]
            [ text (diameterDisplayName reel.diameter) ]
        , div
            [ class "column has-text-centered" ]
            [ text (tapeThicknessDisplayName reel.thickness) ]
        , div
            [ class "column has-text-centered" ]
            [ text (speedDisplayName reel.recordingSpeed) ]
        , div
            [ class "column has-text-centered" ]
            [ text (toString reel.quantity) ]
        , div
            [ class "column has-text-centered" ]
            (reelData reel footage)
        , div
            [ class "column has-text-centered" ]
            [ text "X min per reel; Y min total" ]
        , div
            [ class "column has-text-centered" ]
            [ deleteRowButton reel ]
        ]


onChange : (String -> msg) -> Html.Attribute msg
onChange makeMessage =
    on "change" (Json.map makeMessage Html.Events.targetValue)


selectorRow : Model -> Html Msg
selectorRow model =
    let
        createOption selectorMatcher displayer opt =
            option [ value (toString opt), selected (opt == selectorMatcher) ] [ text (displayer opt) ]
    in
    div [ class "columns" ]
        [ div [ class "column has-text-centered" ]
            [ select [ name "audio-config", class "select is-small", onChange ChangeAudioConfig ]
                (List.map
                    (createOption model.selectorValues.audioConfig audioConfigDisplayName)
                    allAudioConfigs
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select
                [ name "diameter", class "select is-small", onChange ChangeDiameter ]
                (List.map
                    (createOption model.selectorValues.diameter diameterDisplayName)
                    allDiameters
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select [ name "tape-thickness", class "select is-small", onChange ChangeTapeThickness ]
                (List.map
                    (createOption model.selectorValues.thickness tapeThicknessDisplayName)
                    allThicknesses
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select [ name "recording-speed", class "select is-small", onChange ChangeRecordingSpeed ]
                (List.map
                    (createOption model.selectorValues.recordingSpeed speedDisplayName)
                    allRecordingSpeeds
                )
            ]
        , div [ class "column has-text-centered" ]
            [ text "quantity" ]
        , div [ class "column has-text-centered" ]
            [ text "• • •" ]
        , div [ class "column has-text-centered" ]
            [ text "• • •" ]
        , div [ class "column has-text-centered" ]
            [ button
                [ class "button", onClick AddNewRow ]
                [ text "Add" ]
            ]
        ]
