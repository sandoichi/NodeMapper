module MapSvg exposing (..)

import MapNode exposing(..)
import MapMsg exposing (..)
import MapModel exposing (..)
import Connectors exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Mouse exposing (..)
import Json.Decode as Decode

type NodeType =
    Selected
    | Regular

getNodeType : MapNode -> Model -> NodeType
getNodeType node model =
    case model.actionState of
        InspectingNode x ->
            case x.id == node.id of
                True -> Selected
                False -> Regular
        _ -> Regular

genGraphic : MapNode -> Model -> Svg Msg
genGraphic mapNode model =
  g [ ] [ 
    rect [on "mousedown" ((Decode.map (\x -> SelectNode (x, mapNode)) Mouse.position)) 
      ,class ("rect " ++ case getNodeType mapNode model of
        Selected -> "selected"
        Regular -> "")
      ,Svg.Attributes.width (toString model.nodeSize)
      ,Svg.Attributes.height (toString model.nodeSize)
      ,rx "5"
      ,ry "5"
      ,x (toString mapNode.px)
      ,y (toString mapNode.py)
      ] [] 
  ,Svg.text_ [ on "mousedown" ((Decode.map (\x -> SelectNode (x, mapNode)) Mouse.position)) 
      ,class "text"
      ,x (toString (mapNode.px+10))
      ,y (toString (mapNode.py+20))
  ] [ Html.text mapNode.displayText ] ]

genConnectorGraphic : MapNode -> MapNode -> Model -> Svg Msg
genConnectorGraphic start end model =
  let
    matchingCon =
      start.connectors
      |> List.filter (\x -> x.nodeId == end.id)
      |> List.head

    conSides =
      case matchingCon of
        Just x -> { exitSide = x.exitSide, entrySide = x.entrySide }  
        Nothing -> { exitSide = Top, entrySide = Bottom }

    startPos = calculateConnectorPoint model conSides.exitSide
    endPos = calculateConnectorPoint model conSides.entrySide in

  line [
    class "connectorLine"
    ,x1 (toString (start.px + startPos.x))
    ,y1 (toString (start.py + startPos.y))
    ,x2 (toString (end.px + endPos.x))
    ,y2 (toString (end.py + endPos.y))
    ] []

calculateConnectorPoint : Model -> Side -> {x:Int,y:Int}
calculateConnectorPoint model side =
  let
    half = round (toFloat model.nodeSize / 2) 
    full = model.nodeSize in
  case side of
    Top -> { x = half, y = 0 }
    Bottom -> { x = half, y = full }
    Left -> { x = 0, y = half }
    Right -> { x = full, y = half }

genConnectors : MapNode -> Model -> List MapNode -> List (Svg Msg)
genConnectors node model connectedNodes = 
    List.map (\x -> genConnectorGraphic node x model) connectedNodes

connectorsContainsId : List Connector -> Int -> Bool
connectorsContainsId connectors id =
    connectors
    |> List.map (\x -> x.nodeId)
    |> List.member id

genConnectorsMap : MapNode -> List MapNode -> Model -> List (Svg Msg)
genConnectorsMap node nodes model =
    nodes
    |> List.filter (\x -> connectorsContainsId node.connectors x.id)
    |> genConnectors node model

mapNodeList : List MapNode -> Model -> List (Svg Msg)
mapNodeList nodes model =
    List.map (\x -> genGraphic x model) nodes

mapConnectors : List MapNode -> Model -> List (Svg Msg)
mapConnectors nodes model =
    nodes 
    |> List.filter (\x -> x.connectors /= [])
    |> List.map (\x -> genConnectorsMap x nodes model) 
    |> List.concat

genSvg : List MapNode -> Model -> Html Msg
genSvg nodes model =
    svg [ class "svg" 
      ,viewBox (calcViewBox model)
    ] (List.append (mapNodeList nodes model) (mapConnectors nodes model))

calcViewBox : Model -> String
calcViewBox model =
  "0 0 " ++ (toString (3000 / model.svgScale)) ++ " " ++ (toString (3000 / model.svgScale))

