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
                div [] [ text "Map Nodes" ]
                ,div [] (List.map (\x -> 
                    div (getLeftPanelNodeAttributes model x) [ text x.displayText ]) model.nodes) 
                ,getPropertyPanel model
            ]
            ,div [ class "divRightPanel" ] [ 
                div [ class "toolbar" ] [
                    button [ onClick (CreateNode InitNode) ] [ text "Add" ]
                    ,button [ onClick StartConnecting ] [ text "StartConnect" ]
                    ]
                ,getSvgPanel model ]
        ] 
    ]
