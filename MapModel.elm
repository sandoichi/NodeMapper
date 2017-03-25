module MapModel exposing (..)

import MapMsg exposing (..)
import MapNode exposing (..)
import Connectors

type ConnectorState =
  Waiting
  | FirstSelected
  | SecondSelected

type ActionState =
  Idle
  | ConnectingNodes ConnectorState
  | CreatingNode
  | InspectingNode MapNode


type alias Model = { 
  nodes : List MapNode 
  ,connectorData : Connectors.UIPanelData
  ,nodeData : MapNode.UIPanelData
  ,nodeCounter : Int
  ,draggingNode : Maybe MapNode
  ,actionState : ActionState
  ,toolbarText : String
  ,svgScale : Float
  ,nodeSize : Int
}

init : ( Model, Cmd Msg )
init = ({
   nodes = []
  ,connectorData = Connectors.getPanelInit 0
  ,nodeData = MapNode.getPanelInit 0
  ,nodeCounter = 0
  ,draggingNode = Nothing
  ,actionState = Idle 
  ,toolbarText = ""
  ,svgScale = 1.0
  ,nodeSize = 100
   }, Cmd.none)     

