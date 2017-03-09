module MapModel exposing (..)

import MapMsg exposing (..)
import MapNode exposing (..)


type alias Model = { 
    editMode : EditMode
    ,nodes : List MapNode 
    ,selectedNode : Maybe MapNode
    ,selectedNode2 : Maybe MapNode
    ,nodeCounter : Int
    ,dragNode : Bool
    ,offSet : Maybe { x : Int, y : Int }
    ,tempNode : Maybe MapNode
}

init : ( Model, Cmd Msg )
init =
   ({
       editMode = Normal
       ,nodes = []
       ,selectedNode = Nothing
       ,selectedNode2 = Nothing
       ,nodeCounter = 0
       ,dragNode = False
       ,offSet = Nothing
       ,tempNode = Nothing
   }, Cmd.none)     


