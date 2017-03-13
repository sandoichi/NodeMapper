module UpdateHelpers exposing (..)

import MapModel exposing (..)
import Mouse exposing (Position)

calculatePosition : {x:Int,y:Int} -> Maybe {x:Int,y:Int} -> {x:Int,y:Int}
calculatePosition mousePos offSet =
  case offSet of 
    Just off ->
      {x = mousePos.x - off.x, y = mousePos.y - off.y}
    Nothing ->
      {x = mousePos.x, y = mousePos.y}

getOffset : Model -> Position -> Position
getOffset model pos =
  case model.offSet of
    Just x -> x
    Nothing -> {x=pos.x,y=pos.y}
