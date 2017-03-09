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
            div [ class "divLeftPanel" ] [ 
                div [] [
                    text "Map Nodes"
                    ,button [ onClick (ChangeMode Create) ] [ text "Add" ]
                    ,button [ onClick (AddConnector 5) ] [ text "Connect" ] ]
                ,div [] (List.map (\x -> 
                    div (getLeftPanelNodeAttributes model x SelectNode) 
                        [text (x.displayText ++ " | x: " ++ (toString x.px) ++ " y: " ++ (toString x.py))]) model.nodes) 
                , debugPanel model
            ]
            ,div [ class "divRightPanel" ] [ getSvgPanel model, getPropertyPanel model ]
        ] 
    ]
