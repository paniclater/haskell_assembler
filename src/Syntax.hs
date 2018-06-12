module Syntax where

import Text.Parsec

-- data CPart = Destination String  | Computation String | Jump String deriving (Show)

newtype Destination = Destination String deriving (Show)
newtype Computation = Computation String deriving (Show)
newtype Jump = Jump String deriving (Show)

data Instruction =
  C Destination Computation Jump
  | Loop String
  | Location String
  | Symbol String
  | Comment
  | EmptyLine
  | SyntaxError ParseError deriving (Show)