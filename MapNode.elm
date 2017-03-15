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
}

getInit : Int -> MapNode
getInit identifier =
  {
    id = identifier
    ,displayText = "NewNode"
    ,px = 0
    ,py = 0
    ,connectors = []
  }


type alias UIPanelData = { 
  node : MapNode
}

getPanelInit : Int -> UIPanelData
getPanelInit id =
  {
    node = getInit id
  }

