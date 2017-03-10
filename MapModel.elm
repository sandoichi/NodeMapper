module MapModel exposing (..)

import MapMsg exposing (..)
import MapNode exposing (..)
import Connectors

type ConnectorState =
  Waiting
  | FirstSelected MapNode
  | BothSelected (MapNode, MapNode, Connectors.Connector)

type ActionState =
        Idle
        | Connecting ConnectorState
        | CreatingNode MapNode
        | InspectingNode MapNode

type alias Model = { 
    nodes : List MapNode 
    ,nodeCounter : Int
    ,dragNode : Maybe MapNode
    ,offSet : Maybe { x : Int, y : Int }
    ,actionState : ActionState
    ,lastMsg : Maybe Msg
}

init : ( Model, Cmd Msg )
init = ({
       nodes = []
       ,nodeCounter = 0
       ,dragNode = Nothing
       ,offSet = Nothing
       ,actionState = Idle 
       ,lastMsg = Nothing
   }, Cmd.none)     


