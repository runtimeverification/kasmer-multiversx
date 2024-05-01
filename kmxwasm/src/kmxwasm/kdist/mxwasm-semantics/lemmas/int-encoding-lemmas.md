```k
requires "../ceils-syntax.k"
requires "wasm-semantics/data.md"

module INT-ENCODING-BASIC
  imports INT
  imports BOOL
  imports WASM-DATA-COMMON

```
int64encoding
-------------

`int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1)` returns the int composed
of the bytes corresponding to `B<N>` values that are `>= 0`, placed on the
`B<N>` position, starting with `0`. Examples:

* `int64encoding(A, -1, -1, -1, -1, -1, -1, -1, 1)` means byte `0` of `A`
  on position `1`, i.e. `(A &Int 255) <<Int 8`
* `int64encoding(A, -1, -1, -1, -1, -1, -1, 0, -1)` means byte `1` of `A`
  on position `0`, i.e. `(A &Int (255 <<Int 8)) >>Int 8`

```k
  syntax Int ::= int64encoding(
      value: Int,
      b8pos: Int,
      b7pos: Int,
      b6pos: Int,
      b5pos: Int,
      b4pos: Int,
      b3pos: Int,
      b2pos: Int,
      b1pos: Int
  )  [function, total, smtlib(int64encoding)]
  rule int64encoding(0, _, _, _, _, _, _, _, _) => 0
  rule int64encoding(_, -1, -1, -1, -1, -1, -1, -1, -1) => 0
  rule int64encoding(A, 7, 6, 5, 4, 3, 2, 1, 0) => A
      requires 0 <=Int A andBool A <Int (1 <<Int 64)
  rule int64encoding(A, -1, -1, -1, -1, 3, 2, 1, 0) => A
      requires 0 <=Int A andBool A <Int (1 <<Int 32)

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
      => (((A &Int (255 <<Int  8)) >>Int  8) <<Int (B2 *Int 8)) |Int int64encoding(A, -1, -1, -1, -1, -1, -1, -1, B1)
      requires 0 <=Int B2 andBool B2 <=Int 7
      [simplification, concrete]
  rule int64encoding(A, -1, -1, -1, -1, -1, -1, -1, B1)
      => (((A &Int (255 <<Int  0)) >>Int  0) <<Int (B1 *Int 8))
      requires 0 <=Int B1 andBool B1 <=Int 7
      [simplification, concrete]

```
int64BytesAre0
--------------

`int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1)` returns `1` if the selected
bytes, i.e. the ones corresponding to `B<n> == true` values, are `0`. The
function returns 0 otherwise.

Examples:

* `int64BytesAre0(65535, true, true, true, true, true, true, false, false)` is `1`
* `int64BytesAre0(65535, true, true, true, true, true, true,  true, false)` is `0`

