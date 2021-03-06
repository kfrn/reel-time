module View.Main exposing (view)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..))
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class, id)
import Links exposing (LinkName(..), link)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Translate exposing (AppString(..), Language(..), translate)
import View.Helpers exposing (wrapSectionInLevelDiv)
import View.Info exposing (infoParagraph, linksSection, questionSection)
import View.Navbar exposing (navbar)
import View.ReelTable.Desktop exposing (desktopReelTable)
import View.ReelTable.Mobile exposing (mobileReelTable)


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
    Html.footer []
        [ span [ class "attribution" ] [ text <| translate language DevelopedByStr ]
        , span [] [ link Email, link SourceCode ]
        ]


pageContent : Model -> Html Msg
pageContent model =
    let
        infoPageSections =
            [ infoParagraph model.language, questionSection model.language, linksSection model.language ]
    in
    case model.page of
        Info ->
            div [ id "info" ]
                (List.map wrapSectionInLevelDiv infoPageSections)

        Calculator ->
            div [] [ mobileReelTable model, desktopReelTable model ]
