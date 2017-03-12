module MapModel exposing (..)

import MapMsg exposing (..)
import MapNode exposing (..)
import Connectors

type ConnectorState =
  Waiting
  | FirstSelected MapNode
  | BothSelected MapNode MapNode

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
    ,dragNode : Maybe MapNode
    ,offSet : Maybe { x : Int, y : Int }
    ,actionState : ActionState
    ,lastMsg : Maybe Msg
}


init : ( Model, Cmd Msg )
init = ({
   nodes = []
  ,connectorData = Connectors.getPanelInit 0
  ,nodeData = MapNode.getPanelInit 0
  ,nodeCounter = 0
  ,dragNode = Nothing
  ,offSet = Nothing
  ,actionState = Idle 
  ,lastMsg = Nothing
   }, Cmd.none)     


