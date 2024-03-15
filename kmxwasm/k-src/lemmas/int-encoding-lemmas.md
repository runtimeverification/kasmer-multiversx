```k
requires "../ceils-syntax.k"
requires "wasm-semantics/data.md"

module INT-ENCODING-BASIC
  imports INT
  imports BOOL
  imports WASM-DATA-COMMON

  syntax Int ::= int64encoding(
      value: Int,
      byte8Position: Int,
      byte7osition: Int,
      byte6Position: Int,
      byte5Position: Int,
      byte4Position: Int,
      byte3Position: Int,
      byte2Position: Int,
      byte1Position: Int
  )  [function, total]
  rule int64encoding(_, -1, -1, -1, -1, -1, -1, -1, -1) => 0
  rule int64encoding(A, 7, 6, 5, 4, 3, 2, 1, 0) => A
      requires 0 <=Int A andBool A <Int (1 <<Int 64)
  rule int64encoding(A, -1, -1, -1, -1, 3, 2, 1, 0) => A
      requires 0 <=Int A andBool A <Int (1 <<Int 32)

  syntax Int ::= int64BytesAre0(
      value: Int,
      b8Is0:Bool,
      b7Is0:Bool,
      b6Is0:Bool,
      b5Is0:Bool,
      b4Is0:Bool,
      b3Is0:Bool,
      b2Is0:Bool,
      b1Is0:Bool
  )  [function, total, smtlib(int64BytesAre0)]
  rule int64BytesAre0(_, false, false, false, false, false, false, false, false) => 1
  rule int64BytesAre0(A, true, true, true, true, true, true, true, true) => #bool(A ==Int 0)
      requires A <Int 2 ^Int 64

  syntax Int ::= sbr(Int, Int)  [function, total]
  rule sbr(A, B) => maxInt(-1, A -Int B)

  syntax Int ::= sbl(Int, Int)  [function, total]
  rule sbl(-1, _) => -1
  rule sbl(A, B) => A +Int B requires A =/=Int -1
endmodule

module INT-ENCODING-LEMMAS  [symbolic]
  imports CEILS-SYNTAX
  imports INT-ENCODING-BASIC

  rule int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1)
      => (((A &Int (255 <<Int 56)) >>Int 56) <<Int (B7 *Int 8)) |Int int64encoding(A, -1, B7, B6, B5, B4, B3, B2, B1)
      requires 0 <=Int B8 andBool B8 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, B7, B6, B5, B4, B3, B2, B1)
      => (((A &Int (255 <<Int 48)) >>Int 48) <<Int (B7 *Int 8)) |Int int64encoding(A, -1, -1, B6, B5, B4, B3, B2, B1)
      requires 0 <=Int B7 andBool B7 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, B6, B5, B4, B3, B2, B1)
      => (((A &Int (255 <<Int 40)) >>Int 40) <<Int (B6 *Int 8)) |Int int64encoding(A, -1, -1, -1, B5, B4, B3, B2, B1)
      requires 0 <=Int B6 andBool B6 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, -1, B5, B4, B3, B2, B1)
      => (((A &Int (255 <<Int 32)) >>Int 32) <<Int (B5 *Int 8)) |Int int64encoding(A, -1, -1, -1, -1, B4, B3, B2, B1)
      requires 0 <=Int B5 andBool B5 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, -1, -1, B4, B3, B2, B1)
      => (((A &Int (255 <<Int 24)) >>Int 24) <<Int (B4 *Int 8)) |Int int64encoding(A, -1, -1, -1, -1, -1, B3, B2, B1)
      requires 0 <=Int B4 andBool B4 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, -1, -1, -1, B3, B2, B1)
      => (((A &Int (255 <<Int 16)) >>Int 16) <<Int (B3 *Int 8)) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, B2, B1)
      requires 0 <=Int B3 andBool B3 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, -1, -1, -1, -1, B2, B1)
      => (((A &Int (255 <<Int 8)) >>Int 8) <<Int (B2 *Int 8)) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, -1, B1)
      requires 0 <=Int B2 andBool B2 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, -1, -1, -1, -1, -1, B1)
      => (((A &Int (255 <<Int 0)) >>Int 0) <<Int (B1 *Int 8))
      requires 0 <=Int B1 andBool B1 <=Int 7
      [simplification, concrete]

  rule int64BytesAre0(A, true, B7, B6, B5, B4, B3, B2, B1)
      => #bool(0 ==Int int64encoding(A,  0, -1, -1, -1, -1, -1, -1, -1))
        &Int int64BytesAre0(A, false, B7, B6, B5, B4, B3, B2, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, true, B6, B5, B4, B3, B2, B1)
      => #bool(0 ==Int int64encoding(A, -1,  0, -1, -1, -1, -1, -1, -1))
        &Int int64BytesAre0(A, false, false, B6, B5, B4, B3, B2, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, false, true, B5, B4, B3, B2, B1)
      => #bool(0 ==Int int64encoding(A, -1, -1,  0, -1, -1, -1, -1, -1))
        &Int int64BytesAre0(A, false, false, false, B5, B4, B3, B2, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, false, false, true, B4, B3, B2, B1)
      => #bool(0 ==Int int64encoding(A, -1, -1, -1,  0, -1, -1, -1, -1))
        &Int int64BytesAre0(A, false, false, false, false, B4, B3, B2, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, false, false, false, true, B3, B2, B1)
      => #bool(0 ==Int int64encoding(A, -1, -1, -1, -1,  0, -1, -1, -1))
        &Int int64BytesAre0(A, false, false, false, false, false, B3, B2, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, false, false, false, false, true, B2, B1)
      => #bool(0 ==Int int64encoding(A, -1, -1, -1, -1, -1,  0, -1, -1))
        &Int int64BytesAre0(A, false, false, false, false, false, false, B2, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, false, false, false, false, false, true, B1)
      => #bool(0 ==Int int64encoding(A, -1, -1, -1, -1, -1, -1,  0, -1))
        &Int int64BytesAre0(A, false, false, false, false, false, false, false, B1)
      [simplification, concrete]
  rule int64BytesAre0(A, false, false, false, false, false, false, false, true)
      => #bool(0 ==Int int64encoding(A, -1, -1, -1, -1, -1, -1, -1,  0))
        &Int int64BytesAre0(A, false, false, false, false, false, false, false, false)
      [simplification, concrete]

  rule A &Int 255                  => int64encoding(A, -1, -1, -1, -1, -1, -1, -1,  0)  [simplification]
  rule A &Int 65280                => int64encoding(A, -1, -1, -1, -1, -1, -1,  1, -1)  [simplification]
  rule A &Int 16711680             => int64encoding(A, -1, -1, -1, -1, -1,  2, -1, -1)  [simplification]
  rule A &Int 4278190080           => int64encoding(A, -1, -1, -1, -1,  3, -1, -1, -1)  [simplification]
  rule A &Int 1095216660480        => int64encoding(A, -1, -1, -1,  4, -1, -1, -1, -1)  [simplification]
  rule A &Int 280375465082880      => int64encoding(A, -1, -1,  5, -1, -1, -1, -1, -1)  [simplification]
  rule A &Int 71776119061217280    => int64encoding(A, -1,  6, -1, -1, -1, -1, -1, -1)  [simplification]
  rule A &Int 18374686479671623680 => int64encoding(A,  7, -1, -1, -1, -1, -1, -1, -1)  [simplification]

  rule A >>IntTotal 24             => int64encoding(A, -1, -1, -1, -1,  0, -1, -1, -1)
      requires A <Int 2 ^Int 32
      [simplification, symbolic(A)]
  rule A >>IntTotal 56             => int64encoding(A,  0, -1, -1, -1, -1, -1, -1, -1)
      requires A <Int 2 ^Int 64
      [simplification, symbolic(A)]

  rule int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1) >>IntTotal X
      => int64encoding(A, sbr(B8, X >>Int 3), sbr(B7, X >>Int 3), sbr(B6, X >>Int 3), sbr(B5, X >>Int 3), sbr(B4, X >>Int 3), sbr(B3, X >>Int 3), sbr(B2, X >>Int 3), sbr(B1, X >>Int 3))
      requires (0 <=Int X) andBool (X <=Int 56) andBool (X &Int 7 ==Int 0)
      [simplification, concrete(X)]

  rule int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1) <<IntTotal X
      => int64encoding(A, sbl(B8, X >>Int 3), sbl(B7, X >>Int 3), sbl(B6, X >>Int 3), sbl(B5, X >>Int 3), sbl(B4, X >>Int 3), sbl(B3, X >>Int 3), sbl(B2, X >>Int 3), sbl(B1, X >>Int 3))
      requires (0 <=Int X) andBool (X <=Int 56) andBool (X &Int 7 ==Int 0)
      [simplification, concrete(X)]

  rule int64encoding(A, -1, A7, A6, A5, A4, A3, A2, A1) |Int int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1)
      => int64encoding(A, B8, A7, A6, A5, A4, A3, A2, A1) |Int int64encoding(A, -1, B7, B6, B5, B4, B3, B2, B1)
      requires 0 <=Int B8
        andBool (((((((B8 =/=Int A7)
        andBool (B8 =/=Int A6))
        andBool (B8 =/=Int A5))
        andBool (B8 =/=Int A4))
        andBool (B8 =/=Int A3))
        andBool (B8 =/=Int A2))
        andBool (B8 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, -1, A6, A5, A4, A3, A2, A1) |Int int64encoding(A, -1, B7, B6, B5, B4, B3, B2, B1)
      => int64encoding(A, A8, B7, A6, A5, A4, A3, A2, A1) |Int int64encoding(A, -1, -1, B6, B5, B4, B3, B2, B1)
      requires 0 <=Int B7
        andBool (((((((B7 =/=Int A8)
        andBool (B7 =/=Int A6))
        andBool (B7 =/=Int A5))
        andBool (B7 =/=Int A4))
        andBool (B7 =/=Int A3))
        andBool (B7 =/=Int A2))
        andBool (B7 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, A7, -1, A5, A4, A3, A2, A1) |Int int64encoding(A, -1, -1, B6, B5, B4, B3, B2, B1)
      => int64encoding(A, A8, A7, B6, A5, A4, A3, A2, A1) |Int int64encoding(A, -1, -1, -1, B5, B4, B3, B2, B1)
      requires 0 <=Int B6
        andBool (((((((B6 =/=Int A8)
        andBool (B6 =/=Int A7))
        andBool (B6 =/=Int A5))
        andBool (B6 =/=Int A4))
        andBool (B6 =/=Int A3))
        andBool (B6 =/=Int A2))
        andBool (B6 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, A7, A6, -1, A4, A3, A2, A1) |Int int64encoding(A, -1, -1, -1, B5, B4, B3, B2, B1)
      => int64encoding(A, A8, A7, A6, B5, A4, A3, A2, A1) |Int int64encoding(A, -1, -1, -1, -1, B4, B3, B2, B1)
      requires 0 <=Int B5
        andBool (((((((B5 =/=Int A8)
        andBool (B5 =/=Int A7))
        andBool (B5 =/=Int A6))
        andBool (B5 =/=Int A4))
        andBool (B5 =/=Int A3))
        andBool (B5 =/=Int A2))
        andBool (B5 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, A7, A6, A5, -1, A3, A2, A1) |Int int64encoding(A, -1, -1, -1, -1, B4, B3, B2, B1)
      => int64encoding(A, A8, A7, A6, A5, B4, A3, A2, A1) |Int int64encoding(A, -1, -1, -1, -1, -1, B3, B2, B1)
      requires 0 <=Int B4
        andBool (((((((B4 =/=Int A8)
        andBool (B4 =/=Int A7))
        andBool (B4 =/=Int A6))
        andBool (B4 =/=Int A5))
        andBool (B4 =/=Int A3))
        andBool (B4 =/=Int A2))
        andBool (B4 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, A7, A6, A5, A4, -1, A2, A1) |Int int64encoding(A, -1, -1, -1, -1, -1, B3, B2, B1)
      => int64encoding(A, A8, A7, A6, A5, A4, B3, A2, A1) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, B2, B1)
      requires 0 <=Int B3
        andBool (((((((B3 =/=Int A8)
        andBool (B3 =/=Int A7))
        andBool (B3 =/=Int A6))
        andBool (B3 =/=Int A5))
        andBool (B3 =/=Int A4))
        andBool (B3 =/=Int A2))
        andBool (B3 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, A7, A6, A5, A4, A3, -1, A1) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, B2, B1)
      => int64encoding(A, A8, A7, A6, A5, A4, A3, B2, A1) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, -1, B1)
      requires 0 <=Int B2
        andBool (((((((B2 =/=Int A8)
        andBool (B2 =/=Int A7))
        andBool (B2 =/=Int A6))
        andBool (B2 =/=Int A5))
        andBool (B2 =/=Int A4))
        andBool (B2 =/=Int A3))
        andBool (B2 =/=Int A1))
      [simplification]
  rule int64encoding(A, A8, A7, A6, A5, A4, A3, A2, -1) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, -1, B1)
      => int64encoding(A, A8, A7, A6, A5, A4, A3, A2, B1)
      requires 0 <=Int B1
        andBool (((((((B1 =/=Int A8)
        andBool (B1 =/=Int A7))
        andBool (B1 =/=Int A6))
        andBool (B1 =/=Int A5))
        andBool (B1 =/=Int A4))
        andBool (B1 =/=Int A3))
        andBool (B1 =/=Int A2))
      [simplification]

  rule #bool(0 ==Int int64encoding(A, A8, A7, A6, A5, A4, A3, A2, A1))
      => int64BytesAre0(A, A8 >=Int 0, A7 >=Int 0, A6 >=Int 0, A5 >=Int 0, A4 >=Int 0, A3 >=Int 0, A2 >=Int 0, A1 >=Int 0)
      [simplification, symbolic(A)]

  rule int64BytesAre0(A, A8, A7, A6, A5, A4, A3, A2, A1) &Int int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1)
      => int64BytesAre0(
            A,
            A8 orBool B8,
            A7 orBool B7,
            A6 orBool B6,
            A5 orBool B5,
            A4 orBool B4,
            A3 orBool B3,
            A2 orBool B2,
            A1 orBool B1
        )
      [simplification]

  rule int64BytesAre0(A &Int 4294967295, _, _, _, _, B4, B3, B2, B1)
      => int64BytesAre0(A, false, false, false, false, B4, B3, B2, B1)
      [simplification]

  rule int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) &Int 1
      => int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1)
      [simplification]

  rule int64BytesAre0(_, _, _, _, _, _, _, _, _) <=Int 1 => true
      [simplification, smt-lemma]
  rule 0 <=Int int64BytesAre0(_, _, _, _, _, _, _, _, _) => true
      [simplification, smt-lemma]

  rule X +Int int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) ==Int 0
      => X ==Int 0 andBool int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) ==Int 0
      [simplification]

  rule int64BytesAre0(A, A8, A7, A6, A5, A4, A3, A2, A1) ==Int 0
        andBool int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) ==Int 0
      => int64BytesAre0(
            A,
            A8 orBool B8,
            A7 orBool B7,
            A6 orBool B6,
            A5 orBool B5,
            A4 orBool B4,
            A3 orBool B3,
            A2 orBool B2,
            A1 orBool B1
        ) ==Int 0
      [simplification]
endmodule
```