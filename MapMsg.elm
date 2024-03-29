module MapMsg exposing (..)

import Mouse exposing (Position)
import MapNode exposing (MapNode)
import Connectors

import Html exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (..)

type CreationEvent =
  InitNode
  | DisplayTxt String
  | FinishNode

type Msg = 
  CreateNode CreationEvent
  | SelectNode (Position, MapNode)
  | InspectNode MapNode
  | StartPan Position
  | DragAt Position
  | DragEnd Position
  | StartConnecting
  | CreateConnector Connectors.Event
  | DoNothing
  | ZoomChange Float
  | HoverSideRegion MapNode MapNode.SideRegion
  | StopHoverSideRegion MapNode MapNode.SideRegion

