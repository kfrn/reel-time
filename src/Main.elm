module Main exposing (..)

import Data exposing (..)
import Html exposing (Html, button, div, h1, img, input, option, p, select, span, text)
import Html.Attributes exposing (class, name, placeholder, src, value)
import Types exposing (..)


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
    { reelTypes : List AudioReel
    , recordingTypes : List RecordingType
    , tapeThicknesses : List String
    , recordingSpeeds : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model baseData recordingTypes tapeThicknesses speedsInIPS, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "reel-to-reel" ]
        , div [] [ reelOptions model ]
        ]


reelOptions : Model -> Html Msg
reelOptions model =
    div [ class "reel-options" ]
        [ div [ class "recording-type select is-medium" ]
            [ select [ name "recording-type" ]
                ([ option [] [ text "type" ] ]
                    ++ List.map (\recordingType -> option [ value recordingType.audioConfig ] [ text recordingType.audioConfig ]) model.recordingTypes
                )
            ]
        , div [ class "reel-diameter select is-medium" ]
            [ select [ name "reel-diameter" ]
                ([ option [] [ text "diameter" ] ]
                    ++ List.map (\reelType -> option [ value (toString reelType.diameterInches ++ "in") ] [ text (toString reelType.diameterInches ++ "\" / " ++ toString reelType.diameterMetric ++ "cm") ]) model.reelTypes
                )
            ]
        , div [ class "thickness select is-medium" ]
            [ select [ name "thickness" ]
                ([ option [] [ text "thickness" ] ]
                    ++ List.map (\thickness -> option [ value thickness ] [ text thickness ]) model.tapeThicknesses
                )
            ]
        , div [ class "speed select is-medium" ]
            [ select [ name "speed" ]
                ([ option [] [ text "speed" ] ]
                    ++ List.map (\speed -> option [ value speed ] [ text (speed ++ " ips") ]) model.recordingSpeeds
                )
            ]
        , input [ class "quantity input is-medium", placeholder "quantity" ] []
        , button [ class "submit button is-medium" ] [ text "calculate!" ]
        , div [ class "result" ] [ text "..." ]
        ]

emojiSpan : String -> Html Msg
emojiSpan emoji = span [ class "emoji" ] [ text emoji ]
