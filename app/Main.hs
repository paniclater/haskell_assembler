module Main where

import qualified Data.Map.Strict as StrictMap

import AST
import AssemblerParser
import Eval

getMemoryLocation :: ([Instruction], StrictMap.Map String Integer, Integer) -> Instruction -> ([Instruction], (StrictMap.Map String Integer), Integer)
getMemoryLocation (instructions, symbols, freeAddress) (Symbol key) =
  let found = StrictMap.lookup key symbols
  in case found of
      Just address -> ((Location $ show address):instructions, symbols, freeAddress)
      Nothing -> ((Location $ show freeAddress):instructions, StrictMap.insert key freeAddress symbols, freeAddress + 1)
getMemoryLocation (instructions, symbols, freeAddress) i = (i:instructions, symbols, freeAddress)

addLoopSymbol :: (StrictMap.Map String Integer, Integer) -> Instruction -> (StrictMap.Map String Integer, Integer)
addLoopSymbol (symbols, count) (Loop l) = (StrictMap.insert l (count + 1) symbols, count)
addLoopSymbol (symbols, count) (Instruction _ _ _) = (symbols, count + 1)
addLoopSymbol (symbols, count) (Location _) = (symbols, count + 1)
addLoopSymbol (symbols, count) (Symbol _) = (symbols, count + 1)
addLoopSymbol (symbols, count) _ = (symbols, count)

processText :: String -> String
-- there's got to be a better way to strip out ""
processText t =
  unlines $ reverse $ filter (\s -> s /= "") $ map eval $ withSymbols $ parsedLines
    where
      parsedLines = map runParse $ lines t
      predefinedSymbols = StrictMap.fromList [("SP", 0), ("LCL", 1), ("ARG", 2), ("THIS", 3), ("THAT", 4), ("R0", 0), ("R1", 1), ("R2", 2), ("R3", 3), ("R4", 4), ("R5", 5), ("R6", 6), ("R7", 7), ("R8", 8), ("R9", 9), ("R10", 10), ("R11", 11), ("R12", 12), ("R13", 13), ("R14", 14), ("R15", 15), ("SCREEN", 16384), ("KBD", 24576)]
      (symbols, _) = foldl addLoopSymbol (predefinedSymbols, -1) parsedLines
      withSymbols instructions = symbolized
        where
          (symbolized, _, _) = foldl getMemoryLocation ([], symbols, 16) instructions

main :: IO ()
main = do
  contents <- fmap processText $ readFile "assemblies/Max.asm"
  writeFile "MaxL.hack" contents