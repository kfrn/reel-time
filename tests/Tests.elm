module Tests exposing (all)

import Audio.Model exposing (AudioConfig(..), DiameterInInches(..), RecordingSpeed(..), SelectorValues, TapeThickness(..))
import Audio.Reel.Model exposing (Footage(..), newReel, reelLengthInFeet, singleReelDuration)
import AudioFile exposing (FileType(..), filesize)
import Expect
import Random.Pcg exposing (initialSeed, step)
import Test exposing (..)
import Uuid exposing (Uuid, uuidGenerator)


all : Test
all =
    describe "reel duration & file size calculation" <|
        [ describe "full-track mono, 5\" 0.5mil triple @ 3.75 IPS" <|
            let
                reel =
                    newReel fakeUUID (SelectorValues FullTrackMono Five Mil0p5Triple IPS_3p75 (Just 1)) 1
            in
            [ test "should be 1 pass" <|
                \_ ->
                    Expect.equal reel.passes 1
            , test "reel footage should be 1800ft" <|
                let
                    footage =
                        reelLengthInFeet reel
                in
                \_ -> Expect.equal footage Ft1800
            , test "duration should be 90 minutes" <|
                let
                    duration =
                        singleReelDuration reel
                in
                \_ -> Expect.equal duration 90
            , test "should be 1518.75 MB in size for a 24/96 WAV" <|
                let
                    size =
                        filesize WAV_24_96 reel
                in
                \_ -> Expect.equal size 1518.75
            ]
        , describe "half-track stereo, 10.5\" 0.5mil double @ 7.5 IPS" <|
            let
                reel =
                    newReel fakeUUID (SelectorValues HalfTrackStereo TenPtFive Mil0p5Double IPS_7p5 (Just 1)) 1
            in
            [ test "should be 1 pass" <|
                \_ ->
                    Expect.equal reel.passes 1
            , test "reel footage should be 4800ft" <|
                let
                    footage =
                        reelLengthInFeet reel
                in
                \_ -> Expect.equal footage Ft4800
            , test "duration should be 120 minutes" <|
                let
                    duration =
                        singleReelDuration reel
                in
                \_ -> Expect.equal duration 120
            , test "should be 4050 MB in size for a 24/96 WAV" <|
                let
                    size =
                        filesize WAV_24_96 reel
                in
                \_ -> Expect.equal size 4050
            ]
        , describe "half-track mono, 7\" 1.5mil @ 1.875 IPS" <|
            let
                reel =
                    newReel fakeUUID (SelectorValues HalfTrackMono Seven Mil1p5 IPS_1p875 (Just 1)) 1
            in
            [ test "should be 2 passes" <|
                \_ ->
                    Expect.equal reel.passes 2
            , test "reel footage should be 1200ft" <|
                let
                    footage =
                        reelLengthInFeet reel
                in
                \_ -> Expect.equal footage Ft1200
            , test "duration should be 240 minutes" <|
                let
                    duration =
                        singleReelDuration reel
                in
                \_ -> Expect.equal duration 240
            , test "should be 4050 MB in size for a 24/96 WAV" <|
                let
                    size =
                        filesize WAV_24_96 reel
                in
                \_ -> Expect.equal size 4050
            ]
        , describe "quarter-track stereo, 10.5\" 0.5mil triple @ 30 IPS" <|
            let
                reel =
                    newReel fakeUUID (SelectorValues QuarterTrackStereo TenPtFive Mil0p5Triple IPS_30 (Just 1)) 1
            in
            [ test "should be 2 passes" <|
                \_ ->
                    Expect.equal reel.passes 2
            , test "reel footage should be 7200ft" <|
                let
                    footage =
                        reelLengthInFeet reel
                in
                \_ -> Expect.equal footage Ft7200
            , test "duration should be 90 minutes" <|
                let
                    duration =
                        singleReelDuration reel
                in
                \_ -> Expect.equal duration 90
            , test "should be 3037.5 MB in size for a 24/96 WAV" <|
                let
                    size =
                        filesize WAV_24_96 reel
                in
                \_ -> Expect.equal size 3037.5
            ]
        , describe "quarter-track mono, 7\" 1.0mil @ 15 IPS" <|
            let
                reel =
                    newReel fakeUUID (SelectorValues QuarterTrackMono Seven Mil1p0 IPS_15 (Just 1)) 1
            in
            [ test "should be 4 passes" <|
                \_ ->
                    Expect.equal reel.passes 4
            , test "reel footage should be 1800ft" <|
                let
                    footage =
                        reelLengthInFeet reel
                in
                \_ -> Expect.equal footage Ft1800
            , test "duration should be 90 minutes" <|
                let
                    duration =
                        singleReelDuration reel
                in
                \_ -> Expect.equal duration 90
            , test "should be 1518.75 MB in size for a 24/96 WAV" <|
                let
                    size =
                        filesize WAV_24_96 reel
                in
                \_ -> Expect.equal size 1518.75
            ]
        , describe "quadraphonic (4-track), 7\" 1.0mil @ 7.5 IPS" <|
            let
                reel =
                    newReel fakeUUID (SelectorValues Quadraphonic Seven Mil1p0 IPS_7p5 (Just 1)) 1
            in
            [ test "should be 1 pass" <|
                \_ ->
                    Expect.equal reel.passes 1
            , test "reel footage should be 1800ft" <|
                let
                    footage =
                        reelLengthInFeet reel
                in
                \_ -> Expect.equal footage Ft1800
            , test "duration should be 45 minutes" <|
                let
                    duration =
                        singleReelDuration reel
                in
                \_ -> Expect.equal duration 45
            , test "should be 1518.75 MB in size for a 24/96 WAV" <|
                let
                    size =
                        filesize WAV_24_96 reel
                in
                \_ -> Expect.equal size 3037.5
            ]
        ]


fakeUUID : Uuid
fakeUUID =
    let
        ( uuid, _ ) =
            step uuidGenerator (initialSeed 1234567)
    in
    uuid
