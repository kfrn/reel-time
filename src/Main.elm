module Main exposing (main)

import Browser
import Messages exposing (Msg(..))
import Model exposing (Model, init)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }
