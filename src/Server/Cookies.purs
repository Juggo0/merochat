module Server.Cookies where

import Prelude

import Browser.Cookies.Data (Cookie(..), CookieOpts(..), SameSite(..), SetCookie(..))
import Browser.Cookies.Data as BC
import Data.JSDate as DJ
import Data.Maybe (Maybe(..))
import Data.Newtype as DN
import Data.Tuple (Tuple(..))
import Server.Effect (ServerEffect)
import Shared.Options.Domain (domain)
import Environment (production)

cookieHeader ∷ String
cookieHeader = "Set-Cookie"

makeCookieHeader ∷ String → ServerEffect (Tuple String String)
makeCookieHeader = pure <<< Tuple cookieHeader <<< BC.encode <<< makeCookie

makeExpiredCookieHeader ∷ Tuple String String
makeExpiredCookieHeader = Tuple cookieHeader $ BC.encode expiredCookie
      where
      expiredCookie ∷ SetCookie
      expiredCookie = DN.over SetCookie expire $ makeCookie ""
      expire cookie = cookie
            { opts = map update' cookie.opts
            }

      update' ∷ CookieOpts → CookieOpts
      update' = DN.over CookieOpts update
      update cookie = cookie
            { maxAge = Nothing
            , expires = Just $ DJ.jsdate
                    { day: 1.0
                    , hour: 1.0
                    , millisecond: 1.0
                    , minute: 1.0
                    , month: 1.0
                    , second: 1.0
                    , year: 1900.0
                    }
            }

cookieName ∷ String
cookieName = "merochat"

makeCookie ∷ String → SetCookie
makeCookie value =
      SetCookie
            { cookie: Cookie { key: cookieName, value }
            , opts: Just $ CookieOpts
                    { maxAge: Just 34560000.0
                    , expires: Nothing
                    , httpOnly: true
                    , samesite: if production then Just Strict else Nothing
                    , domain: if production then Just domain else Nothing
                    , path: Just "/"
                    , secure: production
                    }
            }