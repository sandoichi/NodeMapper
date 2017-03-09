module MapNode exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

type alias Connector = {
    nodeId : Int
    ,cost : Int
}

type Connectors = Connectors (List Connector)

type alias MapNode = { 
    id : Int
    ,displayText : String
    ,px : Int
    ,py : Int
    ,connectors : Connectors
}

unwrapConnectors : Connectors -> List Connector
unwrapConnectors connectors =
    case connectors of
        Connectors conns -> conns

