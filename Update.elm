module Update exposing (..)

import UIHelper exposing (..)
import Connectors exposing (..)
import ConnectorUI exposing (..)
import MapNode exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)
import UpdateHelpers

import Html exposing (..)
import Html.Attributes exposing (..)
import Mouse exposing (Position)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )

updateHelp : Msg -> Model -> Model
updateHelp msg model =
  let 
    cdata = model.connectorData
    con = model.connectorData.connector
    ndata = model.nodeData
    nod = model.nodeData.node in
  case msg of
    DoNothing -> model
    StartPan ({x,y} as d) ->
      case model.dragState of
        DragNothing ->
          { model | dragState = MapPan
            ,panData = { svgPos = model.panData.svgPos
            ,panStart = UpdateHelpers.calculatePanPosition model d } }
        _ -> model
    DragAt ({x,y} as d) ->
      case model.dragState of
        Node sn ->
          { model | nodes = model.nodes |> List.map (\n ->
            case n.id == sn.id of
              True -> 
                UpdateHelpers.calculateNodeClickPosition model {x=d.x,y=d.y} 
                |> \{x,y} -> { n | px = x, py = y } 
              False -> n) }
        MapPan -> {model | panData = { panStart =  UpdateHelpers.calculatePanPosition model d  
           ,svgPos = UpdateHelpers.getSvgPos model d } }
        DragNothing -> model
    DragEnd _ ->
      { model | dragState = DragNothing }
    InspectNode n -> 
      { model | actionState = InspectingNode n }
    SelectNode (({x, y} as pos), node) ->
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
    CreateConnector evt ->
      case evt of
        InitConnector -> 
          { model | connectorData = Connectors.getPanelInit 0 }
        ExitChanged s ->
          { model | connectorData = { cdata | connector = { con | exitSide = s } } }
        EnterChanged s ->
          { model | connectorData = { cdata | connector = { con | entrySide = s } } }
        CostChanged cost ->
          { model | connectorData = { cdata | connector = { con | cost = cost } } }
        FinishConnector ->
          { model | actionState = Idle 
            ,toolbarText = "Connector successfully created" 
            ,nodes = model.nodes |> List.map (\n ->
             case n.id == cdata.nodeId of
               True -> { n | connectors = con::(n.connectors) } 
               False -> n) }
    CreateNode e ->
      case e of
        InitNode ->
          { model | actionState = CreatingNode
            ,toolbarText = "Set node properties in property panel"
            ,nodeData = MapNode.getPanelInit (model.nodeCounter + 1) }
        DisplayTxt s ->
          { model | nodeData = { ndata | node = { nod | displayText = s } } }
        FinishNode -> 
          { model | nodeCounter = model.nodeCounter + 1
            ,toolbarText = "Node successfully created" 
            ,actionState = InspectingNode nod
            ,nodes = List.append model.nodes [ nod ] }
    StartConnecting ->
      { model | actionState = ConnectingNodes Waiting
        ,connectorData = Connectors.getPanelInit 0
        ,toolbarText = "Select the first node to create connector" }
    ZoomChange x -> { model | svgScale = model.svgScale + x 
      ,toolbarText = "Scale : " ++ (toString (model.svgScale + x)) }


