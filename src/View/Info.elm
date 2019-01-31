module View.Info exposing (infoParagraph, linksSection, questionSection)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..))
import Html exposing (Html, div, h2, li, p, strong, text, ul)
import Html.Attributes exposing (class)
import Links exposing (LinkName(..), attributedLink)
import Messages exposing (Msg(..))
import Translate exposing (AppString(..), Language(..), infoPara, translate)
import View.Helpers exposing (wrapSectionInLevelDiv)


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
        listItem textContent =
            li [] textContent

        iasaLinks =
            case language of
                EN ->
                    [ listItem <| attributedLink IASAMagLinkEN, listItem <| attributedLink IASAGuidelinesEN ]

                FR ->
                    [ listItem <| attributedLink IASAGuidelinesFR ]

                IT ->
                    [ listItem <| attributedLink IASAMagLinkIT, listItem <| attributedLink IASAGuidelinesIT ]
    in
    div []
        [ h2 [ class "subtitle" ] [ text <| translate language UsefulLinksStr ]
        , ul []
            (iasaLinks
                ++ [ listItem <| attributedLink RichardHess
                   , listItem <| attributedLink Estimating
                   , listItem <| attributedLink Facet
                   ]
            )
        ]
