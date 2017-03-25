module MapNode exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Connectors exposing (..)

type alias MapNode = { 
  id : Int
  ,displayText : String
  ,px : Int
  ,py : Int
  ,connectors : List Connector
  ,sideRegions : List SideRegion
}

type SideState = Normal | Hover

type alias SideRegion = {
  state : SideState
  ,side : Side
}

getInit : Int -> MapNode
getInit identifier =
  {
    id = identifier
    ,displayText = "NewNode"
    ,px = 50
    ,py = 50
    ,connectors = []
    ,sideRegions = [
      {state = Normal, side = Top} 
      ,{state = Normal, side = Left} 
      ,{state = Normal, side = Right} 
      ,{state = Normal, side = Bottom} ]
  }

type alias UIPanelData = { 
  node : MapNode
}

getPanelInit : Int -> UIPanelData
getPanelInit id =
  {
    node = getInit id
  }

