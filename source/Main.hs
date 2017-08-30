{-# LANGUAGE OverloadedStrings #-}

module Main where

import GHCJS.Marshal(fromJSVal)
import GHCJS.Foreign.Callback (Callback, syncCallback1, syncCallback1', OnBlocked(ContinueAsync))
import Data.JSString (JSString, pack)
import GHCJS.Types (JSVal, jsval)
import JavaScript.Object (create, setProp)

import Lambda
import Interpreter
import Environment
import Format
import Control.Monad.State
import Data.Maybe
import Data.List
import Text.ParserCombinators.Parsec


-- Calling Mikrokosmos from Javascript
foreign import javascript unsafe "mikrokosmos = $1"
    set_mikrokosmos :: Callback a -> IO ()

mikroCall = do
    let getHello jv = do
            Just str <- fromJSVal jv
            o <- create
            setProp "mkroutput" (jsval $ pack $ mikro str) o
            return $ jsval o

    getMikroCallback <- syncCallback1' getHello
    set_mikrokosmos getMikroCallback

main = do
    mikroCall



mikro :: String -> String
mikro = format . execute

execute :: String -> String
execute = fst . executeWithEnv librariesEnv

executeWithEnv :: Environment -> String -> (String, Environment)
executeWithEnv initEnv code = do
  let parsing = map (parse actionParser "") $ filter (/="") $ lines code
  let actions = catMaybes $ map (\x -> case x of
                             Left _  -> Nothing
                             Right a -> Just a) parsing
  case runState (multipleAct actions) initEnv of
    (outputs, env) -> (unlines outputs, env)

format :: String -> String
format = cleanlines . decolor
  where
    cleanlines = unlines . filter (/="") . lines

librariesEnv :: Environment
librariesEnv = snd $ executeWithEnv defaultEnv librariesText 

librariesText :: String
librariesText = unlines [ "id = \\x.x"
                        , "const = \\x.\\y.x"
                        , "compose = \\f.\\g.\\x.f (g x)"
                        , "true  = \\a.\\b.a"
                        , "false = \\a.\\b.b"
                        , "and = \\p.\\q.p q p"
                        , "or  = \\p.\\q.p p q"
                        , "not = \\b.b false true"
                        , "implies = \\a.\\b.or (not a) b"
                        , "ifelse = (\\x.x)"
                        , "succ = \\n.\\f.\\x.f (n f x)"
                        , "0 = \\f.\\x.x"
                        , "plus = \\m.\\n.\\f.\\x.m f (n f x)"
                        , "mult = \\m.\\n.\\f.\\x.m (n f) x"
                        , "pred  = \\n.\\f.\\x.n (\\g.(\\h.h (g f))) (\\u.x) (\\u.u)"
                        , "minus = \\m.\\n.(n pred) m"
                        , "iszero = \\n.(n (\\x.false) true)"
                        , "leq    = \\m.\\n.(iszero (minus m n))"
                        , "eq     = \\m.\\n.(and (leq m n) (leq n m))"
                        , "1 = succ 0"
                        , "2 = succ 1"
                        , "3 = succ 2"
                        , "4 = succ 3"
                        , "5 = succ 4"
                        , "6 = succ 5"
                        , "7 = succ 6"
                        , "8 = succ 7"
                        , "9 = succ 8"
                        , "10 = succ 9"
                        , "11 = succ 10"
                        , "12 = succ 11"
                        , "13 = succ 12"
                        , "14 = succ 13"
                        , "15 = succ 14"
                        , "16 = succ 15"
                        , "17 = succ 16"
                        , "18 = succ 17"
                        , "19 = succ 18"
                        , "20 = succ 19"
                        , "21 = succ 20"
                        , "22 = succ 21"
                        , "23 = succ 22"
                        , "24 = succ 23"
                        , "25 = succ 24"
                        , "26 = succ 25"
                        , "27 = succ 26"
                        , "28 = succ 27"
                        , "29 = succ 28"
                        , "30 = succ 29"
                        , "31 = succ 30"
                        , "32 = succ 31"
                        , "33 = succ 32"
                        , "34 = succ 33"
                        , "35 = succ 34"
                        , "36 = succ 35"
                        , "37 = succ 36"
                        , "38 = succ 37"
                        , "39 = succ 38"
                        , "40 = succ 39"
                        , "41 = succ 40"
                        , "42 = succ 41"
                        , "43 = succ 42"
                        , "44 = succ 43"
                        , "45 = succ 44"
                        , "46 = succ 45"
                        , "47 = succ 46"
                        , "48 = succ 47"
                        , "49 = succ 48"
                        , "50 = succ 49"
                        , "51 = succ 50"
                        , "52 = succ 51"
                        , "53 = succ 52"
                        , "54 = succ 53"
                        , "55 = succ 54"
                        , "56 = succ 55"
                        , "57 = succ 56"
                        , "58 = succ 57"
                        , "59 = succ 58"
                        , "60 = succ 59"
                        , "61 = succ 60"
                        , "62 = succ 61"
                        , "63 = succ 62"
                        , "64 = succ 63"
                        , "65 = succ 64"
                        , "66 = succ 65"
                        , "67 = succ 66"
                        , "68 = succ 67"
                        , "69 = succ 68"
                        , "70 = succ 69"
                        , "71 = succ 70"
                        , "72 = succ 71"
                        , "73 = succ 72"
                        , "74 = succ 73"
                        , "75 = succ 74"
                        , "76 = succ 75"
                        , "77 = succ 76"
                        , "78 = succ 77"
                        , "79 = succ 78"
                        , "80 = succ 79"
                        , "81 = succ 80"
                        , "82 = succ 81"
                        , "83 = succ 82"
                        , "84 = succ 83"
                        , "85 = succ 84"
                        , "86 = succ 85"
                        , "87 = succ 86"
                        , "88 = succ 87"
                        , "89 = succ 88"
                        , "90 = succ 89"
                        , "91 = succ 90"
                        , "92 = succ 91"
                        , "93 = succ 92"
                        , "94 = succ 93"
                        , "95 = succ 94"
                        , "96 = succ 95"
                        , "97 = succ 96"
                        , "98 = succ 97"
                        , "99 = succ 98"
                        , "100 = succ 99"
                        , "S = \\x.\\y.\\z. x z (y z)"
                        , "K = \\x.\\y.x"
                        , "I = S K K"
                        , "C = \\f.\\x.\\y.f y x"
                        , "B = \\f.\\g.\\x.f (g x)"
                        , "W = \\x.\\y.(y y)"
                        , "Y != \\f.(\\x.f (x x))(\\x.f (x x))"
                        , "tuple  = \\x.\\y.\\z.z x y"
                        , "first  = \\p.p true"
                        , "second = \\p.p false"
                        , "cons = \\h.\\t.\\c.\\n.(c h (t c n))"
                        , "nil = \\c.\\n.n"
                        , "foldr  = \\o.\\n.\\l.(l o n)"
                        , "fold   = \\o.\\n.\\l.(l o n)"
                        , "sum    = (foldr plus 0)"
                        , "prod   = (foldr mult (succ 0))"
                        , "length = (foldr (\\h.\\t.succ t) 0)"
                        , "map    = (\\f.(foldr (\\h.\\t.cons (f h) t) nil))"
                        , "filter = \\p.(foldr (\\h.\\t.((p h) (cons h t) t)) nil)"
                        , "node = \\x.\\l.\\r.\\f.\\n.(f x (l f n) (r f n))"
                        , "omega != (\\x.(x x))(\\x.(x x))"
                        , "fix != (\\f.(\\x.f (x x)) (\\x.f (x x)))"
                        , "fact != fix (\\f.\\n.iszero n (succ 0) (mult n (f (pred n))))"
                        , "fib != fix (\\f.\\n.iszero n (succ 0) (plus (f (pred n)) (f (pred (pred n)))))"
                        , "pair = \\x.\\y.(x,y)"
                        , "fst = \\x.FST x"
                        , "snd = \\x.SND x"
                        , "inl = \\x.INL x"
                        , "inr = \\x.INR x"
                        , "caseof = \\x.\\y.\\z.CASE x OF y;z"
                        , "unit = UNIT"
                        , "abort = \\x.ABORT x"
                        , "absurd = \\x.ABSURD x"
                        ]
