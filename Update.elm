module Update exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import UIHelper exposing (..)
import Connectors exposing (..)
import ConnectorUI exposing (..)
import MapNode exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)
import Mouse exposing (Position)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg model =
  case msg of
    DragAt ({x,y} as d) ->
      case model.dragNode of
        Just sn ->
          { model 
          | nodes = model.nodes |> List.map (\n ->
            case n.id == sn.id of
              True -> 
                 calculatePosition {x=d.x,y=d.y} model.offSet
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
              { model | actionState = ConnectingNodes (FirstSelected node) }
            FirstSelected first -> 
              { model | actionState = ConnectingNodes (BothSelected first node) }
            BothSelected first second -> model
        _ ->
          { model | actionState = InspectingNode node 
           ,offSet = Just (getOffset model pos)
           ,dragNode = Just node
          }
    CreateConnector evt ->
      let 
        cd = model.connectorData
        c = model.connectorData.connector in
      case evt of
        InitConnector -> 
          { model | connectorData = Connectors.getPanelInit 0 }
        ExitChanged s ->
          { model | connectorData = { cd | connector = { c | exitSide = s } } }
        EnterChanged s ->
          { model | connectorData = { cd | connector = { c | exitSide = s } } }
        CostChanged cost ->
          { model | connectorData = { cd | connector = { c | cost = cost } } }
        FinishConnector ->
          { model | actionState = Idle ,nodes = model.nodes |> List.map (\n ->
             case n.id == cd.connector.nodeId of
               True -> { n | connectors = c::(n.connectors) } 
               False -> n) }
    CreateNode e ->
      let 
        nd = model.nodeData
        n = model.nodeData.node in
      case e of
        InitNode ->
          { model | nodeData = MapNode.getPanelInit (model.nodeCounter + 1) }
        DisplayTxt s ->
          { model | nodeData = { nd | node = { n | displayText = s } } }
        FinishNode -> 
          { model | nodeCounter = model.nodeCounter + 1
            ,actionState = InspectingNode n
            ,nodes = List.append model.nodes [ n ] }
    StartConnecting ->
        { model | actionState = ConnectingNodes Waiting }


calculatePosition : {x:Int,y:Int} -> Maybe {x:Int,y:Int} -> {x:Int,y:Int}
calculatePosition mousePos offSet =
  case offSet of 
    Just off ->
      {x = mousePos.x - off.x, y = mousePos.y - off.y}
    Nothing ->
      {x = mousePos.x, y = mousePos.y}

getOffset : Model -> Position -> Position
getOffset model pos =
  case model.offSet of
    Just x -> x
    Nothing -> {x=pos.x,y=pos.y}
