module Main exposing (..)

import Html exposing (program)
import Model exposing (Model, init)
import Update exposing (Msg(..), update)
import View exposing (view)


main : Program Never Model Msg
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
