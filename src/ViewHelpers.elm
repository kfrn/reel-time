module ViewHelpers exposing (..)

import Html exposing (Html, button, option, select, text)
import Html.Attributes exposing (classList, selected)
import Html.Events exposing (on)
import Json.Decode as Json
import List.Extra as ListX
import Update


onChange : (String -> msg) -> Html.Attribute msg
onChange makeMessage =
    on "change" (Json.map makeMessage Html.Events.targetValue)


renderSelect : String -> (a -> Update.Msg) -> (a -> String) -> List a -> Html Update.Msg
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
                    Update.NoOp
    in
    select [ onChange displayNameToMsg ] (List.map makeOptionTag options)
