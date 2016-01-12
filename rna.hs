{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

import BasicPrelude hiding (FilePath)
import Shelly

readAndEx :: FilePath -> Sh ()
readAndEx f = do
  let f' = toTextIgnore f
  newText <- ("-x " <>) <$> readfile f
  writefile "parsadata_erd_args" newText
  output <- run "./PARSA_ERD_linux_2_6" []
  let newDir = fromText $ "RNApic/pic_" <> f'
  mkdir_p newDir
  ls "pic" >>= mapM_ (\file -> cp file newDir)
  writefile (newDir <> (fromText $ "parsa_output_" <> f')) output

work :: Sh ()
work = ((<> "RNAfiles") <$> pwd) >>= ls >>= mapM_ readAndEx

main :: IO ()
main = shelly work
