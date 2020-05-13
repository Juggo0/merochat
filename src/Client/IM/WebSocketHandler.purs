module Client.IM.WebSocketHandler where

import Shared.JSON as SJ
import Web.Socket.WebSocket as WSW
import Client.Common.Types
import Prelude

webSocketHandler :: WebSocketHandler
webSocketHandler = { sendPayload: \ws -> WSW.sendString ws <<< SJ.toJSON }