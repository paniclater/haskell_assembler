module AST
    ( C(..), Instruction(..)
    ) where

import Text.Parsec

data C = Destination String  | Computation String | Jump String deriving (Show)
data Instruction = Instruction C C C | Loop String | Location String | Symbol String | Comment | EmptyLine | SyntaxError ParseError deriving (Show)



