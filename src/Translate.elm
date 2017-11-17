module Translate exposing (..)


type Language
    = EN
    | FR
    | IT


allLanguages : List Language
allLanguages =
    [ EN, FR, IT ]


type alias TranslationSet =
    { en : String
    , fr : String
    , it : String
    }


translate : Language -> AppString -> String
translate language appString =
    let
        translationSet =
            case appString of
                BidirectionalStr ->
                    { en = "bidirectional", fr = "bidirectionnel", it = "bidirezionale" }

                CalculateStr ->
                    { en = "calculate the length of your open-reel audio", fr = "calculer la durée de votre bobines", it = "calculare la durata delle vostre bobine aperte" }

                DiameterStr ->
                    { en = "diameter", fr = "diamètre", it = "diametro" }

                DurationStr ->
                    { en = "duration", fr = "durée", it = "durata" }

                FullTrackMonoStr ->
                    { en = "full-track mono", fr = "mono pleine piste", it = "sola pista mono" }

                HalfTrackMonoStr ->
                    { en = "half-track mono", fr = "mono demi piste", it = "due piste mono" }

                HalfTrackStereoStr ->
                    { en = "half-track stereo", fr = "stéréo demi piste", it = "due piste stereo" }

                InfoHeaderStr ->
                    { en = "info", fr = "info", it = "info" }

                OrStr ->
                    { en = "or", fr = "ou", it = "o" }

                PassesStr ->
                    -- "aller-retour" ??
                    { en = "passes", fr = "passes", it = "passe" }

                PerReelStr ->
                    { en = "per reel", fr = "par bobine", it = "per bobina" }

                QuantityStr ->
                    { en = "quantity", fr = "quantité", it = "quantità" }

                QuarterTrackMonoStr ->
                    { en = "quarter-track mono", fr = "mono quart de piste", it = "quattro piste mono" }

                QuarterTrackStereoStr ->
                    { en = "quarter-track stereo", fr = "stéréo quart de piste", it = "quattro piste stereo" }

                ResponsiveStr ->
                    { en = "It looks like you're viewing this on a mobile device or small screen. Sorry, but this app isn't yet mobile-friendly. Please try it on a desktop!", fr = "Il paraît que vous utilisez un  appareil disposant d'un écran de petite taille. Je suis desolée, mais ce site n'est pas encore mobile conviviale. Veuillez le essayer sur un ordinateur de bureau!", it = "Sembra che tu stia utilizzando un dispositivo con uno schermo piccolo. Mi dispiace, questo sito non è ancora mobile-friendly. Per favore lo provare su un desktop!" }

                SinglePassStr ->
                    { en = "1 pass", fr = "monopasse", it = "una passa" }

                SpeedStr ->
                    { en = "speed", fr = "vitesse", it = "velocità" }

                ThicknessStr ->
                    { en = "thickness", fr = "épaisseur", it = "spessore" }

                TotalStr ->
                    { en = "total", fr = "totale", it = "totale" }

                TypeStr ->
                    { en = "type", fr = "type", it = "tipo" }

                UnidirectionalStr ->
                    { en = "unidirectional", fr = "unidirectionnel", it = "unidirezionale" }
    in
    case language of
        EN ->
            .en translationSet

        FR ->
            .fr translationSet

        IT ->
            .it translationSet


type AppString
    = BidirectionalStr
    | CalculateStr
    | DiameterStr
    | DurationStr
    | FullTrackMonoStr
    | HalfTrackMonoStr
    | HalfTrackStereoStr
    | InfoHeaderStr
    | OrStr
    | PassesStr
    | PerReelStr
    | ResponsiveStr
    | QuantityStr
    | QuarterTrackMonoStr
    | QuarterTrackStereoStr
    | SinglePassStr
    | SpeedStr
    | ThicknessStr
    | TotalStr
    | TypeStr
    | UnidirectionalStr
