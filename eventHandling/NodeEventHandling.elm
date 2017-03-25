module NodeEventHandling exposing (..)

import MapNode exposing (..)
import MapModel exposing (..)
import Connectors exposing (Connector)

updatePDNode : UIPanelData -> (MapNode -> MapNode) -> UIPanelData
updatePDNode pd f =
  { pd | node = f pd.node }

updateDisplayText : String -> MapNode -> MapNode
updateDisplayText text node =
 { node | displayText = text }

move : {x:Int,y:Int} -> MapNode -> MapNode
move pos node = 
  { node | px = pos.x, py = pos.y }

addConnector : Connector -> MapNode -> MapNode
addConnector con node =
  { node | connectors = con::(node.connectors) } 

updateNodeInList : List MapNode -> Int -> (MapNode -> MapNode) -> List MapNode
updateNodeInList nodes id f =
  nodes
  |> List.map (\n -> 
       case n.id == id of
         True -> f n
         False -> n)

hoverSide : MapNode -> SideRegion -> Model -> Model
hoverSide node region model =
  { model | nodes = updateNodeInList model.nodes node.id
    (\x -> { x | sideRegions = x.sideRegions
      |> List.map (\r ->
        case r.side == region.side of
          True -> { r | state = Hover }
          False -> r) } ) }

stopHoverSide : MapNode -> SideRegion -> Model -> Model
stopHoverSide node region model =
  { model | nodes = updateNodeInList model.nodes node.id
    (\x -> { x | sideRegions = x.sideRegions
      |> List.map (\r ->
        case r.side == region.side of
          True -> { r | state = Normal }
          False -> r) } ) }
