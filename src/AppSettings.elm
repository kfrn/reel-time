module AppSettings exposing (..)


type PageView
    = Calculator
    | Info


type SystemOfMeasurement
    = Metric
    | Imperial


allSystemsOfMeasurement : List SystemOfMeasurement
allSystemsOfMeasurement =
    [ Metric, Imperial ]
