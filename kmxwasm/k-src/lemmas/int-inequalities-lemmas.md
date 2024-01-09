```k
require "../ceils-syntax.k"
require "int-normalization-lemmas.md"

module INT-INEQUALITIES-LEMMAS
  imports private CEILS-SYNTAX
  imports private INT-NORMALIZATION-LEMMAS-BASIC
  imports private INT

  rule A >Int B => B <Int A
      [simplification]
  rule A >=Int B => B <=Int A
      [simplification]

  rule (A |Int B) <Int M => true
      requires 0 <=Int M
        andBool A <Int 2 ^Int log2Int(M)
        andBool B <Int 2 ^Int log2Int(M)
      [simplification, concrete(M)]
  rule (A |Int B) <Int M => false
      requires 0 <=Int M
        andBool (M <=Int A orBool M <=Int B)
      [simplification, concrete(M)]
  rule (A |Int B) <=Int M => true
      requires 0 <=Int M
        andBool A <Int 2 ^Int log2Int(M)
        andBool B <Int 2 ^Int log2Int(M)
      [simplification, concrete(M)]
  rule (A |Int B) <=Int M => false
      requires 0 <=Int M
        andBool (M <Int A orBool M <Int B)
      [simplification, concrete(M)]
  rule (A |Int B) <Int M => A <Int M andBool B <Int M
      requires isFullMask(M)
      [simplification, concrete(M)]
  rule (A |Int B) <=Int M => A <=Int M andBool B <=Int M
      requires isFullMask(M)
      [simplification, concrete(M)]
  rule 0 <Int A |Int B
          => (0 <=Int A andBool 0 <Int B) orBool (0 <Int A andBool 0 <=Int B)
      [simplification]
  rule 0 <=Int A |Int B => 0 <=Int A andBool 0 <=Int B
      [simplification]
  rule M <Int A |Int B => M <Int A orBool M <Int B
      requires  isFullMask(M)
        andBool 0 <=Int A
        andBool 0 <=Int B
      [simplification]
  rule M <Int A |Int B => true
      requires 0 <=Int M
        andBool (M <Int A orBool M <Int B)
      [simplification]
  rule M <Int A |Int B => false
      requires 0 <=Int M
        andBool A <Int 2 ^Int log2Int(M)
        andBool B <Int 2 ^Int log2Int(M)
      [simplification, concrete(M)]
  ///
  rule M <=Int A |Int B => M <=Int A orBool M <=Int B
      requires  isFullMask(M)
        andBool 0 <=Int A
        andBool 0 <=Int B
      [simplification]
  rule M <=Int A |Int B => true
      requires 0 <=Int M
        andBool (M <=Int A orBool M <=Int B)
      [simplification]
  rule M <=Int A |Int B => false
      requires 0 <=Int M
        andBool A <Int 2 ^Int log2Int(M)
        andBool B <Int 2 ^Int log2Int(M)
      [simplification, concrete(M)]

  rule 0 <=Int A &Int B => 0 <=Int A orBool 0 <=Int B
      [simplification]
  rule M <=Int A &Int B => false
      requires B <Int M orBool A <Int M
      [simplification]
  rule M <Int A &Int B => false
      requires B <=Int M orBool A <=Int M
      [simplification]
  rule (A &Int B) <Int M => true
      requires (0 <=Int A andBool A <Int M) orBool (0 <=Int B andBool B <Int M)
      [simplification, concrete(M)]
  rule (A &Int B) <=Int M => true
      requires (0 <=Int A andBool A <=Int M) orBool (0 <=Int B andBool B <=Int M)
      [simplification, concrete(M)]

  rule 0 <=Int A <<IntTotal B => 0 <=Int A
      requires definedShlInt(A, B)
      [simplification]
  rule 0 <Int A <<IntTotal B => 0 <Int A
      requires definedShlInt(A, B)
      [simplification]
  // a * 2^b <= c
  // iff a <= c / 2^b
  // iff a <= trunc(c / 2^b)
  rule A <<IntTotal B <=Int C => A <=Int (C >>Int B)
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShlInt(A, B)
      [simplification, concrete(B, C)]
  // When c & fullMask(b) != 0:
  // a * 2^b < c
  // iff a < c / 2^b
  // iff a <= trunc(c / 2^b)
  //
  // When c & fullMask(b) == 0
  // a * 2^b < c
  // iff a < c / 2^b
  // iff a < trunc(c / 2^b)
  rule A <<IntTotal B <Int C
        =>  #if C &Int fullMask(B) ==Int 0
            #then
              A <Int (C >>Int B)
            #else
              A <=Int (C >>Int B)
            #fi
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShlInt(A, B)
          andBool notBool C &Int fullMask(B) ==Int 0
      [simplification, concrete(B, C)]

  rule 0 <=Int A >>IntTotal B => 0 <=Int A
      requires definedShrInt(A, B)
      [simplification]
  rule 0 <Int A >>IntTotal B => 1 <<IntTotal B <=Int A
      requires definedShrInt(A, B)
      [simplification, concrete(B)]

  // trunc(a / 2^b) <= c
  // iff a / 2^b - frac(a / 2^b) <= c
  // iff a / 2^b <= c + frac(a / 2^b)
  // iff a <= c * 2^b + a & (2^b - 1)
  //
  // a <= c * 2^b + a & (2^b - 1)
  // implies a < c * 2^b + 2^b
  // implies a < (c + 1) * 2^b
  // implies a <= (c + 1) * 2^b - 1
  //
  // a <= (c + 1) * 2^b - 1
  // implies a <= c * 2^b + (2^b - 1)
  // implies a <= c * 2^b + a & (2^b - 1)
  //
  // trunc(a / 2^b) <= c iff a <= (c + 1) * 2^b - 1
  rule A >>IntTotal B <=Int C => A <=Int ((C +Int 1) <<Int B) -Int 1
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShrInt(A, B)
      [simplification, concrete(B, C)]
  // trunc(a / 2^b) < c
  // iff a / 2^b - frac(a / 2^b) <= c
  // iff a / 2^b <= c + frac(a / 2^b)
  // iff a < c * 2^b + a & (2^b - 1)
  //
  // Assume a < c * 2^b + a & (2^b - 1).
  // Suppose a >= c * 2^b. Then a == c * 2^b + a & (2^b - 1), false.
  // This means that a < c * 2^b.
  //
  // Assume a < c * 2^b. Obviously, a < c * 2^b + a & (2^b - 1)
  //
  // trunc(a / 2^b) < c iff a < c * 2^b
  rule A >>IntTotal B <Int C => A <Int C <<Int B
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShrInt(A, B)
      [simplification, concrete(B, C)]


  rule A +Int B <=Int C => A <=Int C -Int B
      [simplification, concrete(B, C)]
  rule A +Int B <Int C => A <Int C -Int B
      [simplification, concrete(B, C)]
  rule A <=Int B +Int C => A -Int C <=Int B
      [simplification, concrete(A, C)]
  rule A <Int B +Int C => A -Int C <Int B
      [simplification, concrete(A, C)]

  rule A -Int B <=Int C => A <=Int C +Int B
      [simplification, concrete(B, C)]
  rule A -Int B <Int C => A <Int C +Int B
      [simplification, concrete(B, C)]
  rule A <=Int B -Int C => A +Int C <=Int B
      [simplification, concrete(A, C)]
  rule A <Int B -Int C => A +Int C <Int B
      [simplification, concrete(A, C)]

  // a * b <= c
  // iff a <= c / b
  // iff a <= trunc(c/b)
  rule A *Int B <=Int C => A <=Int C /Int B
      requires 0 <Int B andBool 0 <=Int C
      [simplification, concrete(B, C)]
  // When c mod b is 0:
  // a * b < c
  // iff a < c / b
  // iff a < trunc(c/b)   (c/b is an int)
  //
  // When c mod b is not 0
  // a * b < c
  // iff a < c / b
  // iff a < trunc(c/b) + frac(c/b)
  // iff a <= trunc(c/b)   (frac(c/b) > 0)
  rule A *Int B <Int C
      =>  #if C modInt B ==Int 0
          #then
            A <Int C /Int B
          #else
            A <=Int C /Int B
          #fi
      requires 0 <Int B
        andBool 0 <=Int C
      [simplification, concrete(B, C)]
  // When a mod c is 0:
  // a <= b * c
  // iff a / c <= b
  // iff trunc(a/c) <= b   (a/c is an int)
  //
  // When a mod c is not 0:
  // a <= b * c
  // iff a / c <= b
  // iff trunc(a/c) + frac(a/c) <= b
  // iff trunc(a/c) < b   (frac(a/c) > 0)
  rule A <=Int B *Int C
        =>  #if A modInt C ==Int 0
            #then
              A /Int C <=Int B
            #else
              A /Int C <Int B
            #fi
      requires 0 <Int C
        andBool 0 <=Int A
      [simplification, concrete(A, C)]
  // a < b * c
  // iff a / c < b
  // iff trunc(a/c) < b
  rule A <Int B *Int C => A /Int C <Int B
      requires 0 <Int C andBool 0 <=Int B
      [simplification, concrete(A, C)]


  // a * b <= c
  // iff a <= c / b
  // iff a <= trunc(c/b)
  rule A <=Int C divIntTotal B => A *Int B <=Int C 
      requires 0 <Int B andBool 0 <=Int C
      [simplification, concrete(A, B)]
  // a < b * c
  // iff a / c < b
  // iff trunc(a/c) < b
  rule A divIntTotal C <Int B => A <Int B *Int C
      requires 0 <Int C andBool 0 <=Int A
      [simplification, concrete(B, C)]

  rule (_X modIntTotal Y) <Int Y => true
      requires Y >Int 0
      [simplification, smt-lemma]
  rule 0 <=Int (_X modIntTotal Y) => true
      requires Y >Int 0
      [simplification, smt-lemma]

  rule 0 <=Int log2IntTotal(_:Int) => true
      [simplification, smt-lemma]

endmodule
```