module UpdateHelpers exposing (..)

import MapModel exposing (..)
import Mouse exposing (Position)

calculatePosition : Model -> {x:Int,y:Int} -> {x:Int,y:Int}
calculatePosition model mousePos =
  let
    offSet = getOffset model mousePos in
    { x = round (toFloat (mousePos.x - offSet.x) / model.svgScale)
    ,y = round (toFloat (mousePos.y - offSet.y) / model.svgScale) }

getOffset : Model -> Position -> Position
getOffset model pos =
  case model.offSet of
    Just x -> x
    Nothing ->
      {x=pos.x - 50,y=pos.y - 50}
