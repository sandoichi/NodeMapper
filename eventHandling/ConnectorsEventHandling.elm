module ConnectorsEventHandling exposing (..)

import Connectors exposing (..)

updatePDConnector : UIPanelData -> (Connector -> Connector) -> UIPanelData
updatePDConnector pd f =
  { pd | connector = f pd.connector }

updateExit : Side -> Connector -> Connector
updateExit side con =
  { con | exitSide = side }

updateEntry : Side -> Connector -> Connector
updateEntry side con =
  { con | entrySide = side }

updateCost : Int -> Connector -> Connector
updateCost cost con =
  { con | cost = cost }
