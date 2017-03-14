module MapSvg exposing (..)

import MapNode exposing(..)
import MapMsg exposing (..)
import MapModel exposing (..)
import Connectors exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Mouse exposing (Position)
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
      g [ on "mousedown" ((Decode.map (\x -> SelectNode (x, mapNode)) Mouse.position))
        ] [ 
              rect [
                  class ("rect " ++ case getNodeType mapNode model of
                            Selected -> "selected"
                            Regular -> "")
                  ,Svg.Attributes.width "100"
                  ,Svg.Attributes.height "100" 
                  ,rx "5"
                  ,ry "5"
                  ,x (toString mapNode.px)
                  ,y (toString mapNode.py)
                  ] [] 
              ,Svg.text_ [ 
                  class "text"
                  ,x (toString (mapNode.px + 5))
                  ,y (toString (mapNode.py + 40))
              ] [ Html.text mapNode.displayText ] 
          ]

genConnectorGraphic : MapNode -> MapNode -> Svg Msg
genConnectorGraphic start end =
    line [
        class "connectorLine"
        ,x1 (toString start.px)
        ,y1 (toString start.py)
        ,x2 (toString end.px)
        ,y2 (toString end.py)
        ] []

genConnectors : MapNode -> List MapNode -> List (Svg Msg)
genConnectors node connectedNodes = 
    List.map (\x -> genConnectorGraphic node x) connectedNodes

connectorsContainsId : List Connector -> Int -> Bool
connectorsContainsId connectors id =
    connectors
    |> List.map (\x -> x.nodeId)
    |> List.member id

genConnectorsMap : MapNode -> List MapNode -> List (Svg Msg)
genConnectorsMap node nodes =
    nodes
    |> List.filter (\x -> connectorsContainsId node.connectors x.id)
    |> genConnectors node

mapNodeList : List MapNode -> Model -> List (Svg Msg)
mapNodeList nodes model =
    List.map (\x -> genGraphic x model) nodes

mapConnectors : List MapNode -> List (Svg Msg)
mapConnectors nodes =
    nodes 
    |> List.filter (\x -> x.connectors /= [])
    |> List.map (\x -> genConnectorsMap x nodes) 
    |> List.concat

genSvg : List MapNode -> Model -> Html Msg
genSvg nodes model =
    svg [ class "svg" 
      ,transform ("scale(" ++ (toString model.svgScale) ++ ")")
      , on "mousewheel" (Decode.map (\x -> wheelZoom x))
    ] (List.append (mapNodeList nodes model) (mapConnectors nodes))

wheelZoom : Float -> Msg
wheelZoom delta  = 
  ZoomChange delta 

  

