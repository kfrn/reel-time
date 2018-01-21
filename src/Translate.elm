module Translate exposing (..)

import Html exposing (Html, text)
import Links exposing (LinkName(..), link)
import Types exposing (DurationInMinutes)


type Language
    = EN
    | FR
    | IT


allLanguages : List Language
allLanguages =
    [ EN, FR, IT ]


type alias TranslationGroup =
    { en : String
    , fr : String
    , it : String
    }


type AppString
    = AboutStr
    | BidirectionalStr
    | CalcPromptStr
    | CalculateStr
    | ContributeStr
    | DevelopedByStr
    | DiameterStr
    | DurationStr
    | DurationSummaryStr DurationInMinutes String
    | FileSizeStr
    | FullTrackMonoStr
    | HalfTrackMonoStr
    | HalfTrackStereoStr
    | ImperialStr
    | InfoHeaderStr
    | MetricStr
    | MinutesStr DurationInMinutes
    | PassesStr Int
    | ResponsiveStr
    | PerReelStr String
    | QAndAStr
    | QuantityStr
    | QuarterTrackMonoStr
    | QuarterTrackStereoStr
    | ReelDurationAStr
    | ReelDurationQStr
    | SinglePassStr
    | SpeedStr
    | ThicknessStr
    | TotalStr
    | TypeStr
    | UnidirectionalStr
    | UnknownVariablesAStr
    | UnknownVariablesQStr
    | UsefulLinksStr
    | WavAStr
    | WavQStr


