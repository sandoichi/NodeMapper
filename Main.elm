module Main exposing (..)

import MapMsg exposing (..)


import Html exposing (..)
import Html.Attributes exposing (..)
import MapModel exposing (..)
import MapView exposing (..)
import Update exposing (..)
import Mouse exposing (Position)

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  case model.dragNode of
    False ->
      Sub.none

    True ->
      Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]

