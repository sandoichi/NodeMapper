module MapView exposing (..)

import UIHelper exposing (..)
import MapModel exposing (..)
import MapMsg exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ 
        div [ class "divMainContainer" ] [ 
            div [ class "statusPanel" ] [
                text "Mode: ", text (toString model.actionState)
                ,text "| LastMsg: ", text (toString model.lastMsg)
            ]
            ,div [ class "divLeftPanel" ] [ 
                div [] [
                    text "Map Nodes"
                    ,button [ onClick (CreateNode Init) ] [ text "Add" ]
                    ,button [ onClick StartConnecting ] [ text "StartConnect" ] ]
                ,div [] (List.map (\x -> 
                    div (getLeftPanelNodeAttributes model x) 
                        [text (x.displayText ++ " | x: " ++ (toString x.px) ++ " y: " ++ (toString x.py))]) model.nodes) 
            ]
            ,div [ class "divRightPanel" ] [ getSvgPanel model, getPropertyPanel model ]
        ] 
    ]
