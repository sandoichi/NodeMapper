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
      g [ on "mousedown" ((Decode.map (\x -> SelectNode (x, mapNode)) Mouse.position))
          ,transform (getTransformStyle model mapNode)
        ] [ 
              rect [
                  class ("rect " ++ case getNodeType mapNode model of
                            Selected -> "selected"
                            Regular -> "")
                  ,Svg.Attributes.width "100"
                  ,Svg.Attributes.height "100" 
                  ,rx "5"
                  ,ry "5"
                  ] [] 
              ,Svg.text_ [ 
                  class "text"
                  ,x "10"
                  ,y "20"
              ] [ Html.text mapNode.displayText ] 
          ]

getTransformStyle : Model -> MapNode -> String
getTransformStyle model node =
  "translate(-50 -50)"
  ++ " scale(" ++ (toString model.svgScale) ++ ")"
  ++ " translate(" ++ (toString node.px) ++ " " ++ (toString node.py) ++ ")"

genConnectorGraphic : MapNode -> MapNode -> Model -> Svg Msg
genConnectorGraphic start end model =
    line [
        class "connectorLine"
        ,x1 (toString (getConnectorEndPoint start.px model.svgScale))
        ,y1 (toString (getConnectorEndPoint start.py model.svgScale))
        ,x2 (toString (getConnectorEndPoint end.px model.svgScale))
        ,y2 (toString (getConnectorEndPoint end.py model.svgScale))
        ] []

getConnectorEndPoint : Int -> Float -> Float
getConnectorEndPoint nodePoint scale =
  (toFloat nodePoint * scale) + (50 * scale)

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
    ] (List.append (mapNodeList nodes model) (mapConnectors nodes model))


















