module UIHelper exposing (..)

import MapNode exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)
import MapSvg exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

getPropertyPanel : Model -> Html Msg
getPropertyPanel model = 
    case model.editMode of
        Normal ->
            case model.selectedNode of
                Just x -> propertyPanelSelectedNode x
                Nothing -> propertyPanelNormal
        Create ->
            propertyPanelCreate model

getLeftPanelNodeAttributes : Model -> MapNode -> (MapNode -> Msg) -> List (Attribute Msg)
getLeftPanelNodeAttributes model node clickMsg =
    case model.selectedNode of
        Just selectedNode ->
            case selectedNode.id == node.id of
                True -> 
                    [ onClick (SelectNode node), class "selectedNodeListDiv" ]
                False ->
                    [ onClick (SelectNode node), class "nodeListDiv" ]
        Nothing -> [ onClick (SelectNode node), class "nodeListDiv" ]

createButton : Html Msg
createButton = button [ onClick CreateNode ] [ text "Create Node" ]

propertyPanelNormal : Html Msg 
propertyPanelNormal = 
    div [ class "divPropertyPanel" ] [ 
        text "Property Panel"
        ,button [ onClick (ChangeMode Create) ] [ text "Add Node" ] ]

propertyPanelSelectedNode : MapNode -> Html Msg 
propertyPanelSelectedNode node = 
    div [ class "divPropertyPanel" ] [ 
            div [] [ 
                span [ class "propName" ] [ text "Id: "]
                ,span [ class "propValue" ] [ text (toString node.id) ] ]
            ,div [] [ 
                span [ class "propName" ] [ text "DisplayText: "]
                ,span [ class "propValue" ] [ text node.displayText ] ]
        ]

propertyPanelCreate : Model -> Html Msg 
propertyPanelCreate model = div [ class "divPropertyPanel" ] [ 
        div [] [ text "Id: ", text (toString ((List.length model.nodes)+1)) ]
        ,div [ onInput (\x -> PanelEvent (DisplayTxt x)) ] [ text "Display Text: ", input [ placeholder "Display Txt" ] [] ]
        ,createButton 
    ]

debugPanel : Model -> Html Msg
debugPanel model =
    div [ class "debugPanel" ] [
        div [] [ text "editMode", text (toString model.editMode) ]
        ,div [] [ text "selectedNode", text (toString model.selectedNode) ]
        ,div [] [ text "selectedNode2", text (toString model.selectedNode2) ]
        ,div [] [ text "dragNode", text (toString model.dragNode) ]
        ,div [] [ text "offset", text (toString model.offSet) ]
    ]

getSvgPanel : Model -> Html Msg 
getSvgPanel model = div [ class "divSvgPanel" ] [ 
        genSvg model.nodes model 
    ] 

