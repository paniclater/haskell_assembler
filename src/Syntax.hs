module Syntax
    ( CPart(..), Instruction(..)
    ) where

import Text.Parsec

data CPart = Destination String  | Computation String | Jump String deriving (Show)
data Instruction =
  C CPart CPart CPart
  | Loop String
  | Location String
  | Symbol String
  | Comment
  | EmptyLine
  | SyntaxError ParseError deriving (Show)