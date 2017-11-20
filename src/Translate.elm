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
                AboutStr ->
                    { en = "About", fr = "À propos", it = "Informazioni" }

                AndOfCourseStr ->
                    { en = ", and of course the ", fr = " et bien sûr le ", it = " e naturalmente il " }

                AndStr ->
                    { en = " and ", fr = " et ", it = " e " }

                BidirectionalStr ->
                    { en = "bidirectional", fr = "bidirectionnel", it = "bidirezionale" }

                CalculateStr ->
                    { en = "calculate the length of your open-reel audio", fr = "calculer la durée de votre bobines", it = "calculare la durata delle vostre bobine aperte" }

                ContributeStr ->
                    { en = "Suggestions and contributions are welcome! You can open a pull request or submit an issue on github, or email me at kfnagels@gmail.com.", fr = "J'accueille les suggestions et les contributions! Vous pouvez ouvrir un «pull request» ou soumettre un «issue» sur github, ou m'envoyer un e-mail à kfnagels@gmail.com.", it = "Accolgo suggerimenti e contributi! Potete aprire un «pull request» o inviare un «issue» su github, o mi mandare una e-mail all'indirizzo kfnagels@gmail.com." }

                DevelopedByStr ->
                    { en = " is developed by Katherine Nagels. ", fr = " est créé par Katherine Nagels. ", it = " è stato creato da Katherine Nagels. " }

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

                InspiredByStr ->
                    { en = "It is inspired by open-source preservation tools like ", fr = "Il s'inspire de projets open-source comme ", it = "È ispirato a progetti open-source come " }

                OrStr ->
                    { en = "or", fr = "ou", it = "o" }

                PassesStr ->
                    -- "aller-retour" ??
                    { en = "passes", fr = "passes", it = "passe" }

                PerReelStr ->
                    { en = "per reel", fr = "par bobine", it = "per bobina" }

                QAndAStr ->
                    { en = "Questions & answers", fr = "Questions et réponses", it = "Domande e risposte" }

                QuantityStr ->
                    { en = "quantity", fr = "quantité", it = "quantità" }

                QuarterTrackMonoStr ->
                    { en = "quarter-track mono", fr = "mono quart de piste", it = "quattro piste mono" }

                QuarterTrackStereoStr ->
                    { en = "quarter-track stereo", fr = "stéréo quart de piste", it = "quattro piste stereo" }

                ReelDurationAStr ->
                    { en = "This tool assumes that the full duration of the reel is used.", fr = "En ce moment, cette calculatrice suppose l'utilisation complète de bobine.", it = "Questo calcolatore presuma un pieno utilizzo di bobina." }

                ReelDurationQStr ->
                    { en = "What if the recording doesn't fill the whole reel?", fr = "Et si l'enregistrement ne remplit pas toute la bobine?", it = "E se la registrazione non riempie l'intero rullo?" }

                ResponsiveStr ->
                    { en = "It looks like you're viewing this on a mobile device or small screen. Sorry, but this app isn't yet mobile-friendly. Please try it on a desktop!", fr = "Il paraît que vous utilisez un appareil disposant d'un écran de petite taille. Je suis desolée, mais ce site n'est pas encore mobile conviviale. Veuillez le essayer sur un ordinateur de bureau!", it = "Sembra che tu stia utilizzando un dispositivo con uno schermo piccolo. Mi dispiace, questo sito non è ancora mobile-friendly. Per favore lo provare su un desktop!" }

                SinglePassStr ->
                    { en = "1 pass", fr = "monopasse", it = "una passa" }

                SpeedStr ->
                    { en = "speed", fr = "vitesse", it = "velocità" }

                SpreadsheetStr ->
                    { en = " spreadsheet by ", fr = " tableur par ", it = " foglio da " }

                ThicknessStr ->
                    { en = "thickness", fr = "épaisseur", it = "spessore" }

                TotalStr ->
                    { en = "total", fr = "totale", it = "totale" }

                TypeStr ->
                    { en = "type", fr = "type", it = "tipo" }

                UnidirectionalStr ->
                    { en = "unidirectional", fr = "unidirectionnel", it = "unidirezionale" }

                UnknownVariablesAStr ->
                    { en = "If the original packaging is not present, it is possible to determine the tape thickness with a micrometre. A magnetic viewer will show you how many audio tracks are on the tape, though keep in mind the recording could be mono or stereo. As for the recording speed, this may have to be ascertained via playback, but it is possible to make an educated guess based on whether the recording is professional, amateur, etc. See the links below.", fr = "Si la boîte originale n'est pas présent, on peut utiliser un micromètre pour mesurer l'épaisseur de la bande. Une «visionneuse magnétique» montre combien de pistes sur la bande. Quant à la vitesse d'enregistrement, il faut peut-être passer la bobine, mais c'est possible faire une déduction logique suivant le genre d'enregistrement: professionel ou non, etc.", it = "Se la scatola originale è perduta, è possibile utilizzare un micrometro per misurare lo spessore del nastro. Un «visualizzatore magnetico» mostra quante tracce sul nastro. Per quanto riguarda la velocità di registrazione, potrebbe essere necessario suonare la bobina, ma è possibile fare una stima ragionata seconda del tipo di registrazione: professionale o meno, ecc." }

                UnknownVariablesQStr ->
                    { en = "Help! I don't know the width (or recording speed, etc) of my reel.", fr = "Au secours! Je ne sais pas l'épaisseur, ou la vitesse d'enregistrement (ou quelque chose d'autre) de ma bobine.", it = "Aiuto! Non conosco lo spessore (o la velocità di registrazione, ecc.) della mia bobina." }

                UsefulLinksStr ->
                    { en = "Useful Links", fr = "Liens utiles", it = "Link utili" }
    in
    case language of
        EN ->
            .en translationSet

        FR ->
            .fr translationSet

        IT ->
            .it translationSet


type AppString
    = AboutStr
    | AndOfCourseStr
    | AndStr
    | BidirectionalStr
    | CalculateStr
    | ContributeStr
    | DevelopedByStr
    | DiameterStr
    | DurationStr
    | FullTrackMonoStr
    | HalfTrackMonoStr
    | HalfTrackStereoStr
    | InfoHeaderStr
    | InspiredByStr
    | OrStr
    | PassesStr
    | PerReelStr
    | ResponsiveStr
    | QAndAStr
    | QuantityStr
    | QuarterTrackMonoStr
    | QuarterTrackStereoStr
    | ReelDurationAStr
    | ReelDurationQStr
    | SinglePassStr
    | SpeedStr
    | SpreadsheetStr
    | ThicknessStr
    | TotalStr
    | TypeStr
    | UnidirectionalStr
    | UnknownVariablesAStr
    | UnknownVariablesQStr
    | UsefulLinksStr
