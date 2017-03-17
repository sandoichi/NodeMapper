module UpdateHelpers exposing (..)

import MapModel exposing (..)
import Mouse exposing (Position)

calculatePosition : Model -> {x:Int,y:Int} -> {x:Int,y:Int}
calculatePosition model mousePos =
    { x = round (toFloat (mousePos.x - (getOffSet model)) / model.svgScale)
    ,y = round (toFloat (mousePos.y - (getOffSet model)) / model.svgScale) }

getOffSet : Model -> Int
getOffSet model =
  round (toFloat model.nodeSize / 2)

getSvgPos : Model -> {x:Int,y:Int} -> {x:Int,y:Int}
getSvgPos model mousePos = 
  let
    adjustedPos = calculatePosition model mousePos in 
  { x = model.panData.svgPos.x - (adjustedPos.x - model.panData.panStart.x)
  , y = model.panData.svgPos.y - (adjustedPos.y - model.panData.panStart.y) }
