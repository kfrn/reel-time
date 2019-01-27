module View.Helpers exposing (onChange, onKeyDown, renderSelect, wrapSectionInLevelDiv)

import Html exposing (Html, div, option, select, text)
import Html.Attributes exposing (class, selected)
import Html.Events exposing (keyCode, on)
import Json.Decode as Json
import List.Extra as ListX
import Messages


onChange : (String -> msg) -> Html.Attribute msg
onChange makeMessage =
    on "change" (Json.map makeMessage Html.Events.targetValue)


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


renderSelect : String -> (a -> Messages.Msg) -> (a -> String) -> List a -> Html Messages.Msg
renderSelect selectedOptionName message makeOptionName options =
    let
        isSelected opt =
            selectedOptionName == makeOptionName opt

        makeOptionTag opt =
            option
                [ selected <| isSelected opt ]
                [ text <| makeOptionName opt ]

        displayNameToMsg displayName =
            case ListX.find (\item -> makeOptionName item == displayName) options of
                Just opt ->
                    message opt

                Nothing ->
                    Messages.NoOp
    in
    select [ onChange displayNameToMsg ] (List.map makeOptionTag options)


wrapSectionInLevelDiv : Html msg -> Html msg
wrapSectionInLevelDiv section =
    div [ class "level" ] [ section ]
