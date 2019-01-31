module View.Info exposing (infoParagraph, linksSection, questionSection)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..))
import Html exposing (Html, div, h2, li, p, strong, text, ul)
import Html.Attributes exposing (class)
import Links exposing (LinkData(..), LinkName(..), link, linkData)
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
            ([ li [] [ link RichardHess, text <| linkData RichardHessData ] ]
                ++ iasaTC05Link
                ++ iasaTC04Link
                ++ [ li [] [ link Estimating, text <| linkData RangerData ]
                   , li [] [ link Facet, text <| linkData CaseyData ]
                   ]
            )
        ]
