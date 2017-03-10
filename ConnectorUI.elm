module ConnectorUI exposing (..)

import MapNode exposing (..)
import MapMsg exposing (..)
import MapModel exposing (..)
import Connectors exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

getNodeConnectionPanel : Model -> Html Msg
getNodeConnectionPanel model =
  div [ class "divPropertyPanel" ] [ determineConnectorPanel model ]

determineConnectorPanel : Model -> Html Msg
determineConnectorPanel model =
  case model.actionState of
    Connecting x ->
      case x of
        Waiting -> waitingPanel
        FirstSelected first -> firstSelectedPanel first
        BothSelected (first, second, c) -> bothSelectedPanel first second c
    _ -> waitingPanel

waitingPanel : Html Msg
waitingPanel =
  div [] [ text "Select the start node for this connector" ]
  
firstSelectedPanel : MapNode -> Html Msg
firstSelectedPanel node =
  div [] [ text "Start Node: ", text node.displayText ]

bothSelectedPanel : MapNode -> MapNode -> Connector -> Html Msg
bothSelectedPanel first second c =
  div [ class "divConnectorCreation" ] [ 
    div [] [ span [ class "propName" ] [ text "Start: " ], 
      span [ class "propValue" ] [ text first.displayText ] ]
    ,div [] [ span [ class "propName" ] [ text "Exit: " ], 
      span [ class "propValue" ] [ select [ onInput (\x -> (CreateConnector (ExitChanged (stringToSide x))))] (getSideOptions c.exitSide) ] ]
    ,div [] [ span [ class "propName" ] [ text "End: " ], 
      span [ class "propValue" ] [ text second.displayText ] ]
    ,div [] [ span [ class "propName" ] [ text "Enter: " ], 
      span [ class "propValue" ] [ select [ onInput (\x -> (CreateConnector (EnterChanged (stringToSide x))))] (getSideOptions c.entrySide) ] ]
    ,div [] [ button [ onClick (CreateConnector FinishConnector) ] [ text "Create Connector" ] ] 
  ]

nodeConnectorList : MapNode -> List (Html Msg)
nodeConnectorList node =
  node.connectors
  |> List.map (\x -> li [] [ 
    text node.displayText
    ,text (getSideText x.exitSide)
    ,text (" " ++ (getSideText x.entrySide) ++ " " )
    ])

getSideOptions : Side -> List (Html Msg)
getSideOptions side = 
  [
    option ((value "Top")::(getOptionAttrs side "Top")) [ text "Top" ]
    ,option [ value "Bottom" ] [ text "Bottom" ]
    ,option [ value "Left" ] [ text "Left" ]
    ,option [ value "Right" ] [ text "Right" ]
  ]

getOptionAttrs : Side -> String -> List (Attribute Msg)
getOptionAttrs side value =
  case (toString side) == value of
    True -> [ selected True ]
    False -> []


stringToSide : String -> Side
stringToSide s = 
  case s of
    "Top" -> Top
    "Bottom" -> Bottom
    "Left" -> Left
    "Right" -> Right
    _ -> Top

getSideText : Side -> String
getSideText side = 
  case side of
    Top -> "^"
    Bottom -> "v"
    Left -> "->"
    Right -> "<-"
