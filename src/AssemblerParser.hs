module AssemblerParser (
  runParse
) where

import Text.Parsec
import Text.Parsec.String

import Syntax
-- "+M;JMP"
parseDestination :: Parser Destination
parseDestination = do
  d <- many1 (oneOf "ADM")
  char '='
  return (Destination d)

parseJump :: Parser Jump
parseJump = do
  char ';'
  j <- many1 (oneOf "JMPGTEQLN")
  return (Jump j)

parseComputation :: Parser Computation
parseComputation = do
  c <- many1 (oneOf "ADM+-10|!&")
  return (Computation c)

parseInstruction :: Parser Instruction
parseInstruction = do
  d <- (try parseDestination) <|> return (Destination "")
  c <- parseComputation
  j <- parseJump <|> return (Jump "")
  return (C d c j)

parseLocation :: Parser Instruction
parseLocation = do
  l <- many1 digit
  return (Location l)

parseSymbol :: Parser Instruction
parseSymbol = do
  v <- many1 (alphaNum <|> oneOf "$._")
  return (Symbol v)

parseAddress :: Parser Instruction
parseAddress = char '@' >> (parseLocation <|> parseSymbol)

parseLoop :: Parser Instruction
parseLoop = do
  char '('
  l <- many (noneOf ")")
  char ')'
  return (Loop l)

parseComment :: Parser Instruction
parseComment = do
  char '/'
  char '/'
  many (anyChar)
  return Comment

parseLine :: Parser Instruction
parseLine = do
  spaces
  parseLoop <|> parseAddress <|> parseInstruction <|> parseComment <|> return EmptyLine

runParse :: String -> Instruction
runParse line = do
  let res = parse parseLine "" line
  case res of
    Left err -> SyntaxError err
    Right val -> val