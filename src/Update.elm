module Update exposing (update)

import AppSettings exposing (PageView(..), SystemOfMeasurement(..))
import Audio.Reel.Model exposing (Reel, findReelByValues, newReel)
import CsvOutput exposing (dataForCSV)
import List.Extra as ListX
import Messages exposing (Msg(..))
import Model exposing (Model)
import Ports
import Random exposing (step)
import Uuid exposing (Uuid, uuidGenerator)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddReel ->
            case model.selectorValues.quantity of
                Just q ->
                    let
                        ( uuid, newSeed ) =
                            step uuidGenerator model.currentSeed

                        newModel =
                            { model | currentSeed = newSeed, reels = addReel uuid model q }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeLanguage l ->
            ( { model | language = l }, Cmd.none )

        ChangeSystemOfMeasurement system ->
            case system of
                Metric ->
                    ( { model | system = Metric }, Cmd.none )

                Imperial ->
                    ( { model | system = Imperial }, Cmd.none )

        DecrementReelQuantity reelID ->
            case ListX.find (\reel -> reel.id == reelID) model.reels of
                Just reel ->
                    if reel.quantity == 1 then
                        let
                            newModel =
                                { model | reels = removeReel reelID model.reels }
                        in
                        ( newModel, Cmd.none )

                    else
                        let
                            updatedReel =
                                { reel | quantity = reel.quantity - 1 }

                            newModel =
                                { model | reels = updateReelInList updatedReel model.reels }
                        in
                        ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        DeleteReel reelID ->
            let
                newModel =
                    { model | reels = removeReel reelID model.reels }
            in
            ( newModel, Cmd.none )

        IncrementReelQuantity reelID ->
            case ListX.find (\reel -> reel.id == reelID) model.reels of
                Just reel ->
                    let
                        updatedReel =
                            { reel | quantity = reel.quantity + 1 }

                        newModel =
                            { model | reels = updateReelInList updatedReel model.reels }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        KeyDown int ->
            case int of
                13 ->
                    -- Enter key
                    update AddReel model

                _ ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        SetAudioConfig config ->
            let
                updateSValues sValues newConfig =
                    { sValues | audioConfig = newConfig }

                newSelectorValues =
                    updateSValues model.selectorValues config

                newModel =
                    { model | selectorValues = newSelectorValues }
            in
            ( newModel, Cmd.none )

        SetDiameterInInches diameter ->
            let
                updateSValues sValues newDiameterInInches =
                    { sValues | diameter = newDiameterInInches }

                newSelectorValues =
                    updateSValues model.selectorValues diameter

                newModel =
                    { model | selectorValues = newSelectorValues }
            in
            ( newModel, Cmd.none )

        SetFileType ft ->
            ( { model | fileType = ft }, Cmd.none )

        SetQuantity quantity ->
            let
                updateSValues sValues newQuantity =
                    { sValues | quantity = newQuantity }
            in
            case String.toInt quantity of
                Just q ->
                    let
                        newSelectorValues =
                            updateSValues model.selectorValues <| Just q

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

                Nothing ->
                    let
                        newSelectorValues =
                            updateSValues model.selectorValues Nothing

                        newModel =
                            { model | selectorValues = newSelectorValues }
                    in
                    ( newModel, Cmd.none )

        SetRecordingSpeed speed ->
            let
                updateSValues sValues newSpeed =
                    { sValues | recordingSpeed = newSpeed }

                newSelectorValues =
                    updateSValues model.selectorValues speed

                newModel =
                    { model | selectorValues = newSelectorValues }
            in
            ( newModel, Cmd.none )

        SetTapeThickness thickness ->
            let
                updateSValues sValues newThickness =
                    { sValues | tapeThickness = newThickness }

                newSelectorValues =
                    updateSValues model.selectorValues thickness

                newModel =
                    { model | selectorValues = newSelectorValues }
            in
            ( newModel, Cmd.none )

        StartExport ->
            let
                csvData =
                    dataForCSV model
            in
            ( model, Ports.exportData csvData )

        TogglePageView page ->
            case page of
                Calculator ->
                    ( { model | page = Info }, Cmd.none )

                Info ->
                    ( { model | page = Calculator }, Cmd.none )


removeReel : Uuid -> List Reel -> List Reel
removeReel reelID allReels =
    List.filter (\r -> r.id /= reelID) allReels


addReel : Uuid -> Model -> Int -> List Reel
addReel uuid model quantity =
    case findReelByValues model.selectorValues model.reels of
        -- If we already have a reel with these specs, increment the quantity
        Just reel ->
            let
                updatedReel =
                    { reel | quantity = reel.quantity + quantity }
            in
            ListX.setIf (\r -> r == reel) updatedReel model.reels

        -- Otherwise, add a new reel to the list.
        Nothing ->
            newReel uuid model.selectorValues quantity :: model.reels


updateReelInList : Reel -> List Reel -> List Reel
updateReelInList reel reels =
    ListX.setIf (\r -> r.id == reel.id) reel reels
