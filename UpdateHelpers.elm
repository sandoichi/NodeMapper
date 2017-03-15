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
