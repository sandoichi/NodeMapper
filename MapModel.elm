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

type DragState =
  DragNothing
  | Node MapNode
  | MapPan

type alias SvgPanData = {
  svgPos : {x:Int,y:Int}  
  ,panStart : {x:Int,y:Int}  
}

type alias Model = { 
  nodes : List MapNode 
  ,connectorData : Connectors.UIPanelData
  ,nodeData : MapNode.UIPanelData
  ,nodeCounter : Int
  ,dragState : DragState
  ,actionState : ActionState
  ,toolbarText : String
  ,svgScale : Float
  ,nodeSize : Int
  ,panData : SvgPanData
}

init : ( Model, Cmd Msg )
init = ({
   nodes = []
  ,connectorData = Connectors.getPanelInit 0
  ,nodeData = MapNode.getPanelInit 0
  ,nodeCounter = 0
  ,dragState = DragNothing
  ,actionState = Idle 
  ,toolbarText = ""
  ,svgScale = 1.0
  ,nodeSize = 100
  ,panData = { svgPos = {x=0,y=0}, panStart = {x=0,y=0}}
   }, Cmd.none)     

