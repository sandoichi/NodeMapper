module Connectors exposing (..)


type alias Connector = {
  nodeId : Int
  ,cost : Int
  ,exitSide : Side
  ,entrySide : Side
}

getInit : Int -> Connector
getInit id =
  {
    nodeId = id
    ,cost = 5
    ,exitSide = Top
    ,entrySide = Top
  }

type Side =
  Top
  | Bottom
  | Left
  | Right

type Event =
  InitConnector
  | ExitChanged Side
  | EnterChanged Side
  | CostChanged Side
  | FinishConnector
