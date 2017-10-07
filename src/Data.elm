module Data exposing (..)

import Types exposing (..)


recordingTypes : List RecordingType
recordingTypes =
    [ { audioConfig = "full-track mono"
      , direction = "unidirectional"
      , passes = 1
      }
    , { audioConfig = "half-track stereo"
      , direction = "unidirectional"
      , passes = 1
      }
    , { audioConfig = "half-track mono"
      , direction = "bidirectional"
      , passes = 2
      }
    , { audioConfig = "quarter-track stereo"
      , direction = "bidirectional"
      , passes = 2
      }
    , { audioConfig = "quarter-track mono"
      , direction = "bidirectional"
      , passes = 4
      }
    ]


mil1p5 : String
mil1p5 =
    "1.5 mil"


mil1p0 : String
mil1p0 =
    "1.0 mil"


mil0p5d : String
mil0p5d =
    "0.5 mil double"


mil0p5t : String
mil0p5t =
    "0.5 mil triple"


tapeThicknesses : List String
tapeThicknesses =
    [ mil1p5, mil1p0, mil0p5d, mil0p5t ]


speedsInIPS : List String
speedsInIPS =
    [ "1.875", "3.75", "7.5", "15", "30" ]


baseData : List AudioReel
baseData =
    [ { diameterInches = 5
      , diameterMetric = 12.7
      , footage =
            [ { thickness = mil1p5, totalFootageFeet = 600, totalFootageMetric = 183.0 }
            , { thickness = mil1p0, totalFootageFeet = 900, totalFootageMetric = 274.5 }
            , { thickness = mil0p5d, totalFootageFeet = 1200, totalFootageMetric = 366.0 }
            , { thickness = mil0p5t
              , totalFootageFeet = 1800
              , totalFootageMetric = 548.5
              }
            ]
      }
    , { diameterInches = 7
      , diameterMetric = 17.8
      , footage =
            [ { thickness = mil1p5, totalFootageFeet = 1200, totalFootageMetric = 366.0 }
            , { thickness = mil1p0, totalFootageFeet = 1800, totalFootageMetric = 548.5 }
            , { thickness = mil0p5d, totalFootageFeet = 2400, totalFootageMetric = 731.5 }
            , { thickness = mil0p5t
              , totalFootageFeet = 3600
              , totalFootageMetric = 1097.5
              }
            ]
      }
    , { diameterInches = 10.5
      , diameterMetric = 26.7
      , footage =
            [ { thickness = mil1p5, totalFootageFeet = 2400, totalFootageMetric = 731.5 }
            , { thickness = mil1p0, totalFootageFeet = 3600, totalFootageMetric = 1097.5 }
            , { thickness = mil0p5d, totalFootageFeet = 4800, totalFootageMetric = 1463.0 }
            , { thickness = mil0p5t
              , totalFootageFeet = 7200
              , totalFootageMetric = 2194.5
              }
            ]
      }
    ]
