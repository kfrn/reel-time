module View.Main exposing (view)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..))
import Html exposing (Html, div, i, p, span, text)
import Html.Attributes exposing (class, id)
import Links exposing (LinkData(..), LinkName(..), link)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Translate exposing (AppString(..), Language(..), translate)
import View.Helpers exposing (wrapSectionInLevelDiv)
import View.Info exposing (infoParagraph, linksSection, questionSection)
import View.Navbar exposing (navbar)
import View.ReelTable exposing (reelTable)


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


footer : Language -> Html Msg
footer language =
    div [ class "level app-footer" ]
        [ div [ class "level-left left-offset" ] [ text <| translate language DevelopedByStr ]
        , div [ class "is-size-6 level-right right-offset" ] [ link Email, link SourceCode ]
        ]


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
                (reelTable model
                    :: startNotice
                )
