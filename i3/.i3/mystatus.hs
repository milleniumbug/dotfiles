-- sudo cabal install aeson bytestring json-stream

{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Aeson as JS
import qualified Data.Aeson.Types as JST
import Data.Maybe (maybeToList)
import Data.Aeson ((.:), (.:?), (.=))
import qualified Data.Text.Lazy as T
import Data.Text.Lazy.Encoding as E
import qualified Control.Monad as M
import qualified Data.JsonStream.Parser as JSPar
import Data.Text.Lazy (Text(..))
import qualified System.IO as IO
import Data.Foldable (forM_)
import qualified System.Process as Pr
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Char8 as B8
import Data.ByteString.Lazy (ByteString(..))
import Control.Applicative ((<$>), (<*>))

data Entry = Entry {
	name :: Maybe Text,
	color :: Maybe Text,
	inst  :: Maybe Text,
	full_text :: Text,
	short_text :: Maybe Text,
	min_width :: Maybe Int,
	align :: Maybe Text,
	urgent :: Maybe Text,
	separator :: Maybe Bool,
	separator_block_width :: Maybe Int
} deriving Show

instance JS.FromJSON Entry where
	parseJSON (JS.Object v) = Entry <$>
		v .:? "name" <*>
		v .:? "color" <*>
		v .:? "instance" <*>
		v .: "full_text" <*>
		v .:? "short_text" <*>
		v .:? "min_width" <*>
		v .:? "align" <*>
		v .:? "urgent" <*>
		v .:? "separator" <*>
		v .:? "separator_block_width"
	parseJSON _ = M.mzero

listentryT :: JS.ToJSON b => (a -> b) -> T.Text -> a -> JST.Pair
listentryT t name value = (T.toStrict name) .= (t value)

optentryT :: JS.ToJSON b => (a -> b) -> T.Text -> Maybe a -> [JST.Pair]
optentryT t name value = maybeToList $ (listentryT t name) <$> value

instance JS.ToJSON Entry where
	toJSON entry = JS.object $
		(optentryT T.toStrict "full_text" $ Just $ full_text entry) ++
		(optentryT T.toStrict "name" $ name entry) ++
		(optentryT T.toStrict "color" $ color entry) ++
		(optentryT T.toStrict "instance" $ inst entry) ++
		(optentryT T.toStrict "short_text" $ short_text entry) ++
		(optentryT id "min_width" $ min_width entry) ++
		(optentryT T.toStrict "align" $ align entry) ++
		(optentryT T.toStrict "urgent" $ urgent entry) ++
		(optentryT id "separator" $ separator entry) ++
		(optentryT id "separator_block_width" $ separator_block_width entry)

defaultEntry :: Text -> Entry
defaultEntry ft = Entry Nothing Nothing Nothing ft Nothing Nothing Nothing Nothing Nothing Nothing

main :: IO ()
main = do
	(_, i, _, _) <- Pr.runInteractiveProcess "i3status" [] Nothing Nothing
	ver <- B8.hGetLine i
	B8.putStrLn ver
	B8.putStrLn "["
	o <- B.hGetContents i
	forM_ (JSPar.parseLazyByteString (JSPar.arrayOf JSPar.value) o :: [[Entry]]) $ \x -> do
		(_, xmms2res, _, pid) <- Pr.runInteractiveProcess "xmms2" ["current"] Nothing Nothing
		currently_playing <- E.decodeUtf8 <$> B.hGetContents xmms2res
		_ <- Pr.waitForProcess pid
		B.putStr $ JS.encode $ (defaultEntry $ T.filter (/= '\n') currently_playing){name = Just "xmms2"} : x
		B8.putStrLn ","
		IO.hFlush IO.stdout
