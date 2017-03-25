module ModelEventHandling exposing (..)

import MapModel exposing (..)
import MapNode exposing (..)
import NodeEventHandling exposing (..)
import Connectors

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

dragNode : Model -> {x:Int,y:Int} -> Model
dragNode model pos =
  case model.draggingNode of
  Just sn -> { model | nodes = updateNodeInList 
    model.nodes sn.id (move pos) }
  Nothing ->  model

dragEnd : Model -> Model
dragEnd model = { model | draggingNode = Nothing }

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
       ,draggingNode = Just node }

