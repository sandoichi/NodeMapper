module UpdateHelpers exposing (..)

import MapModel exposing (..)
import Mouse exposing (Position)

calculateNodeClickPosition : Model -> {x:Int,y:Int} -> {x:Int,y:Int}
calculateNodeClickPosition model mousePos =
  let
    fx = toFloat (mousePos.x + (divideByScale model model.panData.svgPos.x) ) / model.svgScale
    fy = toFloat (mousePos.y + (divideByScale model model.panData.svgPos.y) ) / model.svgScale
  in
    { x = round fx, y = round fy }

calculatePanPosition : Model -> {x:Int,y:Int} -> {x:Int,y:Int}
calculatePanPosition model mousePos =
    {x = round (toFloat (mousePos.x) / model.svgScale)
    ,y = round (toFloat (mousePos.y) / model.svgScale) }

divideByScale : Model -> Int -> Int
divideByScale model coord =
  round (toFloat coord / model.svgScale) 

getOffSet : Model -> Int
getOffSet model =
  round (toFloat model.nodeSize / 2)

getSvgPos : Model -> {x:Int,y:Int} -> {x:Int,y:Int}
getSvgPos model mousePos = 
  let
    adjustedPos = calculatePanPosition model mousePos in 
  { x = model.panData.svgPos.x - (adjustedPos.x - model.panData.panStart.x)
  , y = model.panData.svgPos.y - (adjustedPos.y - model.panData.panStart.y) }
