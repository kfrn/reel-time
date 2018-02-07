module View exposing (view)

import Calculations exposing (..)
import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, disabled, href, id, name, placeholder, selected, value)
import Html.Events exposing (onClick, onInput)
import Links exposing (LinkData(..), LinkName(..), link, linkData)
import Maybe.Extra exposing (isNothing)
import Model exposing (Model)
import Translate exposing (AppString(..), Language(..), allLanguages, infoPara, translate)
import Types exposing (..)
import Update exposing (Msg(..))
import Uuid exposing (Uuid, uuidGenerator)
import ViewHelpers exposing (onChange, renderSelect)


view : Model -> Html Msg
view model =
    div [ id "container" ]
        [ div [ id "content" ]
            [ navbar model.page model.system model.language
            , pageContent model
            , footer model.language
            ]
        , responsiveWarning model.language
        ]


responsiveWarning : Language -> Html Msg
responsiveWarning language =
    div [ class "responsive-warning-container whiteout has-text-centered" ]
        [ div [ class "responsive-warning" ]
            [ p [ class "is-size-2" ]
                [ span [ class "icon has-text-danger" ]
                    [ i [ class "fa fa-exclamation-triangle" ] []
                    ]
                ]
            , p [] [ text <| translate language ResponsiveStr ]
            ]
        ]


navbar : PageView -> SystemOfMeasurement -> Language -> Html Msg
navbar page system language =
    let
        measurementControls =
            case page of
                Calculator ->
                    [ systemControls language system ]

                _ ->
                    []
    in
    nav [ class "navbar", attribute "role" "navigation" ]
        [ div [ class "navbar-brand" ]
            [ div [ class "navbar-item" ]
                [ p [ class "title" ]
                    [ span [ class "icon" ] [ i [ class "fa fa-clock-o" ] [] ]
                    , text " reel time"
                    ]
                ]
            ]
        , div [ class "navbar-menu" ]
            [ div [ class "navbar-start" ]
                [ div [ class "navbar-item" ]
                    [ p [ class "is-size-6 calculate" ] [ em [] [ text <| translate language CalculateStr ] ]
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


footer : Language -> Html Msg
footer language =
    div [ class "level app-footer" ]
        [ div [ class "level-left left-offset" ] [ text <| translate language DevelopedByStr ]
        , div [ class "is-size-6 level-right right-offset" ] [ link Email, link SourceCode ]
        ]


systemControls : Language -> SystemOfMeasurement -> Html Msg
systemControls lang system =
    let
        nameStr s =
            case s of
                Metric ->
                    MetricStr

                Imperial ->
                    ImperialStr

        makeButton sys =
            button
                [ classList
                    [ ( "button is-small", True )
                    , ( "is-primary", sys == system )
                    ]
                , onClick (ChangeSystemOfMeasurement sys)
                ]
                [ text <| translate lang <| nameStr sys ]
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

        startNotice =
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
                    ++ startNotice
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
        , wrapSectionInLevelDiv
            (div []
                [ p [] [ strong [] [ text <| translate language WavQStr ] ]
                , p [] [ text <| translate language WavAStr ]
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


reelTable : Model -> Html Msg
reelTable model =
    let
        total =
            if List.length model.reels > 0 then
                [ totalRow model.language model.reels model.fileType ]
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
                    ChangeAudioConfig
                    (\a -> translate model.language <| audioConfigDisplayName a)
                    allAudioConfigs
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading is-size-6" ] [ text <| translate model.language DiameterStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (diameterDisplayName model.system model.selectorValues.diameter)
                    ChangeDiameterInInches
                    (diameterDisplayName model.system)
                    allDiameters
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language ThicknessStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (tapeThicknessDisplayName model.selectorValues.tapeThickness)
                    ChangeTapeThickness
                    tapeThicknessDisplayName
                    allThicknesses
                ]
            ]
        , th [ class "pc10" ]
            [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language SpeedStr ]
            , div [ class "select is-small" ]
                [ renderSelect
                    (speedDisplayName model.system model.selectorValues.recordingSpeed)
                    ChangeRecordingSpeed
                    (speedDisplayName model.system)
                    allRecordingSpeeds
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
        , th [ class "pc25" ] [ div [ class "select-heading left-offset is-size-6" ] [ text <| translate model.language InfoHeaderStr ] ]
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


totalRow : Language -> List Reel -> FileType -> Html Msg
totalRow language reels fileType =
    let
        totalMins =
            totalLength reels

        formattedTime =
            formatTime totalMins

        totalFilesize =
            List.sum <| List.map (filesize fileType) reels
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
                    , div [ class "select is-small" ]
                        [ select [ name "file-type", class "select is-small", onChange ChangeFileType ]
                            (List.map
                                (\ft ->
                                    option
                                        [ value (toString ft), selected (ft == fileType) ]
                                        [ text <| fileTypeName ft ]
                                )
                                allFileTypes
                            )
                        ]
                    ]
                ]
            , td []
                [ div [ class "total-top" ] [ text <| translate language (DurationSummaryStr totalMins formattedTime) ]
                , div [] [ text <| toString totalFilesize ++ " MB" ]
                ]
            , td [] []
            ]
        ]
