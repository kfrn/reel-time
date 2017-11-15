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
                CalculateStr ->
                    { en = "calculate the length of your open-reel audio", fr = "calculer la durée de votre bobines", it = "calculare la durata delle vostre bobine aperte" }

                TypeStr ->
                    { en = "type", fr = "type", it = "tipo" }

                DiameterStr ->
                    { en = "diameter", fr = "diamètre", it = "diametro" }

                ThicknessStr ->
                    { en = "thickness", fr = "épaisseur", it = "spessore" }

                SpeedStr ->
                    { en = "speed", fr = "vitesse", it = "velocità" }

                QuantityStr ->
                    { en = "quantity", fr = "quantité", it = "quantità" }

                InfoHeaderStr ->
                    { en = "info", fr = "info", it = "info" }

                DurationStr ->
                    { en = "duration", fr = "durée", it = "durata" }

                PerReelStr ->
                    { en = "per reel", fr = "par bobine", it = "per bobina" }

                SinglePassStr ->
                    { en = "1 pass", fr = "monopasse", it = "una passa" }

                PassesStr ->
                    -- "aller-retour" ??
                    { en = "passes", fr = "passes", it = "passe" }

                UnidirectionalStr ->
                    { en = "unidirectional", fr = "unidirectionnel", it = "unidirezionale" }

                BidirectionalStr ->
                    { en = "bidirectional", fr = "bidirectionnel", it = "bidirezionale" }

                FullTrackMonoStr ->
                    { en = "full-track mono", fr = "mono pleine piste", it = "sola pista mono" }

                HalfTrackStereoStr ->
                    { en = "half-track stereo", fr = "stéréo demi piste", it = "due piste stereo" }

                HalfTrackMonoStr ->
                    { en = "half-track mono", fr = "mono demi piste", it = "due piste mono" }

                QuarterTrackStereoStr ->
                    { en = "quarter-track stereo", fr = "stéréo quart de piste", it = "quattro piste stereo" }

                QuarterTrackMonoStr ->
                    { en = "quarter-track mono", fr = "mono quart de piste", it = "quattro piste mono" }

                TotalStr ->
                    { en = "total", fr = "totale", it = "totale" }

                OrStr ->
                    { en = "or", fr = "ou", it = "o" }
    in
    case language of
        EN ->
            .en translationSet

        FR ->
            .fr translationSet

        IT ->
            .it translationSet


type AppString
    = CalculateStr
    | TypeStr
    | DiameterStr
    | ThicknessStr
    | SpeedStr
    | QuantityStr
    | InfoHeaderStr
    | DurationStr
    | PerReelStr
    | SinglePassStr
    | PassesStr
    | UnidirectionalStr
    | BidirectionalStr
    | FullTrackMonoStr
    | HalfTrackStereoStr
    | HalfTrackMonoStr
    | QuarterTrackStereoStr
    | QuarterTrackMonoStr
    | TotalStr
    | OrStr
