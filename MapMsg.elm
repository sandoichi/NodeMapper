module MapMsg exposing (..)

import Mouse exposing (Position)
import MapNode exposing (MapNode)

import Html exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (..)

type CreationEvent =
    Init
    | DisplayTxt String
    | Finish

type Msg = 
    CreateNode CreationEvent
    | SelectNode (Position, MapNode)
    | InspectNode MapNode
    | DragAt Position
    | DragEnd Position
    | StartConnecting

