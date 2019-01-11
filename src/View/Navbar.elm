module View.Navbar exposing (navbar)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..), allSystemsOfMeasurement)
import Html exposing (Html, button, div, em, i, nav, p, span, text)
import Html.Attributes exposing (attribute, class, classList)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Translate exposing (AppString(..), Language(..), allLanguages, languageAbbreviation, translate)


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
                [ text <| languageAbbreviation l ]
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
