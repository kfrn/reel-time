module AppSettings exposing (PageView(..), SystemOfMeasurement(..), allSystemsOfMeasurement)


type PageView
    = Calculator
    | Info


type SystemOfMeasurement
    = Metric
    | Imperial


allSystemsOfMeasurement : List SystemOfMeasurement
allSystemsOfMeasurement =
    [ Metric, Imperial ]
