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
    ,px = 5
    ,py = 5
    ,connectors = []
  }


