module View exposing (view)

import Calculations exposing (..)
import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, disabled, href, id, name, placeholder, selected, value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Json
import Links exposing (LinkData(..), LinkName(..), link, linkData)
import Maybe.Extra exposing (isNothing)
import Model exposing (Model)
import Translate exposing (AppString(..), Language(..), allLanguages, infoPara, translate)
import Types exposing (..)
import Update exposing (Msg(..))
import Uuid exposing (Uuid, uuidGenerator)


view : Model -> Html Msg
view model =
    div [ id "container" ]
        [ div [ id "content" ]
            [ navbar model.page model.system model.language
            , pageContent model
            , footer model.language
            ]

        -- , responsiveWarning model.language
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


footer : Language -> Html Msg
footer language =
    div [ class "level app-footer" ]
        [ div [ class "level-left left-offset" ] [ text <| translate language DevelopedByStr ]
        , div [ class "is-size-6 level-right right-offset" ] [ link Email, link SourceCode ]
        ]


navbar : PageView -> SystemOfMeasurement -> Language -> Html Msg
navbar page system language =
    let
        measurementControls =
            case page of
                Calculator ->
                    [ systemControls system ]

                _ ->
                    []
    in
    nav [ class "navbar", attribute "role" "navigation" ]
        [ div [ class "navbar-brand" ]
            [ div [ class "navbar-item" ]
                [ p [ class "title" ]
                    [ text "⏰ reel time"
                    ]
                ]
            ]
        , div [ class "navbar-menu" ]
            [ div [ class "navbar-start" ]
                [ div [ class "navbar-item" ]
                    [ p [ class "is-size-6" ] [ em [] [ text <| translate language CalculateStr ] ]
                    ]
                ]
            , div [ class "navbar-end" ]
                (measurementControls
                    ++ [ languageControls language
                       , navigationButton page
                       ]
                )
            ]
        ]


systemControls : SystemOfMeasurement -> Html Msg
systemControls system =
    let
        makeButton sys =
            button
                [ classList
                    [ ( "button is-small", True )
                    , ( "is-primary", sys == system )
                    ]
                , onClick (ChangeSystemOfMeasurement sys)
                ]
                [ text (toString sys) ]
    in
    div [ class "navbar-item" ] (List.map makeButton allSystemsOfMeasurement)


languageControls : Language -> Html Msg
languageControls language =
    let
        makeButton l =
            button
                [ classList
                    [ ( "button is-small", True )
                    , ( "is-primary", l == language )
                    ]
                , onClick (ChangeLanguage l)
                ]
                [ text (toString l) ]
    in
    div [ class "navbar-item" ] (List.map makeButton allLanguages)


navigationButton : PageView -> Html Msg
navigationButton page =
    let
        navButton iconName =
            div [ class "navbar-item" ]
                [ div [ class "button is-small", onClick (TogglePageView page) ] [ span [ class "icon" ] [ i [ class <| "fa " ++ iconName ] [] ] ]
                ]
    in
    case page of
        Calculator ->
            navButton "fa-info-circle"

        Info ->
            navButton "fa-calculator"


wrapSectionInLevelDiv : Html Msg -> Html Msg
wrapSectionInLevelDiv section =
    div [ class "level" ] [ section ]


pageContent : Model -> Html Msg
pageContent model =
    let
        infoPageSections =
            [ infoParagraph model.language, questionSection model.language, linksSection model.language ]

        addNotice =
            if List.isEmpty model.reels then
                [ div [ class "has-text-centered" ] [ text <| translate model.language CalcPromptStr ] ]
            else
                []
    in
    case model.page of
        Info ->
            div [ id "info" ]
                (List.map wrapSectionInLevelDiv infoPageSections)

        Calculator ->
            div []
                ([ reelTable model ]
                    ++ addNotice
                )


infoParagraph : Language -> Html Msg
infoParagraph language =
    div []
        [ h2 [ class "subtitle" ] [ text <| translate language AboutStr ]
        , p [] (infoPara language)
        , p [] [ text <| translate language ContributeStr ]
        ]


questionSection : Language -> Html Msg
questionSection language =
    div []
        [ h2 [ class "subtitle" ] [ text <| translate language QAndAStr ]
        , wrapSectionInLevelDiv
            (div []
                [ p [] [ strong [] [ text <| translate language UnknownVariablesQStr ] ]
                , p [] [ text <| translate language UnknownVariablesAStr ]
                ]
            )
        , wrapSectionInLevelDiv
            (div []
                [ p [] [ strong [] [ text <| translate language ReelDurationQStr ] ]
                , p [] [ text <| translate language ReelDurationAStr ]
                ]
            )
        ]


linksSection : Language -> Html Msg
linksSection language =
    let
        iasaTC04Link =
            case language of
                EN ->
                    [ li [] [ link IASAGuidelinesEN, text <| linkData IASAGuidelinesENData ] ]

                FR ->
                    [ li [] [ link IASAGuidelinesFR, text <| linkData IASAGuidelinesFRData ] ]

                IT ->
                    [ li [] [ link IASAGuidelinesIT, text <| linkData IASAGuidelinesITData ] ]

        iasaTC05Link =
            case language of
                EN ->
                    [ li [] [ link IASAMagLinkEN, text <| linkData IASAMagLinkENData ] ]

                FR ->
                    []

                IT ->
                    [ li [] [ link IASAMagLinkIT, text <| linkData IASAMagLinkITData ] ]
    in
    div []
        [ h2 [ class "subtitle" ] [ text <| translate language UsefulLinksStr ]
        , ul []
            (iasaTC05Link
                ++ iasaTC04Link
                ++ [ li [] [ link Estimating, text <| linkData RangerData ]
                   , li [] [ link Facet, text <| linkData CaseyData ]
                   ]
            )
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
            translate language (PerReelStr lengthText)
    in
    div [] [ text perReel ]


directionAndPassCount : Language -> Direction -> Passes -> Html Msg
directionAndPassCount language direction passes =
    let
        passText =
            if passes == 1 then
                translate language SinglePassStr
            else
                translate language (PassesStr passes)

        directionString =
            case direction of
                Unidirectional ->
                    UnidirectionalStr

                Bidirectional ->
                    BidirectionalStr

        fullDirectionString =
            translate language directionString
    in
    div [] [ text (fullDirectionString ++ ": " ++ passText) ]


durationData : Language -> DurationInMinutes -> Quantity -> Passes -> List (Html Msg)
durationData language mins quantity passes =
    let
        reelTime =
            mins * toFloat passes

        totalTime =
            reelTime * toFloat quantity
    in
    [ div [] [ text (translate language <| PerReelStr <| toString reelTime ++ "min") ]
    , div [] [ text (formatTime totalTime ++ " " ++ translate language TotalStr) ]
    ]


reelTable : Model -> Html Msg
reelTable model =
    let
        total =
            if List.length model.reels > 0 then
                [ totalRow model.language model.reels ]
            else
                []

        reelRows =
            List.map (reelRow model.system model.language) model.reels
    in
    table [ class "table is-fullwidth" ]
        ([ thead [] [ selectorRow model ]
         , tbody [] reelRows
         ]
            ++ total
        )


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
    tr [ class "table-header" ]
        [ th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language TypeStr ]
            , div [ class "select is-small" ]
                [ select [ name "audio-config", class "select is-small", onChange ChangeAudioConfig ]
                    (List.map
                        (\config -> option [ value (toString config), selected (config == sValues.audioConfig) ] [ text <| translate model.language <| audioConfigDisplayName config ])
                        allAudioConfigs
                    )
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language DiameterStr ]
            , div [ class "select is-small" ]
                [ select
                    [ name "diameter", class "select is-small", onChange ChangeDiameterInInches ]
                    (List.map
                        (createOption sValues.diameter <| diameterDisplayName model.system)
                        allDiameters
                    )
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language ThicknessStr ]
            , div [ class "select is-small" ]
                [ select [ name "tape-thickness", class "select is-small", onChange ChangeTapeThickness ]
                    (List.map
                        (createOption sValues.tapeThickness tapeThicknessDisplayName)
                        allThicknesses
                    )
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language SpeedStr ]
            , div [ class "select is-small" ]
                [ select [ name "recording-speed", class "select is-small", onChange ChangeRecordingSpeed ]
                    (List.map
                        (createOption sValues.recordingSpeed <| speedDisplayName model.system)
                        allRecordingSpeeds
                    )
                ]
            ]
        , th [ class "pc5 has-text-centered" ]
            [ div [ class "select-heading is-size-6" ] [ text <| translate model.language QuantityStr ]
            , input
                [ classList [ ( "input is-small", True ), ( "is-danger", invalidQuantity ) ]
                , id "quantity"
                , placeholder "#"
                , onInput UpdateQuantity
                ]
                []
            ]
        , th [ class "pc25" ] [ div [ class "select-heading is-size-6" ] [ text <| translate model.language InfoHeaderStr ] ]
        , th [ class "pc25" ] [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language DurationStr ] ]
        , th [ class "pc5" ]
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
        deleteRowButton r =
            button [ class "button is-small", onClick (DeleteRow r) ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-trash" ] []
                    ]
                ]

        footage =
            reelLengthInFeet reel

        mins =
            durationInMinutes reel
    in
    tr [ id (Uuid.toString reel.id) ]
        [ td [] [ text <| translate language <| audioConfigDisplayName reel.audioConfig ]
        , td [] [ text <| diameterDisplayName system reel.diameter ]
        , td [] [ text <| tapeThicknessDisplayName reel.tapeThickness ]
        , td [] [ text <| speedDisplayName system reel.recordingSpeed ]
        , td [ class "has-text-centered" ] [ text <| toString reel.quantity ]
        , td []
            [ directionAndPassCount language reel.directionality reel.passes
            , lengthInfo system language footage
            ]
        , td [] (durationData language mins reel.quantity reel.passes)
        , td [] [ deleteRowButton reel ]
        ]


totalRow : Language -> List Reel -> Html Msg
totalRow language reels =
    let
        totalMins =
            totalLength reels

        formattedTime =
            formatTime totalMins
    in
    tfoot []
        [ tr [ class "total-row" ]
            [ td [ class "has-text-weight-bold is-size-6" ] [ text <| translate language TotalStr ]
            , td [] []
            , td [] []
            , td [] []
            , td [] []
            , td [] []
            , td [] [ text <| translate language (DurationSummaryStr totalMins formattedTime) ]
            , td [] []
            ]
        ]
