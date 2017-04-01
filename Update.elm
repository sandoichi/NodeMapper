module Update exposing (..)

import Connectors exposing (..)
import ConnectorsEventHandling exposing (..)
import NodeEventHandling exposing (..)
import MapNode exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)
import UpdateHelpers exposing (..)
import ModelEventHandling exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )

updateHelp : Msg -> Model -> Model
updateHelp msg model =
  let
    upPDCon = updatePDConnector model.connectorData
    upPDNode = updatePDNode model.nodeData in
  case msg of
    DoNothing -> model
    StartPan d ->
      startPan model d
    DragAt d ->
      dragAt model d
    DragEnd _ -> 
      dragEnd model
    InspectNode n -> 
      inspectNode model n
    SelectNode (pos, node) -> 
      selectNode model node
    CreateConnector evt ->
      case evt of
        InitConnector -> 
          initConnectorData model
        ExitChanged s ->
          updateConData model (upPDCon (updateExit s))
        EnterChanged s ->
          updateConData model (upPDCon (updateEntry s))
        CostChanged cost ->
          updateConData model (upPDCon (updateCost cost))
        FinishConnector ->
          finishConnector model
    CreateNode e ->
      case e of
        InitNode ->
          initNodeData model
        DisplayTxt s ->
          updateNodeData model (upPDNode (updateDisplayText s))
        FinishNode -> 
          finishNode model
    StartConnecting ->
      startConnecting model
    HoverSideRegion n s ->
      hoverSide n s model
    StopHoverSideRegion n s ->
      stopHoverSide n s model
    ZoomChange x ->  
      zoomChange model x

