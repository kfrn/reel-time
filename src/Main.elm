module Main exposing (..)

import Calculations exposing (..)
import Helpers exposing (..)
import Html exposing (Html, button, div, h1, i, img, input, option, p, select, span, text)
import Html.Attributes exposing (class, classList, disabled, id, name, placeholder, selected, src, value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Json
import Maybe.Extra exposing (isNothing)
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
    , reels : List Reel
    , selectorValues : SelectorValues
    , quantity : Maybe Int
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
    Model seed [] initialSelectorValues Nothing



---- UPDATE ----


type Msg
    = AddReel
    | DeleteRow Reel
    | ChangeAudioConfig String
    | ChangeDiameterInInches String
    | ChangeTapeThickness String
    | ChangeRecordingSpeed String
    | UpdateQuantity String
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
        , div [ class "column is-1 has-text-centered" ] [ text "quantity" ]
        , div [ class "column is-2 has-text-centered" ] [ text "info" ]
        , div [ class "column is-2 has-text-centered" ] [ text "length" ]
        , div [ class "column is-1 has-text-centered" ] [ text "add/del" ]
        ]


reelData : Footage -> Int -> Direction -> List (Html Msg)
reelData footage passes direction =
    let
        passesInfo =
            if passes == 1 then
                "1 pass"
            else
                toString passes ++ " passes"

        ft =
            footageToInt footage

        metricFootage =
            toFloat ft * 0.3048

        footageInfo =
            toString ft ++ "ft / " ++ toString metricFootage ++ "m per reel"
    in
    [ div [] [ text direction ]
    , div [] [ text passesInfo ]
    , div [] [ text footageInfo ]
    ]


durationData : DurationInMinutes -> Quantity -> Passes -> List (Html Msg)
durationData mins quantity passes =
    let
        reelTime =
            mins * toFloat passes

        totalTime =
            reelTime * toFloat quantity
    in
    [ div [] [ text (toString reelTime ++ " min per reel") ]
    , div [] [ text (formatTime totalTime ++ " total") ]
    ]


speedDisplayName : RecordingSpeed -> String
speedDisplayName speed =
    ipsDisplayName speed ++ " / " ++ ipsToCmps speed


reelOptionsRow : Reel -> Html Msg
reelOptionsRow reel =
    let
        deleteRowButton r =
            button [ class "button", onClick (DeleteRow r) ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-trash" ] []
                    ]
                ]

        ( direction, passes ) =
            reelInfo reel.audioConfig

        footage =
            reelLengthInFeet reel

        mins =
            durationInMinutes reel
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
            [ text (tapeThicknessDisplayName reel.tapeThickness) ]
        , div
            [ class "column has-text-centered" ]
            [ text (speedDisplayName reel.recordingSpeed) ]
        , div
            [ class "column is-1 has-text-centered" ]
            [ text (toString reel.quantity) ]
        , div
            [ class "column is-2 has-text-centered" ]
            (reelData footage passes direction)
        , div
            [ class "column is-2 has-text-centered" ]
            (durationData mins reel.quantity passes)
        , div
            [ class "column is-1 has-text-centered" ]
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

        sValues =
            model.selectorValues

        invalidQuantity =
            isNothing model.quantity
    in
    div [ class "columns" ]
        [ div [ class "column has-text-centered" ]
            [ select [ name "audio-config", class "select is-small", onChange ChangeAudioConfig ]
                (List.map
                    (createOption sValues.audioConfig audioConfigDisplayName)
                    allAudioConfigs
                )
            ]
        , div [ class "column has-text-centered" ]
            [ select
                [ name "diameter", class "select is-small", onChange ChangeDiameterInInches ]
                (List.map
                    (createOption sValues.diameter diameterDisplayName)
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
                    (createOption sValues.recordingSpeed speedDisplayName)
                    allRecordingSpeeds
                )
            ]
        , div [ class "column is-2 has-text-centered" ]
            [ input
                [ classList [ ( "input", True ), ( "is-danger", invalidQuantity ) ]
                , placeholder "Enter a number"
                , onInput UpdateQuantity
                ]
                []
            ]
        , div [ class "column is-1 has-text-centered" ]
            [ text "• • •" ]
        , div [ class "column is-2 has-text-centered" ]
            [ text "• • •" ]
        , div [ class "column is-1 has-text-centered" ]
            [ button
                [ class "button", onClick AddReel, disabled invalidQuantity ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-plus" ] []
                    ]
                ]
            ]
        ]
