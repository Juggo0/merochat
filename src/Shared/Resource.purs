module Shared.Resource where

import Prelude

import Data.Either (Either(..))
import Data.Either as DE
import Data.HashMap (HashMap)
import Data.HashMap as DH
import Data.Tuple (Tuple(..))
import Environment (production)

allowedMediaTypes ∷ HashMap String String
allowedMediaTypes = DH.fromFoldable [ Tuple "data:image/png;base64" ".png", Tuple "data:image/jpeg;base64" ".jpg", Tuple "data:image/tiff;base64" ".tiff", Tuple "data:image/bmp;base64" ".bmp" ]

base ∷ Int
base = 500

maxImageSize ∷ Int
maxImageSize = base * 1024

maxImageSizeKB ∷ String
maxImageSizeKB = show base <> " KB"

productionBasePath ∷ String
productionBasePath = "https://static.mero.chat/file/ourmelon/"

developmentImageBasePath ∷ String
developmentImageBasePath = "/client/media/"

developmentJsBasePath ∷ String
developmentJsBasePath = "/client/javascript/"

developmentCssBasePath ∷ String
developmentCssBasePath = "/client/css/"

uploadFolder ∷ String
uploadFolder = "upload/"

bundleFolder ∷ String
bundleFolder = "bundle/"

data ResourceType = Css | Js | Png | Ico | Included

derive instance Eq ResourceType

data Bundle
      = Common
      | Emoji
      | Experiments
      | Backer
      | Base
      | External
      | Help
      | Im
      | InternalHelp
      | Landing
      | Feedback
      | KarmaPrivileges
      | Login
      | Profile
      | Recover
      | Settings

data Media
      = Logo3Small
      | LogoSmall
      | Logo
      | Favicon
      | Favicon1
      | Favicon2
      | Favicon3
      | Favicon4
      | Favicon5
      | Favicon6
      | Favicon7
      | Favicon8
      | Favicon9
      | Favicon10
      | Favicon10Plus
      | Loading
      | Point1
      | Point2
      | Point3
      | Point4
      | Point5
      | Point6
      | Point7
      | Works1
      | Works2
      | Works3
      | Avatar1
      | Avatar2
      | Avatar3
      | Avatar4
      | Avatar5
      | Avatar6
      | Avatar7
      | Avatar8
      | NicolasCageHiclipart
      | SocratesStingWikimedia
      | BatmanNounProjectAnushaNarvekar
      | Upload String

bundlePath ∷ Bundle → ResourceType → String
bundlePath b = resourcePath (Right b)

mediaPath ∷ Media → ResourceType → String
mediaPath b = resourcePath (Left b)

resourcePath ∷ Either Media Bundle → ResourceType → String
resourcePath res tp = path <> named <> replaced <> resourceType tp
      where
      named = resourceName res
      replaced = DE.either (const "") (flip replacement tp) res

      path
            | production =
                    if tp == Js || tp == Css then
                          productionBasePath <> bundleFolder
                    else
                          case res of
                                Left (Upload _) → productionBasePath <> uploadFolder
                                _ → productionBasePath
            | otherwise = case tp of
                    Js → developmentJsBasePath
                    Css → developmentCssBasePath
                    _ → case res of
                          Left (Upload _) → developmentImageBasePath <> uploadFolder
                          _ → developmentImageBasePath

uploadedImagePath ∷ String
uploadedImagePath = (if production then productionBasePath else developmentImageBasePath) <> uploadFolder

