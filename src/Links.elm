module Links exposing (LinkName(..), attributedLink, link)

import Html exposing (Html, a, i, span, text)
import Html.Attributes exposing (class, href)


attributedLink : LinkName -> List (Html msg)
attributedLink linkName =
    case linkName of
        Estimating ->
            [ link Estimating, text ", Joshua Ranger, AVPreserve, 12/2014" ]

        Facet ->
            [ link Facet, text " (PDF), Mike Casey, Indiana University, 2007" ]

        HessReel ->
            [ link HessReel, text ", Richard Hess, 03/2006" ]

        HessTimingChart ->
            [ link HessTimingChart, text ", Richard Hess, 03/2006" ]

        IASAGuidelinesEN ->
            [ link IASAGuidelinesEN, text " (2nd ed.), IASA Technical Committee, 2009" ]

        IASAGuidelinesFR ->
            [ link IASAGuidelinesFR, text " (2ème ed.), IASA Comité Technique, 2009, tr. 2015" ]

        IASAGuidelinesIT ->
            [ link IASAGuidelinesIT, text ", IASA Comitato Technico, 2004, tr. 2007" ]

        IASAMagLinkEN ->
            [ link IASAMagLinkEN, text ", IASA Technical Committee, 2014" ]

        IASAMagLinkIT ->
            [ link IASAMagLinkIT, text ", IASA Comitato Technico, 2014, tr. 2016" ]

        _ ->
            []


link : LinkName -> Html msg
link name =
    case name of
        CableBible ->
            a [ href "https://amiaopensource.github.io/cable-bible/" ] [ text "Cable Bible" ]

        Email ->
            a [ href "mailto:kfnagels@gmail.com" ]
                [ span [ class "icon is-medium" ]
                    [ i [ class "fa fa-envelope" ] []
                    ]
                ]

        Estimating ->
            a [ href "https://www.avpreserve.com/estimating-duration-of-open-reel-audio/" ] [ text "Estimating the duration of open-reel audio" ]

        Facet ->
            a [ href "https://dlib.indiana.edu/projects/sounddirections/facet/facet_formats.pdf" ] [ text "FACET: The Field Audio Collection Evaluation Tool. Format Characteristics and Preservation Problems" ]

        Ffmprovisr ->
            a [ href "https://amiaopensource.github.io/ffmprovisr/" ] [ text "ffmprovisr" ]

        HessReel ->
            a [ href "https://richardhess.com/notes/formats/magnetic-media/magnetic-tapes/analog-audio/025-reel-tape" ] [ text "0.25\" reel tape" ]

        HessTimingChart ->
            a [ href "https://richardhess.com/notes/formats/magnetic-media/magnetic-tapes/analog-audio/tape-timing-chart/" ] [ text "Tape Timing Chart" ]

        IASAGuidelinesEN ->
            a [ href "https://www.iasa-web.org/tc04/audio-preservation" ] [ text "IASA TC-04: Guidelines on the Production and Preservation of Digital Audio Objects" ]

        IASAGuidelinesFR ->
            a [ href "https://www.iasa-web.org/tc04-fr/la-production-et-la-conservation-des-objets-audionumeriques" ] [ text "IASA TC-04: Recommandations pour la production et la conservation des objets audionumériques" ]

        IASAGuidelinesIT ->
            a [ href "https://www.aib.it/aib/editoria/2007/pub172.htm" ] [ text "IASA TC-04: Linee guida per la produzione e la preservazione di oggetti audio digitali" ]

        IASAMagLinkEN ->
            a [ href "https://www.iasa-web.org/tc05/2211-magnetic-tapes" ] [ text "IASA TC-05: Handling and Storage of Audio and Video Carriers - Magnetic tapes" ]

        IASAMagLinkIT ->
            a [ href "https://www.iasa-web.org/tc05-it/2211-nastri-magnetici" ] [ text "IASA TC-05: Gestione e archiviazione dei supporti audio e video - Nastri magnetici" ]

        ORADCalc ->
            a [ href "https://www.avpreserve.com/open-reel-audio-duration-calculator/" ] [ text "Open Reel Audio Duration Calculator" ]

        SourceCaster ->
            a [ href "https://datapraxis.github.io/sourcecaster/" ] [ text "SourceCaster" ]

        SourceCode ->
            a [ href "https://github.com/kfrn/reel-time" ]
                [ span [ class "icon" ]
                    [ i [ class "fa fa-github" ] []
                    ]
                ]


type LinkName
    = CableBible
    | Email
    | Estimating
    | HessReel
    | HessTimingChart
    | Facet
    | Ffmprovisr
    | IASAGuidelinesEN
    | IASAGuidelinesFR
    | IASAGuidelinesIT
    | IASAMagLinkEN
    | IASAMagLinkIT
    | ORADCalc
    | SourceCaster
    | SourceCode
