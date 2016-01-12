{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ViewPatterns #-}

import BasicPrelude hiding (FilePath)
import qualified Data.Text as T
import Shelly

---

isHidden :: FilePath -> Bool
isHidden = (== '.') . T.head . justTheFile

justTheFile :: FilePath -> Text
justTheFile (toTextIgnore -> f) = last $ T.splitOn "/" f

readAndEx :: FilePath -> Sh ()
readAndEx f = do
  let f' = justTheFile f
  putStrLn $ "EMRE: Working with file: " <> f'
  newText <- ("-x " <>) <$> readfile f
  writefile "parsadata_erd_args" newText
  output <- run "./PARSA_ERD_linux_2_6" []
  let newDir = fromText $ "RNApic/pic_" <> f'
  mkdir_p newDir
  ls "pic" >>= mapM_ (\file -> cp file newDir)
  writefile (newDir <> (fromText $ "parsa_output_" <> f')) output
  putStrLn "Done!"

work :: Sh ()
work = ((<> "RNAfiles") <$> pwd) >>= ls >>= f >>= mapM_ readAndEx
  where f = pure . filter (not . isHidden)

main :: IO ()
main = shelly work
