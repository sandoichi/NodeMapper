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
                    div [ class "toolbarButtons" ] [
                      button [ onClick (CreateNode InitNode) ] [ text "Add" ]
                      ,button [ onClick StartConnecting ] [ text "StartConnect" ]
                      ,button [ onClick (ZoomChange 0.2) ] [ text "[ + ]" ]
                      ,button [ onClick (ZoomChange -0.2) ] [ text "[ - ]" ]
                    ]
                    ,div [ class "toolbarText" ] [ text model.toolbarText ]
                    ]
                ,getSvgPanel model ]
        ] 
    ]