resourceName ∷ Either Media Bundle → String
resourceName = case _ of
      Right Common → "common"
      Right Emoji → "emoji"
      Right Experiments → "experiments"
      Right Backer → "backer"
      Right Base → "base"
      Right External → "external"
      Right Help → "help"
      Right Im → "im"
      Right InternalHelp → "internalHelp"
      Right Feedback → "feedback"
      Right Landing → "landing"
      Right KarmaPrivileges → "karmaPrivileges"
      Right Login → "login"
      Right Profile → "profile"
      Right Recover → "recover"
      Right Settings → "settings"
      Left Logo3Small → "logo-3-small"
      Left LogoSmall → "logo-small"
      Left Logo → "logo"
      Left Favicon → "favicon"
      Left Favicon1 → "favicon-1"
      Left Favicon2 → "favicon-2"
      Left Favicon3 → "favicon-3"
      Left Favicon4 → "favicon-4"
      Left Favicon5 → "favicon-5"
      Left Favicon6 → "favicon-6"
      Left Favicon7 → "favicon-7"
      Left Favicon8 → "favicon-8"
      Left Favicon9 → "favicon-9"
      Left Favicon10 → "favicon-10"
      Left Favicon10Plus → "favicon-10-plus"
      Left Loading → "loading"
      Left Point1 → "point1"
      Left Point2 → "point2"
      Left Point3 → "point3"
      Left Point4 → "point4"
      Left Point5 → "point5"
      Left Point6 → "point6"
      Left Point7 → "point7"
      Left Works1 → "works1"
      Left Works2 → "works2"
      Left Works3 → "works3"
      Left Avatar1 → "avatar-1"
      Left Avatar2 → "avatar-2"
      Left Avatar3 → "avatar-3"
      Left Avatar4 → "avatar-4"
      Left Avatar5 → "avatar-5"
      Left Avatar6 → "avatar-6"
      Left Avatar7 → "avatar-7"
      Left Avatar8 → "avatar-8"
      Left NicolasCageHiclipart → "nicolas_cage_hiclipart"
      Left SocratesStingWikimedia → "socrates_Sting_wikimedia"
      Left BatmanNounProjectAnushaNarvekar → "batman_noun_project_Anusha_Narvekar"
      Left (Upload up) → up

resourceType ∷ ResourceType → String
resourceType = case _ of
      Js → ".bundle.js"
      Css → ".css"
      Png → ".png"
      Ico → ".ico"
      Included → ""

replacement ∷ Bundle → ResourceType → String
replacement bundle tp
      | production =
              case bundle of -- for production we replace this with the actual file content hash, so it has to be hardcoded and must match the resource name
                    Common → reps ".[common-js-contenthash]" ".[common-css-contenthash]"
                    Emoji → reps ".[emoji-js-contenthash]" ".[emoji-css-contenthash]"
                    Experiments → reps ".[experiments-js-contenthash]" ".[experiments-css-contenthash]"
                    Backer → reps ".[backer-js-contenthash]" ".[backer-css-contenthash]"
                    Base → reps ".[base-js-contenthash]" ".[base-css-contenthash]"
                    External → reps ".[external-js-contenthash]" ".[external-css-contenthash]"
                    Help → reps ".[help-js-contenthash]" ".[help-css-contenthash]"
                    Im → reps ".[im-js-contenthash]" ".[im-css-contenthash]"
                    Feedback → reps ".[feedback-js-contenthash]" ".[feedback-css-contenthash]"
                    InternalHelp → reps ".[internalHelp-js-contenthash]" ".[internalHelp-css-contenthash]"
                    Landing → reps ".[landing-js-contenthash]" ".[landing-css-contenthash]"
                    KarmaPrivileges → reps ".[karmaPrivileges-js-contenthash]" ".[karmaPrivileges-css-contenthash]"
                    Login → reps ".[login-js-contenthash]" ".[login-css-contenthash]"
                    Profile → reps ".[profile-js-contenthash]" ".[profile-css-contenthash]"
                    Recover → reps ".[recover-js-contenthash]" ".[recover-css-contenthash]"
                    Settings → reps ".[settings-js-contenthash]" ".[settings-css-contenthash]"
              where
              reps js css = if tp == Js then js else css
      | otherwise = ""

updateHash ∷ String
updateHash = replacement Common Js <> replacement Im Js <> replacement Im Css <> replacement Profile Js <> replacement Experiments Js <> replacement Settings Js