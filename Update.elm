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
    DragAt ({x,y} as d) ->
      case model.dragNode of
        Just sn ->
          { model 
          | nodes = model.nodes |> List.map (\n ->
            case n.id == sn.id of
              True -> 
                 UpdateHelpers.calculatePosition {x=d.x,y=d.y} model.offSet
                 |> \{x,y} -> { n | px = x, py = y } 
              False -> n) }
        Nothing ->  model
    DragEnd _ ->
      { model | dragNode = Nothing }
    InspectNode n -> 
      { model | actionState = InspectingNode n }
    SelectNode (({x, y} as pos), node) ->
      case model.actionState of
        ConnectingNodes x ->
          case x of
            Waiting -> 
              { model | actionState = ConnectingNodes FirstSelected
                ,connectorData = { cdata | nodeId = node.id } }
            FirstSelected -> 
              { model | actionState = ConnectingNodes SecondSelected
                ,connectorData = { cdata | connector = { con | nodeId = node.id } } }
            SecondSelected -> 
              { model | actionState = InspectingNode node }
        _ ->
          { model | actionState = InspectingNode node 
           ,offSet = Just (UpdateHelpers.getOffset model pos)
           ,dragNode = Just node
          }
    CreateConnector evt ->
      case evt of
        InitConnector -> 
          { model | connectorData = Connectors.getPanelInit 0 }
        ExitChanged s ->
          { model | connectorData = { cdata | connector = { con | exitSide = s } } }
        EnterChanged s ->
          { model | connectorData = { cdata | connector = { con | exitSide = s } } }
        CostChanged cost ->
          { model | connectorData = { cdata | connector = { con | cost = cost } } }
        FinishConnector ->
          { model | actionState = Idle ,nodes = model.nodes |> List.map (\n ->
             case n.id == cdata.nodeId of
               True -> { n | connectors = con::(n.connectors) } 
               False -> n) }
    CreateNode e ->
      case e of
        InitNode ->
          { model | 
            actionState = CreatingNode
            ,nodeData = MapNode.getPanelInit (model.nodeCounter + 1) }
        DisplayTxt s ->
          { model | nodeData = { ndata | node = { nod | displayText = s } } }
        FinishNode -> 
          { model | nodeCounter = model.nodeCounter + 1
            ,actionState = InspectingNode nod
            ,nodes = List.append model.nodes [ nod ] }
    StartConnecting ->
        { model | actionState = ConnectingNodes Waiting }


