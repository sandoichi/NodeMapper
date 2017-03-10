module Update exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import UIHelper exposing (..)
import Connectors exposing (..)
import ConnectorUI exposing (..)
import MapNode exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)
import Mouse exposing (Position)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg model =
  case msg of
    DragAt ({x,y} as d) ->
        case model.dragNode of
            Just sn ->
                  { model 
                  | nodes = model.nodes |> List.map (\n ->
                      case n.id == sn.id of
                          True -> 
                             calculatePosition {x=d.x,y=d.y} model.offSet
                             |> \{x,y} -> { n | px = x, py = y } 
                          False -> n)
                    ,lastMsg = Just (DragAt {x=d.x,y=d.y})
                  }

            Nothing ->  model
    DragEnd _ ->
                { model | 
                    dragNode = Nothing
                    ,lastMsg = Just (DragEnd {x=1,y=1})
                }
    InspectNode n -> 
        { model | actionState = InspectingNode n
        , lastMsg = Just (InspectNode n)}
    SelectNode (({x, y} as pos), node) ->
        case model.actionState of
          Connecting x ->
            case x of
              Waiting -> 
                { model | actionState = Connecting (FirstSelected node) }
              FirstSelected first -> 
                { model | actionState = 
                  Connecting (BothSelected (first, node, (Connectors.getInit node.id))) }
              BothSelected (first, second, c) -> model

          _ ->
            { model | actionState = InspectingNode node 
             ,offSet = Just (getOffset model pos)
             ,dragNode = Just node
             ,lastMsg = Just (SelectNode ({x=1,y=1}, node))
            }
    CreateConnector evt ->
      case model.actionState of
        Connecting x ->
          case x of
            BothSelected (first, second, c) ->
              case evt of
                InitConnector -> model
                ExitChanged s ->
                  { model | actionState = Connecting (BothSelected (first,second,{c|exitSide=s} ))}
                EnterChanged s ->
                  { model | actionState = Connecting (BothSelected (first,second,{c|entrySide=s} ))}
                FinishConnector ->
                  { model | actionState = Idle ,nodes = model.nodes |> List.map (\n ->
                     case n.id == first.id of
                      True -> 
                        { n | connectors = c::(n.connectors)} 
                      False -> n)
                  }
                _ -> model
            _ -> model
        _ -> model
    CreateNode e ->
        case model.actionState of
            CreatingNode n ->
                case e of 
                    InitNode ->
                        { model | 
                            actionState = CreatingNode (MapNode.getInit (model.nodeCounter + 1)) }
                    DisplayTxt s ->
                        { model | actionState = CreatingNode { n | displayText = s } }
                    FinishNode -> { model | nodeCounter = model.nodeCounter + 1
                                ,actionState = InspectingNode n
                                ,nodes = List.append model.nodes [ n ] }
            _ -> { model | 
                    actionState = CreatingNode (MapNode.getInit (model.nodeCounter + 1)) }
    StartConnecting ->
        { model | actionState = Connecting Waiting }


calculatePosition : {x:Int,y:Int} -> Maybe {x:Int,y:Int} -> {x:Int,y:Int}
calculatePosition mousePos offSet =
    case offSet of 
        Just off ->
            {x = mousePos.x - off.x, y = mousePos.y - off.y}
        Nothing ->
            {x = mousePos.x, y = mousePos.y}

getOffset : Model -> Position -> Position
getOffset model pos =
    case model.offSet of
        Just x -> x
        Nothing -> {x=pos.x,y=pos.y}
