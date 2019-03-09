module Server.RegisterLogin where

import HTTPure as H
import Server.Response as R
import HTTPure(ResponseM)
import Shared.Types

register :: RegisterLogin -> ResponseM
register registration = do
	R.json "ok"

login :: RegisterLogin -> ResponseM
login registration = R.json "ok"