translate : Language -> AppString -> String
translate language appString =
    let
        translationSet =
            case appString of
                AboutStr ->
                    { en = "About"
                    , fr = "À propos"
                    , it = "Informazioni"
                    }

                BidirectionalStr ->
                    { en = "bidirectional"
                    , fr = "bidirectionnel"
                    , it = "bidirezionale"
                    }

                CalcPromptStr ->
                    { en = "Set the options above to calculate!"
                    , fr = "Définir les options ci-dessus!"
                    , it = "Impostare le opzioni sopra!"
                    }

                CalculateStr ->
                    { en = "calculate the duration of your open-reel audio"
                    , fr = "calculer la durée de vos bobines"
                    , it = "calcola la durata delle tue bobine aperte"
                    }

                ContributeStr ->
                    { en = "Suggestions and contributions are welcome! You can open a pull request or submit an issue on github, or email me; links in page footer."
                    , fr = "J'accueille les suggestions et les contributions! Vous pouvez ouvrir un «pull request» ou soumettre un «issue» sur github, ou m'envoyer un e-mail; liens au bas de page."
                    , it = "Accolgo suggerimenti e contributi! Potete aprire un «pull request» o inviare un «issue» su github, o mandarmi un e-mail; link a piè di pagina."
                    }

                DevelopedByStr ->
                    { en = "Web app by Katherine Nagels"
                    , fr = "Application web par Katherine Nagels"
                    , it = "Applicazione web di Katherine Nagels"
                    }

                DiameterStr ->
                    { en = "diameter"
                    , fr = "diamètre"
                    , it = "diametro"
                    }

                DurationStr ->
                    { en = "duration"
                    , fr = "durée"
                    , it = "durata"
                    }

                DurationSummaryStr totalMins formattedTime ->
                    { en = (translate language <| MinutesStr totalMins) ++ ", or " ++ formattedTime
                    , fr = (translate language <| MinutesStr totalMins) ++ ", ou " ++ formattedTime
                    , it = (translate language <| MinutesStr totalMins) ++ ", o " ++ formattedTime
                    }

                FileSizeStr ->
                    { en = "total size: "
                    , fr = "taille: "
                    , it = "dimensione: "
                    }

                FullTrackMonoStr ->
                    { en = "full-track mono"
                    , fr = "mono pleine piste"
                    , it = "sola pista mono"
                    }

                HalfTrackMonoStr ->
                    { en = "half-track mono"
                    , fr = "mono demi piste"
                    , it = "due piste mono"
                    }

                HalfTrackStereoStr ->
                    { en = "half-track stereo"
                    , fr = "stéréo demi piste"
                    , it = "due piste stereo"
                    }

                ImperialStr ->
                    { en = "imperial"
                    , fr = "impérial"
                    , it = "imperiale"
                    }

                InfoHeaderStr ->
                    { en = "info"
                    , fr = "info"
                    , it = "info"
                    }

                MetricStr ->
                    { en = "metric"
                    , fr = "métrique"
                    , it = "metrico"
                    }

                MinutesStr totalMins ->
                    { en = toString totalMins ++ " minutes"
                    , fr = toString totalMins ++ " minutes"
                    , it = toString totalMins ++ " minuti"
                    }

                PassesStr int ->
                    { en = toString int ++ " passes"
                    , fr = toString int ++ " passes" -- "aller-retour" ??
                    , it = toString int ++ " passe"
                    }

                PerReelStr str ->
                    { en = str ++ " per reel"
                    , fr = str ++ " par bobine"
                    , it = str ++ " per bobina"
                    }

                QAndAStr ->
                    { en = "Questions & answers"
                    , fr = "Questions et réponses"
                    , it = "Domande e risposte"
                    }

                QuantityStr ->
                    { en = "quantity"
                    , fr = "quantité"
                    , it = "quantità"
                    }

                QuarterTrackMonoStr ->
                    { en = "quarter-track mono"
                    , fr = "mono quart de piste"
                    , it = "quattro piste mono"
                    }

                QuarterTrackStereoStr ->
                    { en = "quarter-track stereo"
                    , fr = "stéréo quart de piste"
                    , it = "quattro piste stereo"
                    }

                ReelDurationAStr ->
                    { en = "This tool assumes that the full duration of the reel is used."
                    , fr = "Cette calculatrice suppose l'utilisation complète de la bobine."
                    , it = "Questo calcolatore presume l'uso completo della bobina."
                    }

                ReelDurationQStr ->
                    { en = "What if the recording doesn't fill the whole reel?"
                    , fr = "Et si l'enregistrement ne remplit pas toute la bobine?"
                    , it = "E se la registrazione non riempie l'intero rullo?"
                    }

                ResponsiveStr ->
                    { en = "It looks like you're viewing this on a mobile device or small screen. Sorry, but this app isn't yet mobile-friendly. Please try it on a desktop!"
                    , fr = "Il paraît que vous utilisez un appareil disposant d'un écran de petite taille. Je suis desolée, mais ce site n'est pas encore mobile conviviale. Veuillez l'essayer sur un ordinateur de bureau!"
                    , it = "Sembra che tu stia utilizzando un dispositivo con uno schermo piccolo. Mi dispiace, questo sito non è ancora mobile-friendly. Prova per favore su un desktop!"
                    }

                SinglePassStr ->
                    { en = "1 pass"
                    , fr = "1 passe"
                    , it = "1 passa"
                    }

                SpeedStr ->
                    { en = "speed"
                    , fr = "vitesse"
                    , it = "velocità"
                    }

                ThicknessStr ->
                    { en = "thickness"
                    , fr = "épaisseur"
                    , it = "spessore"
                    }

                TotalStr ->
                    { en = "total"
                    , fr = "total"
                    , it = "totale"
                    }

                TypeStr ->
                    { en = "type"
                    , fr = "type"
                    , it = "tipo"
                    }

                UnidirectionalStr ->
                    { en = "unidirectional"
                    , fr = "unidirectionnel"
                    , it = "unidirezionale"
                    }

                UnknownVariablesAStr ->
                    { en = "If the original packaging is not present, it is possible to determine the tape thickness with a micrometre. A magnetic viewer will show you how many audio tracks are on the tape, though keep in mind the recording could be mono or stereo. As for the recording speed, this may have to be ascertained via playback, but it is possible to make an educated guess based on whether the recording is professional, amateur, etc. See the links below."
                    , fr = "Si la boîte originale n'est pas présente, on peut utiliser un micromètre pour mesurer l'épaisseur de la bande. Une «visionneuse magnétique» montre combien de pistes il y a sur la bande. Quant à la vitesse d'enregistrement, il faut peut-être passer la bobine, mais c'est possible d'effectuer une déduction logique suivant le genre d'enregistrement: professionel ou non, etc."
                    , it = "Se la scatola originale è perduta, è possibile utilizzare un micrometro per misurare lo spessore del nastro. Un «visualizzatore magnetico» mostra quante tracce ci sono sul nastro. Per quanto riguarda la velocità di registrazione, potrebbe essere necessario ascoltare la bobina, ma è possibile fare una buona stima secondo il tipo di registrazione: professionale o meno, ecc."
                    }

                UnknownVariablesQStr ->
                    { en = "Help! I don't know the thickness (or recording speed, etc) of my reel."
                    , fr = "Au secours! Je ne sais pas l'épaisseur (ou la vitesse d'enregistrement, etc.) de ma bobine."
                    , it = "Aiuto! Non conosco lo spessore (o la velocità di registrazione, ecc.) della mia bobina."
                    }

                UsefulLinksStr ->
                    { en = "Useful Links"
                    , fr = "Liens utiles"
                    , it = "Link utili"
                    }

                WavAStr ->
                    { en = "When digitising analogue audio, the commonly accepted preservation format is linear pulse code modulation (LPCM) encoding inside a WAVE (.WAV) wrapper. The International Association of Sound and Audiovisual Archives (IASA) recommends a bit-depth of 24 and sample rate of 96kHz, but other options are also widely used, such as 24-bit/48kHz and 16-bit/48kHz."
                    , fr = "Quand on numérise l'audio analogique, le format de conservation bien accepté est l'encodage LPCM (Linear Pulse Code Modulation) à l'intérieur du format conteneur WAVE (.WAV). L'Association Internationale des Archives Sonores et Audiovisuelles (IASA) recommande une profondeur de 24 bit et une cadence d'échantillonnage de 96 kHz, mais d'autres options sont communément utilisées, par exemple 24 bit/48 kHz ou 16 bit/48 kHz."
                    , it = "Durante la digitalizzazione dell'audio analogico, il formato di conservazione abitualmente accettato è la codifica LPCM (linear pulse code modulation) all'interno dal formato contenitore WAVE (.WAV). L'Associazione Internazionale degli Archivi Sonori e Audiovisivi (IASA) consiglia una profondità di 24 bit e una frequenza di campionamento di 96 kHz, ma anche altre opzioni sono spesso utilizzate, come 24 bit/48 kHz oppure 16 bit/48 kHz."
                    }

                WavQStr ->
                    { en = "24/96 WAV, 24/48 WAV, 16/48 WAV: what are these?"
                    , fr = "Que signifient 24/96 WAV, 24/48 WAV et 16/48 WAV?"
                    , it = "Cosa significano 24/96 WAV, 24/48 WAV e 16/48 WAV?"
                    }
    in
    case language of
        EN ->
            .en translationSet

        FR ->
            .fr translationSet

        IT ->
            .it translationSet


infoPara : Language -> List (Html msg)
infoPara language =
    let
        translationSet =
            { en =
                [ text "Reel Time is inspired by open-source preservation tools like "
                , link Ffmprovisr
                , text ", "
                , link CableBible
                , text ", "
                , link SourceCaster
                , text ", and of course the "
                , link ORADCalc
                , text " spreadsheet by Joshua Ranger of AVPreserve."
                ]
            , fr =
                [ text "Reel Time s'inspire de projets open-source comme "
                , link Ffmprovisr
                , text ", "
                , link CableBible
                , text ", "
                , link SourceCaster
                , text " et, bien sûr, l'"
                , link ORADCalc
                , text " tableur par Joshua Ranger d'AVPreserve."
                ]
            , it =
                [ text "Reel Time è ispirato a progetti open-source come "
                , link Ffmprovisr
                , text ", "
                , link CableBible
                , text ", "
                , link SourceCaster
                , text " e naturalmente l'"
                , link ORADCalc
                , text " foglio elettronico di Joshua Ranger di AVPreserve."
                ]
            }
    in
    case language of
        EN ->
            .en translationSet

        FR ->
            .fr translationSet

        IT ->
            .it translationSet
