module ModelEventHandling exposing (..)

import MapModel exposing (..)
import MapNode exposing (..)
import NodeEventHandling exposing (..)
import Connectors
import UpdateHelpers exposing (..)

zoomChange : Model -> Float -> Model
zoomChange model x = 
  { model | svgScale = model.svgScale + x 
    ,toolbarText = "Scale : " ++ (toString (model.svgScale + x)) }

initNodeData : Model -> Model
initNodeData model =
  { model | actionState = CreatingNode
    ,toolbarText = "Set node properties in property panel"
    ,nodeData = MapNode.getPanelInit (model.nodeCounter + 1) }

updateNodeData : Model -> MapNode.UIPanelData -> Model
updateNodeData model pd =
  { model | nodeData = pd }

finishNode : Model -> Model
finishNode model = 
  let
    ndata = model.nodeData 
  in
    { model | nodeCounter = model.nodeCounter + 1
      ,toolbarText = "Node successfully created" 
      ,actionState = InspectingNode ndata.node
      ,nodes = List.append model.nodes [ ndata.node ] }

startConnecting : Model -> Model
startConnecting model =
  { model | actionState = ConnectingNodes Waiting
    ,connectorData = Connectors.getPanelInit 0
    ,toolbarText = "Select the first node to create connector" }

initConnectorData : Model -> Model
initConnectorData model =
  { model | connectorData = Connectors.getPanelInit 0 }

finishConnector : Model -> Model
finishConnector model = 
  let
    cdata = model.connectorData in
  { model | actionState = Idle 
    ,toolbarText = "Connector successfully created" 
    ,nodes = updateNodeInList model.nodes cdata.nodeId 
      (addConnector cdata.connector) }

updateConData : Model -> Connectors.UIPanelData -> Model
updateConData model pd =
  { model | connectorData = pd }

dragAt : Model -> {x:Int,y:Int} -> Model
dragAt model pos =
  case model.dragState of
    Node sn -> { model | nodes = updateNodeInList 
      model.nodes sn.id (move (calculateNodeClickPosition model pos)) }
    MapPan -> {model | panData = { panStart = calculatePanPosition model pos
       ,svgPos = UpdateHelpers.getSvgPos model pos } }
    DragNothing -> model

dragEnd : Model -> Model
dragEnd model = { model | dragState = DragNothing }

startPan : Model -> {x:Int,y:Int} -> Model
startPan model pos =
  case model.dragState of
    DragNothing ->
      { model | dragState = MapPan
        ,panData = { svgPos = model.panData.svgPos
          ,panStart = calculatePanPosition model pos } }
    _ -> model

inspectNode : Model -> MapNode -> Model
inspectNode model node = 
  { model | actionState = InspectingNode node }

selectNode : Model -> MapNode -> Model
selectNode model node =
  let 
    cdata = model.connectorData
    con = model.connectorData.connector
    ndata = model.nodeData
    nod = model.nodeData.node in
  case model.actionState of
    ConnectingNodes x ->
      case x of
        Waiting -> 
          { model | actionState = ConnectingNodes FirstSelected
            ,toolbarText = "Select the second node to create connector"
            ,connectorData = { cdata | nodeId = node.id } }
        FirstSelected -> 
          { model | actionState = ConnectingNodes SecondSelected
            ,toolbarText = "Set connector properties in property panel"
            ,connectorData = { cdata | connector = { con | nodeId = node.id } } }
        SecondSelected -> 
          { model | actionState = InspectingNode node }
    _ ->
      { model | actionState = InspectingNode node 
       ,dragState = Node node }

