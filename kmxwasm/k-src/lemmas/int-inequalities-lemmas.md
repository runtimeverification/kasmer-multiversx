```k
requires "../ceils-syntax.k"
requires "int-normalization-lemmas.md"

module INT-INEQUALITIES-LEMMAS
  imports private CEILS-SYNTAX
  imports private INT-NORMALIZATION-LEMMAS-BASIC
  imports private INT

  // Moved to proven-mx-lemmas.md
  // rule A >Int B => B <Int A
  //     [simplification]
  // rule A >=Int B => B <=Int A
  //     [simplification]

  // Moved to proven-mx-lemmas.md
  // rule A <Int A => false
  //     [simplification]
  // rule A <=Int A => true
  //     [simplification]

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

  // Moved to proven-mx-lemmas.md
  // rule A +Int B <=Int A => B <=Int 0  [simplification]
  // rule B +Int A <=Int A => B <=Int 0  [simplification]
  // rule A +Int B <Int A => B <Int 0  [simplification]
  // rule B +Int A <Int A => B <Int 0  [simplification]
  // rule A <=Int A +Int B => 0 <=Int B  [simplification]
  // rule A <=Int B +Int A => 0 <=Int B  [simplification]
  // rule A <Int A +Int B => 0 <Int B  [simplification]
  // rule A <Int B +Int A => 0 <Int B  [simplification]

  // Moved to proven-mx-lemmas.md
  // rule notBool (A <=Int B) => B <Int A  [simplification]
  // rule notBool (A <Int B) => B <=Int A  [simplification]

  // Moved to proven-mx-lemmas.md
  // rule A +Int B <=Int C => A <=Int C -Int B
  //     [simplification, concrete(B, C)]
  // rule A +Int B <Int C => A <Int C -Int B
  //     [simplification, concrete(B, C)]
  // rule A <=Int B +Int C => A -Int C <=Int B
  //     [simplification, concrete(A, C)]
  // rule A <Int B +Int C => A -Int C <Int B
  //     [simplification, concrete(A, C)]

  rule A +Int B <=Int C +Int D => A +Int (B -Int D) <=Int C
      [simplification, concrete(B, D)]

  // Moved to proven-mx-lemmas.md
  // rule A -Int B <=Int C => A <=Int C +Int B
  //     [simplification, concrete(B, C)]
  // rule A -Int B <Int C => A <Int C +Int B
  //     [simplification, concrete(B, C)]
  // rule A -Int B <=Int C => A -Int C <=Int B
  //     [simplification, concrete(A, C)]
  // rule A -Int B <Int C => A -Int C <Int B
  //     [simplification, concrete(A, C)]
  // rule A <=Int B -Int C => A +Int C <=Int B
  //     [simplification, concrete(A, C)]
  // rule A <Int B -Int C => A +Int C <Int B
  //     [simplification, concrete(A, C)]
  // rule A <=Int B -Int C => C <=Int B -Int A
  //     [simplification, concrete(A, B)]
  // rule A <Int B -Int C => C <Int B -Int A
  //     [simplification, concrete(A, B)]

  rule A *Int B <=Int C => B <=Int C /Int A
      requires 0 <Int A
      [simplification, concrete(A, C)]
  rule A *Int B <Int C => B <=Int (C -Int 1) /Int A
      requires 0 <Int A
      [simplification, concrete(A, C)]
  rule A <=Int B *Int C => A /Int B <=Int C
      requires 0 <Int B andBool A modInt B ==Int 0
      [simplification, concrete(A, B)]
  rule A <=Int B *Int C => A /Int B +Int 1 <=Int C
      requires 0 <Int B andBool A modInt B =/=Int 0
      [simplification, concrete(A, B)]
  rule A <Int B *Int C => A /Int B <Int C
      requires 0 <Int B andBool A modInt B ==Int 0
      [simplification, concrete(A, B)]
  rule A <Int B *Int C => A /Int B +Int 1 <Int C
      requires 0 <Int B andBool A modInt B =/=Int 0
      [simplification, concrete(A, B)]

  rule A *Int B <=Int C => (0 -Int C) <=Int (0 -Int A) *Int B
      requires A <Int 0
      [simplification, concrete(A, C)]
  rule A *Int B <Int C => (0 -Int C) <Int (0 -Int A) *Int B
      requires A <Int 0
      [simplification, concrete(A, C)]
  rule A <=Int B *Int C => (0 -Int B) *Int C <=Int (0 -Int A)
      requires B <Int 0
      [simplification, concrete(A, B)]
  rule A <Int B *Int C => (0 -Int B) *Int C <Int (0 -Int A)
      requires B <Int 0
      [simplification, concrete(A, B)]

  // if A %Int B == 0 then A /Int B == A / B
  // Has tests
  rule A <=Int B *Int X => A /Int B <=Int X
      requires 0 <Int B andBool A %Int B ==Int 0
      [simplification, concrete(A, B)]
  // Has tests
  rule A <=Int B *Int X => X <=Int A /Int B
      requires B <Int 0 andBool A %Int B ==Int 0
      [simplification, concrete(A, B)]
  // Has tests
  rule A *Int X <=Int B => X <=Int B /Int A
      requires 0 <Int A andBool B %Int A ==Int 0
      [simplification, concrete(A, B)]
  // Has tests
  rule A *Int X <=Int B => B /Int A <=Int X
      requires A <Int 0 andBool B %Int A ==Int 0
      [simplification, concrete(A, B)]

  // Has tests
  rule A <Int B *Int X => A /Int B <Int X
      requires 0 <Int B andBool A %Int B ==Int 0
      [simplification, concrete(A, B)]
  // Has tests
  rule A <Int B *Int X => X <Int A /Int B
      requires B <Int 0 andBool A %Int B ==Int 0
      [simplification, concrete(A, B)]
  // Has tests
  rule A *Int X <Int B => X <Int B /Int A
      requires 0 <Int A andBool B %Int A ==Int 0
      [simplification, concrete(A, B)]
  // Has tests
  rule A *Int X <Int B => B /Int A <Int X
      requires A <Int 0 andBool B %Int A ==Int 0
      [simplification, concrete(A, B)]

  // a * b <= c
  // iff a <= c / b
  // iff a <= trunc(c/b)
  // Has tests
  rule B *Int A <=Int C => A <=Int C /Int B
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
  // Has tests
  rule B *Int A <Int C
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
  // Has tests
  rule A <=Int C *Int B
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
  // Has tests
  rule A <Int C *Int B => A /Int C <Int B
      requires 0 <Int C andBool 0 <=Int B
      [simplification, concrete(A, C)]


  // a * b <= c
  // iff a <= c / b
  // iff a <= trunc(c/b)
  // Has tests
  rule A <=Int C divIntTotal B => A *Int B <=Int C
      requires 0 <Int B andBool 0 <=Int C
      [simplification, concrete(A)]
  // a < trunc(c/b)
  // iff a + 1 <= trunc(c/b)
  // iff a + 1 <= trunc(c/b) + frac(c/b)
  // iff a + 1 <= c/b
  // iff (a + 1) * b <= c
  // Has tests
  rule A <Int C divIntTotal B => (A +Int 1) *Int B <=Int C
      requires 0 <Int B andBool 0 <=Int C
      [simplification, concrete(A)]
  // a < b * c
  // iff a / c < b
  // iff trunc(a/c) < b
  // Has tests
  rule A divIntTotal C <Int B => A <Int B *Int C
      requires 0 <Int C andBool 0 <=Int A
      [simplification, concrete(B)]
  // trunc(a/c) <= b
  // iff trunc(a/c) < b + 1
  // iff trunc(a/c) + frac(a/c) < b + 1
  // iff a / c < b + 1
  // iff a < (b + 1) * c
  // Has tests
  rule A divIntTotal C <=Int B => A <Int (B +Int 1) *Int C
      requires 0 <Int C andBool 0 <=Int A
      [simplification, concrete(B)]

  // Moved to proven-mx-lemmas.md
  // rule (_X modIntTotal Y) <Int Y => true
  //     requires Y >Int 0
  //     [simplification, smt-lemma]
  // Moved to proven-mx-lemmas.md
  // rule 0 <=Int (_X modIntTotal Y) => true
  //     requires Y >Int 0
  //     [simplification, smt-lemma]

  // Has tests
  rule 0 <=Int log2IntTotal(_:Int) => true
      [simplification, smt-lemma]
  // log2IntTotal(A) <Int B
  // iff log2IntTotal(A) <=Int B -Int 1
  // iff A <Int 2^(B -Int 1 +Int 1)
  // iff A <Int 2^B
  // Has tests
  rule log2IntTotal(A) <Int B => A <Int 2 ^Int B
      requires 0 <Int A andBool 0 <=Int B
          andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
      [simplification, concrete(B)]
  // Partly covering the case when 1000 < B
  // Has tests
  rule log2IntTotal(A) <Int B => true
      requires 0 <Int A andBool 0 <=Int B
          andBool 1000 <Int B
          andBool A <Int 2 ^Int 1000
      [simplification, concrete(B)]
  // log2IntTotal(A) <=Int B
  // iff A <Int 2^(B +Int 1)
  // Has tests
  rule log2IntTotal(A) <=Int B => A <Int 2 ^Int (B +Int 1)
      requires 0 <Int A andBool 0 <=Int B
          andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
      [simplification, concrete(B)]
  // Partly covering the case when 1000 < B
  // Has tests
  rule log2IntTotal(A) <=Int B => true
      requires 0 <Int A andBool 0 <=Int B
          andBool 1000 <Int B
          andBool A <Int 2 ^Int 1001
      [simplification, concrete(B)]
  // b <= log2Int(a)
  // iff 2^b <= a
  // Has tests
  rule B <=Int log2IntTotal(A) => 2 ^Int B <=Int A
      requires 0 <Int A andBool 0 <=Int B
          andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
      [simplification, concrete(B)]
  // Partly covering the case when 1000 < B
  // Has tests
  rule B <=Int log2IntTotal(A) => false
      requires 0 <Int A andBool 0 <=Int B
          andBool 1000 <Int B
          andBool A <Int 2 ^Int 1000
      [simplification, concrete(B)]
  // b < log2Int(a)
  // iff b + 1 <= log2Int(a)
  // iff 2^(b + 1) <= a
  // Has tests
  rule B <Int log2IntTotal(A) => 2 ^Int (B +Int 1) <=Int A
      requires 0 <Int A andBool 0 <=Int B
          andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
      [simplification, concrete(B)]
  // Partly covering the case when 1000 < B
  // Has tests
  rule B <Int log2IntTotal(A) => false
      requires 0 <Int A andBool 0 <=Int B
          andBool 1000 <Int B
          andBool A <Int 2 ^Int 1002
      [simplification, concrete(B)]

  // Has tests
  rule A <=Int log2IntTotal(_) => true
      requires A <=Int 0
      [simplification]
  // Has tests
  rule A <Int log2IntTotal(_) => true
      requires A <Int 0
      [simplification]

  // Has tests
  rule 0 =/=Int A divIntTotal B => B <=Int A
      requires 0 <=Int A andBool 0 <Int B
      [simplification]
  // Has tests
  rule 0 ==Int A divIntTotal B => A <Int B
      requires 0 <=Int A andBool 0 <Int B
      [simplification]
/*
  rule A +Int (_ &Int #bool(_)) <Int B => true
      requires A <Int B -Int 1
      [simplification]
  rule A +Int (_ &Int #bool(_)) <=Int B => true
      requires A <=Int B -Int 1
      [simplification]

  rule A +Int #bool(_) <Int B => true
      requires A <Int B -Int 1
      [simplification]
  rule A +Int #bool(_) <=Int B => true
      requires A <=Int B -Int 1
      [simplification]

  rule B <Int A +Int (_ &Int #bool(_)) => true
      requires B <Int A
      [simplification]
  rule B <=Int A +Int (_ &Int #bool(_)) => true
      requires B <=Int A
      [simplification]

  rule B <Int A +Int #bool(_) => true
      requires B <Int A
      [simplification]
  rule B <=Int A +Int #bool(_) => true
      requires B <=Int A
      [simplification]

  rule A +Int (B &Int #bool(C)) ==Int 0 => A ==Int 0 andBool (B &Int #bool(C) ==Int 0)
      requires 0 <=Int A
      [simplification]
  rule A +Int #bool(B) ==Int 0 => A ==Int 0 andBool #bool(B) ==Int 0
      requires 0 <=Int A
      [simplification]

  rule A &Int #bool(B) ==Int 0 => (A ==Int 0) orBool (#bool(B) ==Int 0)
      requires 0 <=Int A andBool A <=Int 1
      [simplification]

  rule A orBool (B orBool C) => (A orBool B) orBool C  [simplification]
  rule A andBool (B andBool C) => (A andBool B) andBool C  [simplification]

  rule (_ orBool A) andBool A => A [simplification]
  rule (A orBool _) andBool A => A [simplification]
  rule ((_ orBool A) orBool _) andBool A => A [simplification]
  rule ((A orBool _) orBool _) andBool A => A [simplification]
  rule (((_ orBool A) orBool _) orBool _) andBool A => A [simplification]
  rule (((A orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule ((((_ orBool A) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule ((((A orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule (((((_ orBool A) orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule (((((A orBool _) orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule ((((((_ orBool A) orBool _) orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule ((((((A orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule (((((((_ orBool A) orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]
  rule (((((((A orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) andBool A => A [simplification]

  rule A andBool (_ orBool A) => A [simplification]
  rule A andBool (A orBool _) => A [simplification]
  rule A andBool ((_ orBool A) orBool _) => A [simplification]
  rule A andBool ((A orBool _) orBool _) => A [simplification]
  rule A andBool (((_ orBool A) orBool _) orBool _) => A [simplification]
  rule A andBool (((A orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool ((((_ orBool A) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool ((((A orBool _) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool (((((_ orBool A) orBool _) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool (((((A orBool _) orBool _) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool ((((((_ orBool A) orBool _) orBool _) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool ((((((A orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool (((((((_ orBool A) orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) => A [simplification]
  rule A andBool (((((((A orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) orBool _) => A [simplification]
*/
endmodule
```
