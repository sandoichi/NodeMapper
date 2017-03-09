module Test exposing (..)

import MapMsg exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import MapNode exposing (..)
import MapModel exposing (..)
import MapView exposing (..)
import UIHelper exposing (..)
import Mouse exposing (Position)


main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  case model.dragNode of
    False ->
      Sub.none

    True ->
      Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg model =
  case msg of
    StartDrag (({x, y} as drag), node) -> 
        case model.offSet of
            Just offset ->
                { model | dragNode = True
                    ,selectedNode = Just node 
                }
            Nothing -> 
                { model | 
                    dragNode = True
                    ,offSet = Just {x=drag.x,y=drag.y }
                    ,selectedNode = Just node 
                }

    DragAt ({x,y} as d) ->
      case model.selectedNode of
          Nothing ->
              model
          Just sn ->
              { model 
              | nodes = model.nodes |> List.map (\n ->
                  case n.id == sn.id of
                      True -> 
                         calculatePosition {x=d.x,y=d.y} model.offSet
                         |> \{x,y} -> { n | px = x, py = y } 
                      False -> n)
              }

    DragEnd _ ->
        { model | dragNode = False }

    CreateNode ->
        case model.tempNode of
            Nothing -> model
            Just x ->
                { model | 
                    nodeCounter = model.nodeCounter + 1
                    ,nodes = 
                        List.append 
                            model.nodes 
                            [ x ]
                }
    SelectNode node -> 
        case model.selectedNode of
            Just x ->
                { model | editMode = Normal, selectedNode2 = Just node }
            Nothing ->
                { model | editMode = Normal, selectedNode = Just node }
    ChangeMode mode ->
        case mode of
            Create ->
                { model | 
                    editMode = mode 
                    ,tempNode = Just {
                        id = model.nodeCounter + 1
                        ,displayText = "Node " ++ toString (model.nodeCounter + 1)
                        ,px = 10
                        ,py = 10
                        ,connectors = Connectors []
                    }
                }
            _ ->
                { model | editMode = mode }

    AddConnector c ->
            case (model.selectedNode, model.selectedNode2) of
                (Just x, Just y) ->
                      { model 
                      | nodes = model.nodes |> List.map (\n ->
                          case n.id == x.id of
                              True -> 
                                  { n | connectors = 
                                      List.append (unwrapConnectors n.connectors) [{ nodeId = y.id, cost = c }]
                                      |> Connectors
                                  }
                              False -> n)
                      }
                _ ->
                    model

    PanelEvent e ->
        case e of 
            DisplayTxt s ->
                case model.tempNode of
                    Nothing -> model
                    Just x ->
                        { model | tempNode =
                            Just { x | displayText = s }
                        }


calculatePosition : {x:Int,y:Int} -> Maybe {x:Int,y:Int} -> {x:Int,y:Int}
calculatePosition mousePos offSet =
    case offSet of 
        Just off ->
            {x = mousePos.x - off.x, y = mousePos.y - off.y}
        Nothing ->
            {x = mousePos.x, y = mousePos.y}
