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
