{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

import BasicPrelude hiding (FilePath)
import Shelly

readAndEx :: FilePath -> Sh ()
readAndEx f = do
  newText <- ("-x " <>) <$> readfile f
  writefile "parsadata_erd_args" newText
  run_ "PARSA_ERD_linux_2_6" []
  let newDir = "RNApic/pic_" <> f
  mkdir_p newDir
  ls "pic" >>= mapM_ (\file -> cp file newDir)

work :: Sh ()
work = do
  files <- ((<> "RNAfiles") <$> pwd) >>= ls
  mapM_ readAndEx files

main :: IO ()
main = shelly work
