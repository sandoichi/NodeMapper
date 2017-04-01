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

sideRegionSize : Float
sideRegionSize = 0.5

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
  g [ ] (List.concat [
    [ rect [on "mousedown" ((Decode.map (\x -> SelectNode (x, mapNode)) Mouse.position)) 
      ,class ("rect " ++ case getNodeType mapNode model of
        Selected -> "selected"
        Regular -> "")
      ,Svg.Attributes.width (toString model.nodeSize)
      ,Svg.Attributes.height (toString model.nodeSize)
      ,rx "5"
      ,ry "5"
      ,x (toString mapNode.px)
      ,y (toString mapNode.py) ] [] 
  ,Svg.text_ [ on "mousedown" ((Decode.map (\x -> SelectNode (x, mapNode)) Mouse.position)) 
      ,class "text"
      ,x (toString (mapNode.px+10))
      ,y (toString (mapNode.py+20))] 
      [ Html.text mapNode.displayText ] ]
  ,(genSideRegions mapNode model) ] )

genSideRegions : MapNode -> Model -> List (Svg Msg)
genSideRegions node model =
  case model.actionState of
    ConnectingNodes state ->
      node.sideRegions
      |> List.map (\r ->
        let
          pos = getSideRegionPos node r model in
        rect [
          on "mouseenter" (Decode.map (\x -> HoverSideRegion node r) Mouse.position) 
          ,on "mouseleave" (Decode.map (\x -> StopHoverSideRegion node r) Mouse.position) 
          ,class (getSideRegionClass r)
          ,Svg.Attributes.width (toString (round (toFloat model.nodeSize * sideRegionSize)))
          ,Svg.Attributes.height (toString (round (toFloat model.nodeSize * sideRegionSize)))
          ,rx "0"
          ,ry "0"
          ,x (toString pos.x)
          ,y (toString pos.y)
          ] [] )
    _ -> []

getSideRegionClass : SideRegion -> String
getSideRegionClass sideRegion =
  case sideRegion.state of
    Normal -> "sideRegionNormal"
    Hover -> "sideRegionHover"

getSideRegionPos : MapNode -> SideRegion -> Model -> {x:Int,y:Int}
getSideRegionPos node sideRegion model =
  let
    halfOffset = round (toFloat model.nodeSize * (sideRegionSize / 2))
    fullOffset = round (toFloat model.nodeSize * sideRegionSize)
    half = round (toFloat model.nodeSize / 2)
    full = model.nodeSize in
  case sideRegion.side of
    Top -> { x = half - halfOffset + node.px, y = node.py - fullOffset }
    Bottom -> { x = half - halfOffset + node.px, y = full + node.py }
    Left -> { x = node.px - fullOffset, y = half - halfOffset + node.py}
    Right -> { x = full + node.px, y = half - halfOffset + node.py }

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
    ,markerEnd "url(#arrow)"
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
    svg [ class "svg" ,viewBox (calcViewBox model) 
      ,on "mousedown" (Decode.map StartPan Mouse.position) ] 
      (defs [] [
        marker [ id "arrow", markerWidth "10", markerHeight "10"
          ,refX "9", refY "3", orient "auto", markerUnits "strokeWidth" ] 
          [ Svg.path [ d "M0,0 L0,6 L9,3 z", fill "#f00" ] [] ] ]
      ::(List.append (mapNodeList nodes model) (mapConnectors nodes model)))

calcViewBox : Model -> String
calcViewBox model =
  toString model.panData.svgPos.x ++ " " 
  ++ toString model.panData.svgPos.y ++ " " 
  ++ (toString (3000 / model.svgScale)) ++ " " 
  ++ (toString (3000 / model.svgScale))

