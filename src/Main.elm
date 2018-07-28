module Main exposing (..)

import Html exposing (program)
import Messages exposing (Msg(..))
import Model exposing (Model, init)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