```k
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

```
countConsecutiveZeroBits
------------------------
```k

  syntax Int ::= countConsecutiveZeroBits(value: Int, processed: Int)
      [function, total, smtlib(countConsecutiveZeroBits)]
  rule countConsecutiveZeroBits(A, N)
      => 8 *Int int64BytesAre0(A, 0 <=Int N, 1 <=Int N, 2 <=Int N, 3 <=Int N, 4 <=Int N, 5 <=Int N, 6 <=Int N, 7 <=Int N)
        +Int countConsecutiveZeroBits(A, N -Int 1)
      [simplification, concrete]

  syntax Int ::= countConsecutiveZeroBytes(value: Int, processed: Int)
      [function, total, smtlib(countConsecutiveZeroBytes)]
  rule countConsecutiveZeroBytes(A, N)
      => int64BytesAre0(A, 0 <=Int N, 1 <=Int N, 2 <=Int N, 3 <=Int N, 4 <=Int N, 5 <=Int N, 6 <=Int N, 7 <=Int N)
        +Int countConsecutiveZeroBytes(A, N -Int 1)
      requires 0 <=Int N
      [simplification, concrete]
  rule countConsecutiveZeroBytes(_, N) => 0
      requires N <Int 0
      [simplification, concrete]

  // reverse encoding dropping consecutive 0 bytes starting with the highest byte.
  syntax Int ::= optimizedInt64Encoding(value: Int, b8: Bool, b7: Bool, b6: Bool, b5: Bool, b4: Bool, b3: Bool, b2: Bool, b1: Bool)
      [function, total, smtlib(optimizedInt64Encoding), no-evaluators]

  syntax Int ::= sbr(Int, Int)  [function, total]
  rule sbr(A, B) => maxInt(-1, A -Int B)

  syntax Int ::= sbl(Int, Int)  [function, total]
  rule sbl(-1, _) => -1
  rule sbl(A, B) => A +Int B requires A =/=Int -1

  syntax Int ::= permuteEncoding(Int, Int, Int, Int, Int, Int, Int, Int, Int)  [function, total]
  rule permuteEncoding(-1,  _,  _,  _,  _,  _,  _,  _,  _) => -1
  rule permuteEncoding( 0,  _,  _,  _,  _,  _,  _,  _, A1) => A1
  rule permuteEncoding( 1,  _,  _,  _,  _,  _,  _, A2,  _) => A2
  rule permuteEncoding( 2,  _,  _,  _,  _,  _, A3,  _,  _) => A3
  rule permuteEncoding( 3,  _,  _,  _,  _, A4,  _,  _,  _) => A4
  rule permuteEncoding( 4,  _,  _,  _, A5,  _,  _,  _,  _) => A5
  rule permuteEncoding( 5,  _,  _, A6,  _,  _,  _,  _,  _) => A6
  rule permuteEncoding( 6,  _, A7,  _,  _,  _,  _,  _,  _) => A7
  rule permuteEncoding( 7, A8,  _,  _,  _,  _,  _,  _,  _) => A8
  rule permuteEncoding( _,  _,  _,  _,  _,  _,  _,  _,  _) => -1  [owise]

endmodule

module INT-ENCODING-LEMMAS  [symbolic]
  imports CEILS-SYNTAX
  imports INT-ENCODING-BASIC

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

  rule int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1) |Int A
      => A
      requires ((((((((true
        andBool ((B8 ==Int -1) orBool (B8 ==Int 7)))
        andBool ((B7 ==Int -1) orBool (B7 ==Int 6)))
        andBool ((B6 ==Int -1) orBool (B6 ==Int 5)))
        andBool ((B5 ==Int -1) orBool (B5 ==Int 4)))
        andBool ((B4 ==Int -1) orBool (B4 ==Int 3)))
        andBool ((B3 ==Int -1) orBool (B3 ==Int 2)))
        andBool ((B2 ==Int -1) orBool (B2 ==Int 1)))
        andBool ((B1 ==Int -1) orBool (B1 ==Int 0)))
      [simplification]
  rule A |Int int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1)
      => A
      requires ((((((((true
        andBool ((B8 ==Int -1) orBool (B8 ==Int 7)))
        andBool ((B7 ==Int -1) orBool (B7 ==Int 6)))
        andBool ((B6 ==Int -1) orBool (B6 ==Int 5)))
        andBool ((B5 ==Int -1) orBool (B5 ==Int 4)))
        andBool ((B4 ==Int -1) orBool (B4 ==Int 3)))
        andBool ((B3 ==Int -1) orBool (B3 ==Int 2)))
        andBool ((B2 ==Int -1) orBool (B2 ==Int 1)))
        andBool ((B1 ==Int -1) orBool (B1 ==Int 0)))
      [simplification]

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

  rule int64encoding(int64encoding(A, B8, B7, B6, B5, B4, B3, B2, B1), A8, A7, A6, A5, A4, A3, A2, A1)
      => int64encoding
          ( A
          , permuteEncoding(B8, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B7, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B6, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B5, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B4, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B3, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B2, A8, A7, A6, A5, A4, A3, A2, A1)
          , permuteEncoding(B1, A8, A7, A6, A5, A4, A3, A2, A1)
          )
      [simplification]

  rule int64encoding(A, _, -1, -1, -1, -1, -1, -1, -1) => 0 requires A <Int 1 <<Int 56
      [simplification]
  rule int64encoding(A, _,  _, -1, -1, -1, -1, -1, -1) => 0 requires A <Int 1 <<Int 48
      [simplification]
  rule int64encoding(A, _,  _,  _, -1, -1, -1, -1, -1) => 0 requires A <Int 1 <<Int 40
      [simplification]
  rule int64encoding(A, _,  _,  _,  _, -1, -1, -1, -1) => 0 requires A <Int 1 <<Int 32
      [simplification]
  rule int64encoding(A, _,  _,  _,  _,  _, -1, -1, -1) => 0 requires A <Int 1 <<Int 24
      [simplification]
  rule int64encoding(A, _,  _,  _,  _,  _,  _, -1, -1) => 0 requires A <Int 1 <<Int 16
      [simplification]
  rule int64encoding(A, _,  _,  _,  _,  _,  _,  _, -1) => 0 requires A <Int 1 <<Int  8
      [simplification]

  rule int64encoding(A >>IntTotal B, -1, A7, A6, A5, A4, A3, A2, A1)
        => int64encoding(A >>IntTotal (B -Int 8), A7, A6, A5, A4, A3, A2, A1, -1)
        requires 8 <=Int B
        [simplification]

  rule int64encoding(A, A8, A7, A6, A5, A4, A3, A2, A1) modIntTotal 256
        => int64encoding(
              A,
              #if A8 ==Int 0 #then 0 #else -1 #fi,
              #if A7 ==Int 0 #then 0 #else -1 #fi,
              #if A6 ==Int 0 #then 0 #else -1 #fi,
              #if A5 ==Int 0 #then 0 #else -1 #fi,
              #if A4 ==Int 0 #then 0 #else -1 #fi,
              #if A3 ==Int 0 #then 0 #else -1 #fi,
              #if A2 ==Int 0 #then 0 #else -1 #fi,
              #if A1 ==Int 0 #then 0 #else -1 #fi
          )
        [simplification]

  rule int64encoding(A, A8, A7, A6, A5, A4, A3, A2, A1) &Int 18446744073709551615
        => int64encoding(A, A8, A7, A6, A5, A4, A3, A2, A1)
        [simplification]

  rule int64encoding(_, _, _, _, _, _, _, _, _) <=Int 18446744073709551615
        => true
        [simplification, smt-lemma]

  rule int64encoding(_, _, _, _, _, _, _, _, _) <Int 18446744073709551616
        => true
        [simplification]

  rule int64encoding(_, A8, A7, A6, A5, A4, A3, A2, A1) <=Int 4294967295 => true
      requires A8 <=Int 3
        andBool ((((((A7 <=Int 3)
        andBool (A6 <=Int 3))
        andBool (A5 <=Int 3))
        andBool (A4 <=Int 3))
        andBool (A3 <=Int 3))
        andBool (A2 <=Int 3))
        andBool (A1 <=Int 3)
      [simplification, smt-lemma]
  rule int64encoding(_, A8, A7, A6, A5, A4, A3, A2, A1) <Int 4294967296 => true
      requires A8 <=Int 3
        andBool ((((((A7 <=Int 3)
        andBool (A6 <=Int 3))
        andBool (A5 <=Int 3))
        andBool (A4 <=Int 3))
        andBool (A3 <=Int 3))
        andBool (A2 <=Int 3))
        andBool (A1 <=Int 3)
      [simplification]

  rule int64encoding(_, A8, A7, A6, A5, A4, A3, A2, A1) <=Int 65535 => true
      requires A8 <=Int 1
        andBool ((((((A7 <=Int 1)
        andBool (A6 <=Int 1))
        andBool (A5 <=Int 1))
        andBool (A4 <=Int 1))
        andBool (A3 <=Int 1))
        andBool (A2 <=Int 1))
        andBool (A1 <=Int 1)
      [simplification, smt-lemma]
  rule int64encoding(_, A8, A7, A6, A5, A4, A3, A2, A1) <Int 65536 => true
      requires A8 <=Int 1
        andBool ((((((A7 <=Int 1)
        andBool (A6 <=Int 1))
        andBool (A5 <=Int 1))
        andBool (A4 <=Int 1))
        andBool (A3 <=Int 1))
        andBool (A2 <=Int 1))
        andBool (A1 <=Int 1)
      [simplification]

  rule int64encoding(_, A8, A7, A6, A5, A4, A3, A2, A1) <=Int 255 => true
      requires A8 <=Int 0
        andBool ((((((A7 <=Int 0)
        andBool (A6 <=Int 0))
        andBool (A5 <=Int 0))
        andBool (A4 <=Int 0))
        andBool (A3 <=Int 0))
        andBool (A2 <=Int 0))
        andBool (A1 <=Int 0)
      [simplification, smt-lemma]
  rule int64encoding(_, A8, A7, A6, A5, A4, A3, A2, A1) <Int 256 => true
      requires A8 <=Int 0
        andBool ((((((A7 <=Int 0)
        andBool (A6 <=Int 0))
        andBool (A5 <=Int 0))
        andBool (A4 <=Int 0))
        andBool (A3 <=Int 0))
        andBool (A2 <=Int 0))
        andBool (A1 <=Int 0)
      [simplification]

  rule 0 <=Int int64encoding(_, _, _, _, _, _, _, _, _) => true
      [simplification, smt-lemma]

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

  // rule X +Int int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) ==Int 0
  //     => X ==Int 0 andBool int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) ==Int 0
  //     requires X >=Int 0
  //     [simplification]

  // rule int64BytesAre0(A, A8, A7, A6, A5, A4, A3, A2, A1) ==Int 0
  //       andBool int64BytesAre0(A, B8, B7, B6, B5, B4, B3, B2, B1) ==Int 0
  //     => int64BytesAre0(
  //           A,
  //           A8 orBool B8,
  //           A7 orBool B7,
  //           A6 orBool B6,
  //           A5 orBool B5,
  //           A4 orBool B4,
  //           A3 orBool B3,
  //           A2 orBool B2,
  //           A1 orBool B1
  //       ) ==Int 0
  //     [simplification]

  rule int64BytesAre0(A >>IntTotal B, _, A7, A6, A5, A4, A3, A2, A1)
      => int64BytesAre0(A >>IntTotal (B -Int 8), A7, A6, A5, A4, A3, A2, A1, false)
      requires 0 <=Int A andBool A <Int 1 <<Int 64 andBool 8 <=Int B
      [simplification]

  rule 8 *Int int64BytesAre0 ( A, true, false, false, false, false, false, false, false )
      => countConsecutiveZeroBits(A, 0)
      [simplification]
  rule 8 *Int int64BytesAre0 ( A, true, true, false, false, false, false, false, false )
      +Int countConsecutiveZeroBits(A, 0)
      => countConsecutiveZeroBits(A, 1)
      [simplification]
  rule countConsecutiveZeroBits(A, 1)
      +Int 8 *Int int64BytesAre0 ( A, true, true, true, false, false, false, false, false )
      => countConsecutiveZeroBits(A, 2)
      [simplification]
  rule countConsecutiveZeroBits(A, 2)
      +Int 8 *Int int64BytesAre0 ( A, true, true, true, true, false, false, false, false )
      => countConsecutiveZeroBits(A, 3)
      [simplification]
  rule countConsecutiveZeroBits(A, 3)
      +Int 8 *Int int64BytesAre0 ( A, true, true, true, true, true, false, false, false )
      => countConsecutiveZeroBits(A, 4)
      [simplification]
  rule countConsecutiveZeroBits(A, 4)
      +Int 8 *Int int64BytesAre0 ( A, true, true, true, true, true, true, false, false )
      => countConsecutiveZeroBits(A, 5)
      [simplification]
  rule countConsecutiveZeroBits(A, 5)
      +Int 8 *Int int64BytesAre0 ( A, true, true, true, true, true, true, true, false )
      => countConsecutiveZeroBits(A, 6)
      [simplification]

  rule ( X +Int -8 *Int int64BytesAre0 ( A, true, true, false, false, false, false, false, false ) )
      +Int -8 *Int int64BytesAre0 ( A, true, false, false, false, false, false, false, false )
      => X +Int -1 *Int countConsecutiveZeroBits(A, 1)
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBits(A, 1))
      +Int -8 *Int int64BytesAre0 ( A, true, true, true, false, false, false, false, false )
      => X +Int -1 *Int countConsecutiveZeroBits(A, 2)
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBits(A, 2))
      +Int -8 *Int int64BytesAre0 ( A, true, true, true, true, false, false, false, false )
      => X +Int -1 *Int countConsecutiveZeroBits(A, 3)
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBits(A, 3))
      +Int -8 *Int int64BytesAre0 ( A, true, true, true, true, true, false, false, false )
      => (X +Int -1 *Int countConsecutiveZeroBits(A, 4))
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBits(A, 4))
      +Int -8 *Int int64BytesAre0 ( A, true, true, true, true, true, true, false, false )
      => (X +Int -1 *Int countConsecutiveZeroBits(A, 5))
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBits(A, 5))
      +Int -8 *Int int64BytesAre0 ( A, true, true, true, true, true, true, true, false )
      => X +Int -1 *Int countConsecutiveZeroBits(A, 6)
      [simplification]

  rule 0 <=Int countConsecutiveZeroBits(_, _) => true
      [simplification, smt-lemma]
  rule countConsecutiveZeroBits(_, 6) <=Int 56 => true
      [simplification, smt-lemma]

  rule int64BytesAre0 ( A, true, true, false, false, false, false, false, false )
      +Int int64BytesAre0 ( A, true, false, false, false, false, false, false, false )
      => countConsecutiveZeroBytes(A, 1)
      [simplification]
  rule countConsecutiveZeroBytes(A, 1)
      +Int int64BytesAre0 ( A, true, true, true, false, false, false, false, false )
      => countConsecutiveZeroBytes(A, 2)
      [simplification]
  rule countConsecutiveZeroBytes(A, 2)
      +Int int64BytesAre0 ( A, true, true, true, true, false, false, false, false )
      => countConsecutiveZeroBytes(A, 3)
      [simplification]
  rule countConsecutiveZeroBytes(A, 3)
      +Int int64BytesAre0 ( A, true, true, true, true, true, false, false, false )
      => countConsecutiveZeroBytes(A, 4)
      [simplification]
  rule countConsecutiveZeroBytes(A, 4)
      +Int int64BytesAre0 ( A, true, true, true, true, true, true, false, false )
      => countConsecutiveZeroBytes(A, 5)
      [simplification]
  rule countConsecutiveZeroBytes(A, 5)
      +Int int64BytesAre0 ( A, true, true, true, true, true, true, true, false )
      => countConsecutiveZeroBytes(A, 6)
      [simplification]

  rule ( X +Int -1 *Int int64BytesAre0 ( A, true, true, false, false, false, false, false, false ) )
      +Int -1 *Int int64BytesAre0 ( A, true, false, false, false, false, false, false, false )
      => X +Int -1 *Int countConsecutiveZeroBytes(A, 1)
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBytes(A, 1))
      +Int -1 *Int int64BytesAre0 ( A, true, true, true, false, false, false, false, false )
      => X +Int -1 *Int countConsecutiveZeroBytes(A, 2)
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBytes(A, 2))
      +Int -1 *Int int64BytesAre0 ( A, true, true, true, true, false, false, false, false )
      => X +Int -1 *Int countConsecutiveZeroBytes(A, 3)
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBytes(A, 3))
      +Int -1 *Int int64BytesAre0 ( A, true, true, true, true, true, false, false, false )
      => (X +Int -1 *Int countConsecutiveZeroBytes(A, 4))
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBytes(A, 4))
      +Int -1 *Int int64BytesAre0 ( A, true, true, true, true, true, true, false, false )
      => (X +Int -1 *Int countConsecutiveZeroBytes(A, 5))
      [simplification]
  rule (X +Int -1 *Int countConsecutiveZeroBytes(A, 5))
      +Int -1 *Int int64BytesAre0 ( A, true, true, true, true, true, true, true, false )
      => X +Int -1 *Int countConsecutiveZeroBytes(A, 6)
      [simplification]

  rule 0 <=Int countConsecutiveZeroBytes(_, _) => true
      [simplification, smt-lemma]
  rule countConsecutiveZeroBytes(_, 6) <=Int 7 => true
      [simplification, smt-lemma]
  rule countConsecutiveZeroBytes(_, 6) <Int N => true
      requires 7 <Int N
      [simplification]
  rule countConsecutiveZeroBytes(_, 6) <=Int N => true
      requires 7 <=Int N
      [simplification]

  rule int64encoding( A, -1, -1, -1, -1, -1, -1, -1,  7 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, false, false, false, false, false, false, true)
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1, -1, -1,  6, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, false, false, false, false, false, true, false)
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1, -1,  5, -1, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, false, false, false, false, true, false, false)
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1,  4, -1, -1, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, false, false, false, true, false, false, false)
      [simplification]
  rule int64encoding( A, -1, -1, -1,  3, -1, -1, -1, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, false, false, true, false, false, false, false)
      [simplification]
  rule int64encoding( A, -1, -1,  2, -1, -1, -1, -1, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, false, true, false, false, false, false, false)
      [simplification]
  rule int64encoding( A, -1,  1, -1, -1, -1, -1, -1, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, false, true, false, false, false, false, false, false)
      [simplification]
  rule int64encoding( A,  0, -1, -1, -1, -1, -1, -1, -1 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, true, false, false, false, false, false, false, false)
      [simplification]
  rule int64encoding( A,  0,  1,  2,  3,  4,  5,  6,  7 )
      >>IntTotal countConsecutiveZeroBits(A, 6)
      => optimizedInt64Encoding(A, true, true, true, true, true, true, true, true)
      [simplification]

  rule optimizedInt64Encoding(A, A8, A7, A6, A5, A4, A3, A2, A1)
        |Int optimizedInt64Encoding(A, B8, B7, B6, B5, B4, B3, B2, B1)
      => optimizedInt64Encoding(
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

  rule 0 <=Int optimizedInt64Encoding(_, _, _, _, _, _, _, _, _) => true
      [simplification, smt-lemma]
  rule optimizedInt64Encoding(_, _, _, _, _, _, _, _, _) <=Int 18446744073709551615 => true
      [simplification, smt-lemma]
  rule optimizedInt64Encoding(_, _, _, _, _, _, _, _, _) <Int 18446744073709551616 => true
      [simplification]

  rule Bytes2Int(B:Bytes, _:Endianness, Unsigned) <Int N => true
      requires 1 <<Int (8 *Int lengthBytes(B)) <=Int N
      [simplification]

  // Let a0, a1, a2, a3, a4, a5, a6, a7 be A's bytes. Let's assume that
  // a4=/=0, a5==0, a6==0, a7==0. Then we have:
  // A == a7 a6 a5 a4 a3 a2 a1 a0 == 0 0 0 a4 a3 a2 a1 a0.
  // countConsecutiveZeroBytes ( A, 6 ) == 3
  // int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 ) = a0 a1 a2 a3 a4 a5 a6 a7
  // int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 ))
  //    >>IntTotal ((8) *Int (countConsecutiveZeroBytes ( A, 6 ))
  //    == a0 a1 a2 a3 a4
  // Int2Bytes(..., LE) == a4 a3 a2 a1 a0
  // Bytes2Int(..., BE) == a4 a3 a2 a1 a0 == 0 0 0 a4 a3 a2 a1 a0 == A
  rule Bytes2Int
        ( Int2Bytes
          ( ((-1) *Int (countConsecutiveZeroBytes ( A, 6 ))) +Int (8)
          , (int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 ))
            >>IntTotal ((8) *Int (countConsecutiveZeroBytes ( A, 6 )))
          , LE
          )
        , BE
        , Unsigned
        )
      => A
      requires 0 <=Int A andBool A <Int 1 <<Int 64
      [simplification]

  rule int64encoding( A,  0,  1,  2,  3,  4,  5,  6,  7 ) modIntTotal 256
    => int64encoding( A,  0, -1, -1, -1, -1, -1, -1, -1 )
      [simplification]
  rule int64encoding( A, -1,  0,  1,  2,  3,  4,  5,  6 ) modIntTotal 256
    => int64encoding( A, -1,  0, -1, -1, -1, -1, -1, -1 )
      [simplification]
  rule int64encoding( A, -1, -1,  0,  1,  2,  3,  4,  5 ) modIntTotal 256
    => int64encoding( A, -1, -1,  0, -1, -1, -1, -1, -1 )
      [simplification]
  rule int64encoding( A, -1, -1, -1,  0,  1,  2,  3,  4 ) modIntTotal 256
    => int64encoding( A, -1, -1, -1,  0, -1, -1, -1, -1 )
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1,  0,  1,  2,  3 ) modIntTotal 256
    => int64encoding( A, -1, -1, -1, -1,  0, -1, -1, -1 )
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1, -1,  0,  1,  2 ) modIntTotal 256
    => int64encoding( A, -1, -1, -1, -1, -1,  0, -1, -1 )
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1, -1, -1,  0,  1 ) modIntTotal 256
    => int64encoding( A, -1, -1, -1, -1, -1, -1,  0, -1 )
      [simplification]
  rule int64encoding( A, -1, -1, -1, -1, -1, -1, -1,  0 ) modIntTotal 256
    => int64encoding( A, -1, -1, -1, -1, -1, -1, -1,  0 )
      [simplification]

  rule (((((((B
      +Bytes Int2Bytes
        ( 1, int64encoding( A, 0, -1, -1, -1, -1, -1, -1, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, 0, -1, -1, -1, -1, -1, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, -1, 0, -1, -1, -1, -1, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, 0, -1, -1, -1, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, 0, -1, -1, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, 0, -1, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, 0, -1 ), LE ))
      +Bytes Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, -1, 0 ), LE )
      => B +Bytes Int2Bytes( 8, int64encoding( A, 0, 1, 2, 3, 4, 5, 6, 7 ), LE )
      [simplification]

  rule
      ( Int2Bytes
        ( 1, int64encoding( A, 0, -1, -1, -1, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, 0, -1, -1, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, 0, -1, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, 0, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, 0, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, 0, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, 0, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, -1, 0 ), LE )
      +Bytes B
      ))))))))
      => Int2Bytes( 8, int64encoding( A, 0, 1, 2, 3, 4, 5, 6, 7 ), LE ) +Bytes B
      [simplification]

  rule
      ( Int2Bytes
        ( 1, int64encoding( A, 0, -1, -1, -1, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, 0, -1, -1, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, 0, -1, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, 0, -1, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, 0, -1, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, 0, -1, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, 0, -1 ), LE )
      +Bytes ( Int2Bytes
        ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, -1, 0 ), LE )
      ))))))))
      => Int2Bytes( 8, int64encoding( A, 0, 1, 2, 3, 4, 5, 6, 7 ), LE )
      [simplification]

endmodule
```