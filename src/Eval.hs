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

eval :: Instruction -> String
eval (Location s) = to16BitBinaryString s
eval (C d c j) = "111" ++ (evalC c) ++ (evalC d) ++ (evalC j)
eval (Symbol s) = s
eval _ = ""

evalC :: CPart -> String
evalC (Destination "M")   = "001"
evalC (Destination "D")   = "010"
evalC (Destination "MD")  = "011"
evalC (Destination "A")   = "100"
evalC (Destination "AM")  = "101"
evalC (Destination "AD")  = "110"
evalC (Destination "AMD") = "111"
evalC (Destination "")    = "000"
evalC (Computation "0")   = "0101010"
evalC (Computation "1")   = "0111111"
evalC (Computation "-1")  = "0111010"
evalC (Computation "D")   = "0001100"
evalC (Computation "A")   = "0110000"
evalC (Computation "M")   = "1110000"
evalC (Computation "!D")  = "0001101"
evalC (Computation "!A")  = "0110001"
evalC (Computation "!M")  = "1110001"
evalC (Computation "-D")  = "0001111"
evalC (Computation "-A")  = "0110011"
evalC (Computation "-M")  = "1110011"
evalC (Computation "D+1") = "0011111"
evalC (Computation "A+1") = "0110111"
evalC (Computation "M+1") = "1110111"
evalC (Computation "D-1") = "0001110"
evalC (Computation "A-1") = "0110010"
evalC (Computation "M-1") = "1110010"
evalC (Computation "D+A") = "0000010"
evalC (Computation "D+M") = "1000010"
evalC (Computation "D-A") = "0010011"
evalC (Computation "D-M") = "1010011"
evalC (Computation "A-D") = "0000111"
evalC (Computation "M-D") = "1000111"
evalC (Computation "D&A") = "0000000"
evalC (Computation "D&M") = "1000000"
evalC (Computation "D|A") = "0010101"
evalC (Computation "D|M") = "1010101"
evalC (Jump "JGT")   = "001"
evalC (Jump "JEQ")   = "010"
evalC (Jump "JGE")   = "011"
evalC (Jump "JLT")   = "100"
evalC (Jump "JNE")   = "101"
evalC (Jump "JLE")   = "110"
evalC (Jump "JMP")   = "111"
evalC (Jump "")      = "000"


