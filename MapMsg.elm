module MapMsg exposing (..)

import Mouse exposing (Position)
import MapNode exposing (MapNode)

import Html exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (..)

type EditMode = Normal | Create

type CreatePanelEvent =
    DisplayTxt String

type Msg = 
    ChangeMode EditMode 
    | CreateNode
    | SelectNode MapNode
    | AddConnector Int
    | StartDrag (Position, MapNode)
    | DragAt Position
    | DragEnd Position
    | PanelEvent CreatePanelEvent

