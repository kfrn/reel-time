module Links exposing (..)

import Html exposing (Html, a, i, span, text)
import Html.Attributes exposing (class, href)


linkData : LinkData -> String
linkData data =
    case data of
        IASAGuidelinesENData ->
            " (2nd ed.), IASA Technical Committee, 2009"

        IASAGuidelinesFRData ->
            " (2ème ed.), IASA Comité Technique, 2009, tr. 2015"

        IASAGuidelinesITData ->
            ", IASA Comitato Technico, 2004, tr. 2007"

        IASAMagLinkENData ->
            ", IASA Technical Committee, 2014"

        IASAMagLinkITData ->
            ", IASA Comitato Technico, 2014, tr. 2016"

        RangerData ->
            ", Joshua Ranger, AVPreserve, 12/2014"

        CaseyData ->
            " (PDF), Mike Casey, Indiana University, 2007"


type LinkData
    = IASAGuidelinesENData
    | IASAGuidelinesFRData
    | IASAGuidelinesITData
    | IASAMagLinkENData
    | IASAMagLinkITData
    | RangerData
    | CaseyData


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
            a [ href "http://www.dlib.indiana.edu/projects/sounddirections/facet/facet_formats.pdf" ] [ text "FACET: The Field Audio Collection Evaluation Tool. Format Characteristics and Preservation Problems" ]

        Ffmprovisr ->
            a [ href "https://amiaopensource.github.io/ffmprovisr/" ] [ text "ffmprovisr" ]

        IASAGuidelinesEN ->
            a [ href "https://www.iasa-web.org/tc04/audio-preservation" ] [ text "IASA TC-04: Guidelines on the Production and Preservation of Digital Audio Objects" ]

        IASAGuidelinesFR ->
            a [ href "https://www.iasa-web.org/tc04-fr/la-production-et-la-conservation-des-objets-audionumeriques" ] [ text "IASA TC-04: Recommandations pour la production et la conservation des objets audionumériques" ]

        IASAGuidelinesIT ->
            a [ href "http://www.aib.it/aib/editoria/2007/pub172.htm" ] [ text "IASA TC-04: Linee guida per la produzione e la preservazione di oggetti audio digitali" ]

        IASAMagLinkEN ->
            a [ href "https://www.iasa-web.org/tc05/2211-magnetic-tapes" ] [ text "Magnetic tapes, IASA TC-05: Handling and Storage of Audio and Video Carriers" ]

        IASAMagLinkIT ->
            a [ href "https://www.iasa-web.org/tc05-it/2211-nastri-magnetici" ] [ text "Nastri magnetici, IASA TC-05: Gestione e archiviazione dei supporti audio e video" ]

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
