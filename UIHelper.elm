module UIHelper exposing (..)

import MapNode exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)
import MapSvg exposing (..)
import ConnectorUI exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

getPropertyPanel : Model -> Html Msg
getPropertyPanel model = 
  case model.actionState of
    InspectingNode x  -> propertyPanelSelectedNode x
    CreatingNode -> propertyPanelCreate model.nodeData.node
    ConnectingNodes x -> getNodeConnectionPanel model
    _ -> propertyPanelNormal

getSidePanelNodeAttributes : Model -> MapNode -> List (Attribute Msg)
getSidePanelNodeAttributes model node =
  [ onClick (InspectNode node)
  , class (case model.actionState of
    InspectingNode x ->
      case x.id == node.id of
        True -> "selectedNodeListDiv"
        False -> "nodeListDiv"
    _ -> "nodeListDiv") ]

createButton : Html Msg
createButton = button [ onClick (CreateNode FinishNode)] [ text "Create Node" ]

propertyPanelNormal : Html Msg 
propertyPanelNormal = 
  div [ class "divPropertyPanel" ] [ text "Property Panel" ]

propertyPanelSelectedNode : MapNode -> Html Msg 
propertyPanelSelectedNode node = 
  div [ class "divPropertyPanel" ] [ 
    div [] [ 
      span [ class "propName" ] [ text "Id: "]
        ,span [ class "propValue" ] [ text (toString node.id) ] ]
      ,div [] [ 
        span [ class "propName" ] [ text "DisplayText: "]
        ,span [ class "propValue" ] [ text node.displayText ] ]
      ,div [] [ 
        span [ class "propName" ] [ text "Connectors : "]
        ,span [ class "propValue" ] [ ul [] (ConnectorUI.nodeConnectorList node) ] ]
        ]

propertyPanelCreate : MapNode -> Html Msg 
propertyPanelCreate node = div [ class "divPropertyPanel" ] [ 
  div [] [ text "Id: ", text (toString node.id) ]
  ,div [ onInput (\x -> CreateNode (DisplayTxt x)) ] [ text "Display Text: ", input [ placeholder "Display Txt" ] [] ]
  ,createButton 
  ]

getSvgPanel : Model -> Html Msg 
getSvgPanel model = div [ class "divSvgPanel" ] [ 
  genSvg model.nodes model 
  ] 

