module Eval
    (
      eval
    ) where

import Numeric
import Data.Char

import Syntax

to16BitBinaryString :: String -> String
to16BitBinaryString x = pad $ showIntAtBase 2 intToDigit (read x) ""
  where
    pad s
      | (length s < 16) = pad ("0" ++ s)
      | otherwise         = s

d = Destination "d"

eval :: Instruction -> String
eval (Location s) = to16BitBinaryString s
eval (C d c j) = "111" ++ (evalComputation c) ++ (evalDestination d) ++ (evalJump j)
eval (Symbol s) = s
eval _ = ""

evalDestination :: Destination -> String
evalDestination (Destination "M")   = "001"
evalDestination (Destination "D")   = "010"
evalDestination (Destination "MD")  = "011"
evalDestination (Destination "A")   = "100"
evalDestination (Destination "AM")  = "101"
evalDestination (Destination "AD")  = "110"
evalDestination (Destination "AMD") = "111"
evalDestination (Destination "")    = "000"

evalComputation :: Computation -> String
evalComputation (Computation "0")   = "0101010"
evalComputation (Computation "1")   = "0111111"
evalComputation (Computation "-1")  = "0111010"
evalComputation (Computation "D")   = "0001100"
evalComputation (Computation "A")   = "0110000"
evalComputation (Computation "M")   = "1110000"
evalComputation (Computation "!D")  = "0001101"
evalComputation (Computation "!A")  = "0110001"
evalComputation (Computation "!M")  = "1110001"
evalComputation (Computation "-D")  = "0001111"
evalComputation (Computation "-A")  = "0110011"
evalComputation (Computation "-M")  = "1110011"
evalComputation (Computation "D+1") = "0011111"
evalComputation (Computation "A+1") = "0110111"
evalComputation (Computation "M+1") = "1110111"
evalComputation (Computation "D-1") = "0001110"
evalComputation (Computation "A-1") = "0110010"
evalComputation (Computation "M-1") = "1110010"
evalComputation (Computation "D+A") = "0000010"
evalComputation (Computation "D+M") = "1000010"
evalComputation (Computation "D-A") = "0010011"
evalComputation (Computation "D-M") = "1010011"
evalComputation (Computation "A-D") = "0000111"
evalComputation (Computation "M-D") = "1000111"
evalComputation (Computation "D&A") = "0000000"
evalComputation (Computation "D&M") = "1000000"
evalComputation (Computation "D|A") = "0010101"
evalComputation (Computation "D|M") = "1010101"

evalJump :: Jump -> String
evalJump (Jump "JGT")   = "001"
evalJump (Jump "JEQ")   = "010"
evalJump (Jump "JGE")   = "011"
evalJump (Jump "JLT")   = "100"
evalJump (Jump "JNE")   = "101"
evalJump (Jump "JLE")   = "110"
evalJump (Jump "JMP")   = "111"
evalJump (Jump "")      = "000"


