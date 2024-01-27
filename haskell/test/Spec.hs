module Main where

import           Test.Hspec

spec :: Spec
spec = do
  describe "Basic tests" $ do
    it "fails" $ 1 `shouldBe` 0

main :: IO ()
main = hspec spec

