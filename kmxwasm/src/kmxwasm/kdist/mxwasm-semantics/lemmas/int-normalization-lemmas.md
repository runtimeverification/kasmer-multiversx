Int normalization
=================

Bit expressions
---------------

The normal form of an int expression based on bit operations is defined by:

```
or-operand  = ((non-bit-int-expression &Int mask) >>Int shift)
            | ((non-bit-int-expression &Int mask) <<Int shift)
bit-based-expression = or-operand |Int or-operand |Int ...
```

where any of the mask and the shift may be missing, and the int-expression
may have only one or-operand.

In `&Int` and `|Int` expressions, the concrete operand (if any), is second.

Additionally, `bit-expression modInt power-of-2` is transformed to a bit expression.

The normalization below works properly if
* In `A &Int B` and `A |Int B`, at least one of the operands is concrete
* The second operand of `A >>Int B` and `A <<Int B` is concrete and less than 64

Arithmetic expressions
----------------------

The normal form of an arithmetic expression is less well defined.

* there are no '-' operations, `A +Int -1 *Int B` is used instead of
  `A -Int B
* Addition is grouped to the left, i.e.,
  `((..((A +Int B) +Int C) +Int ...) +Int Z)`
* Only the last element of an addition is concrete, i.e. `(A +Int B) +Int 7`
  is normal, `(A +Int 7) +Int 8` and `(A +Int 7) +Int C` are not.
* Multiplication is grouped to the right, i.e.,
  `(Z *Int (... *Int (C *Int (A *Int B)) ...))`
* Only the fist element of an addition is concrete, i.e., `7 *Int (A *Int B)`
  is normal, `8 *Int (7 *Int A)` and `C *Int (7*Int B)` are not.
* Multiplication with constants is always distributed, i.e.,
  `7 *Int A +Int 7 *Int B` is normal, `7 *Int (A +Int B)` is not.
* (Not fully enforced): Constants multiplied with the same symbolic term, then
  added, are merged, i.e., `(7 *Int A +Int B) +Int 8 *Int A` is not normal and
  will be transformed to `15 *Int A +Int B`
```k
requires "../ceils-syntax.k"

module INT-NORMALIZATION-LEMMAS-BASIC
  imports BOOL
  imports INT

  syntax Bool ::= isFullMask(Int)  [function, total]
  rule isFullMask(I:Int) => I ==Int fullMask(log2Int(I) +Int 1)
    requires 0 <Int I
  rule isFullMask(I:Int) => false
    requires I <=Int 0

  syntax Bool ::= isPowerOf2(Int)  [function, total]
  rule isPowerOf2(I:Int) => I ==Int 1 <<Int log2Int(I)
      requires 0 <Int I
  rule isPowerOf2(I:Int) => false
      requires I <=Int 0

  syntax Int ::= fullMask(Int) [function, total]
  rule fullMask(I:Int) => (1 <<Int I) -Int 1
      requires 0 <Int I
  rule fullMask(I:Int) => 0
      requires I <=Int 0
endmodule

module INT-NORMALIZATION-LEMMAS  [symbolic]
  imports private INT-BIT-NORMALIZATION-LEMMAS
  imports private INT-ARITHMETIC-NORMALIZATION-LEMMAS
endmodule

module INT-BIT-NORMALIZATION-LEMMAS  [symbolic]
  imports private CEILS-SYNTAX
  imports private INT
  imports private INT-NORMALIZATION-LEMMAS-BASIC

  rule _A &Int 0 => 0
  rule A &Int B => A
      requires 0 <=Int A
        andBool A <=Int B
        andBool isFullMask(B)
      [simplification, concrete(B)]
  rule (A &Int B) => 0
      requires 0 <=Int A
        andBool (
            ( A <=Int fullMask(8)
              andBool B &Int fullMask(8) ==Int 0
            )
            orBool ( A <=Int fullMask(16)
              andBool B &Int fullMask(16) ==Int 0
            )
            orBool ( A <=Int fullMask(32)
              andBool B &Int fullMask(32) ==Int 0
            )
        )
      [simplification]
  rule A &Int B => B &Int A
      [simplification, concrete(A), symbolic(B)]
  rule (A &Int B) &Int C => A &Int (B &Int C)
      [simplification, concrete(B, C)]
  rule A &Int (B &Int C) => (A &Int B) &Int C
      [simplification, symbolic(A, B)]

  rule (A <<IntTotal B) &Int M
        => (A &Int (M >>Int B)) <<IntTotal B
      requires 0 <=Int B
          andBool 1 <<Int B <=Int M +Int 1
      [simplification, concrete(M, B), preserves-definedness]
  rule (_A <<IntTotal B) &Int M => 0
      requires 0 <=Int M
          andBool 0 <=Int B
          andBool M <Int (1 <<Int B)
      [simplification]
  rule (A >>IntTotal B) &Int M
        => (A &Int (M <<Int B)) >>IntTotal B
      requires 0 <=Int B
      [simplification, concrete(M, B), preserves-definedness]

  rule (A <<IntTotal 0) => A
      [simplification]
  rule (A >>IntTotal 0) => A
      [simplification]
  rule (A >>IntTotal B) => 0
      requires 0 <=Int A andBool 0 <Int B andBool A <=Int fullMask(B)
      [simplification, concrete(B)]
  rule (A >>IntTotal B) >>IntTotal C => A >>IntTotal (B +Int C)
      [simplification, concrete(B, C)]
  rule (A <<IntTotal B) <<IntTotal C => A <<IntTotal (B +Int C)
      [simplification, concrete(B, C)]
  rule (A <<IntTotal B) >>IntTotal C => A <<IntTotal (B -Int C)
      requires C <=Int B
      [simplification, concrete(B, C)]
  rule (A <<IntTotal B) >>IntTotal C => A >>IntTotal (C -Int B)
      requires B <Int C
      [simplification, concrete(B, C)]
  rule (A >>IntTotal B) <<IntTotal C
      => (A >>IntTotal (B -Int C))
        &Int (fullMask(64) -Int fullMask(C))
      requires 0 <=Int C
          andBool C <=Int B
          andBool B <=Int 64
          andBool 0 <=Int A
          andBool A <Int (1 <<Int 64)
      [simplification, concrete(B, C)]
  rule (A >>IntTotal B) <<IntTotal C
      => (A <<IntTotal (C -Int B))
        &Int (fullMask(64) -Int fullMask(C))
      requires 0 <=Int B
          andBool B <Int C
          andBool C <=Int 64
          andBool 0 <=Int A
          andBool A <Int (1 <<Int (64 -Int (C -Int B)))
      [simplification, concrete(B, C)]

  rule A |Int 0 => A
      [simplification]
  rule A |Int B => B |Int A
      [simplification, concrete(A), symbolic(B)]
  rule (A |Int B) |Int C => A |Int (B |Int C)
      [simplification, concrete(B, C)]
  rule A |Int (B |Int C) => (A |Int B) |Int C
      [simplification, symbolic(A, B)]

  rule (A |Int B) &Int C => (A &Int C) |Int (B &Int C)
      [simplification]
  rule A &Int (B |Int C) => (A |Int C) &Int (B |Int C)
      [simplification, symbolic(B)]
  rule A &Int (B |Int C) => (A |Int C) &Int (B |Int C)
      [simplification, symbolic(C)]
  rule (A &Int B) |Int (A &Int C)
      => A &Int (B |Int C)
      [simplification, concrete(B, C)]
  rule (A |Int B) >>IntTotal C => (A >>IntTotal C) |Int (B >>IntTotal C)
      requires 0 <=Int C
      [simplification]
  rule (A |Int B) <<IntTotal C => (A <<IntTotal C) |Int (B <<IntTotal C)
      requires 0 <=Int C
      [simplification]

  rule (A &Int B) modIntTotal M => (A &Int B) &Int (M -Int 1)
      requires (0 <=Int A orBool 0 <=Int B)
        andBool isPowerOf2(M)
      [simplification]
  rule (A >>IntTotal B) modIntTotal M => (A >>IntTotal B) &Int (M -Int 1)
      requires 0 <=Int A
        andBool isPowerOf2(M)
      [simplification]
  rule (A <<IntTotal B) modIntTotal M => (A <<IntTotal B) &Int (M -Int 1)
      requires 0 <=Int A
        andBool isPowerOf2(M)
      [simplification]
  rule (A |Int B) modIntTotal M => (A |Int B) &Int (M -Int 1)
      requires 0 <=Int A
        andBool 0 <=Int B
        andBool isPowerOf2(M)
      [simplification]

  rule (A modIntTotal M) &Int B => (A &Int (M -Int 1)) &Int B
      requires (0 <=Int A orBool 0 <=Int B)
        andBool isPowerOf2(M)
      [simplification]
  rule (A modIntTotal M) >>IntTotal B => (A &Int (M -Int 1)) >>IntTotal B
      requires 0 <=Int A
        andBool isPowerOf2(M)
      [simplification]
  rule (A modIntTotal M) <<IntTotal B => (A &Int (M -Int 1)) <<IntTotal B
      requires 0 <=Int A
        andBool isPowerOf2(M)
      [simplification]
  rule (A modIntTotal M) |Int B => (A &Int (M -Int 1)) |Int B
      requires 0 <=Int A
        andBool 0 <=Int B
        andBool isPowerOf2(M)
      [simplification]

  // Rules for having saner masks.
  rule A &Int B => A &Int (B &Int fullMask(8))
      requires fullMask(8) <Int B andBool 0 <=Int A andBool A <=Int fullMask(8)
      [simplification, concrete(B)]
  rule A &Int B => A &Int (B &Int fullMask(16))
      requires fullMask(16) <Int B andBool 0 <=Int A andBool A <=Int fullMask(16)
      [simplification, concrete(B)]
  rule A &Int B => A &Int (B &Int fullMask(24))
      requires fullMask(24) <Int B andBool 0 <=Int A andBool A <=Int fullMask(24)
      [simplification, concrete(B)]
  rule A &Int B => A &Int (B &Int fullMask(32))
      requires fullMask(32) <Int B andBool 0 <=Int A andBool A <=Int fullMask(32)
      [simplification, concrete(B)]
  rule A &Int B => A &Int (B &Int fullMask(40))
      requires fullMask(40) <Int B andBool 0 <=Int A andBool A <=Int fullMask(40)
      [simplification, concrete(B)]
  rule A &Int B => A &Int (B &Int fullMask(48))
      requires fullMask(48) <Int B andBool 0 <=Int A andBool A <=Int fullMask(48)
      [simplification, concrete(B)]
  rule A &Int B => A &Int (B &Int fullMask(56))
      requires fullMask(56) <Int B andBool 0 <=Int A andBool A <=Int fullMask(56)
      [simplification, concrete(B)]

  rule {0 #Equals (A &Int B) >>IntTotal C }
      => { 0 #Equals A &Int B }
      requires B &Int fullMask(C) ==Int 0
      [simplification, concrete(B, C)]
  rule {0 #Equals A &Int 4278190080 }
      => {true #Equals A <=Int fullMask(24) }
      requires 0 <=Int A andBool A <=Int fullMask(32)
      [simplification]
  rule {0 #Equals A &Int 16711680 }
      => {true #Equals A <=Int fullMask(16) }
      requires 0 <=Int A andBool A <=Int fullMask(24)
      [simplification]
  rule {0 #Equals A &Int 65280 }
      => {true #Equals A <=Int fullMask(8) }
      requires 0 <=Int A andBool A <=Int fullMask(16)
      [simplification]
endmodule

module INT-ARITHMETIC-NORMALIZATION-LEMMAS
  imports private CEILS-SYNTAX
  imports private INT

  // To get the normal form for a formula with + and -, we first replace
  // X - Y by X + (-1) * Y.
  //
  // Then, the normal form for a formula based on addition (+) is:
  // ((...((symbolic + symbolic) + symbolic) + ...) + symbolic) + concrete.
  //
  // The rules below complement the ones in INT-KORE
  rule X -Int Y => X +Int (-1 *Int Y)  [simplification]
  rule X +Int (Y +Int Z) => (X +Int Y) +Int Z  [simplification]

  rule I +Int X => X +Int I  [simplification, symbolic(X), concrete(I)]
  rule (X +Int I) +Int Y => (X +Int Y) +Int I  [simplification, symbolic(X, Y), concrete(I)]

  // The normal form for a formula based on * is:
  // concrete * (symbolic * (...(symbolic * (symbolic * symbolic))...)).
  rule (X *Int Y) *Int Z => X *Int (Y *Int Z)  [simplification]

  rule X *Int I => I *Int X  [simplification, symbolic(X), concrete(I)]
  rule X *Int (I *Int Y) => I *Int (X *Int Y)  [simplification, symbolic(X, Y), concrete(I)]
  rule I1 *Int (I2 *Int X) => (I1 *Int I2) *Int X  [simplification, symbolic(X), concrete(I1, I2)]

  rule 1 *Int X => X  [simplification]
  rule 0 *Int _ => 0  [simplification]

  // Distributivity for multiplication with constants.
  rule I *Int (X +Int Y) => I *Int X +Int I *Int Y
      [simplification, symbolic(X), concrete(I)]
  rule I *Int (X +Int Y) => I *Int X +Int I *Int Y
      [simplification, symbolic(Y), concrete(I)]

  // Reverse distributivity for different-constants * same-term.
  //
  // It would be really nice if the backend would check the equality for the
  // two occurrences of X by matching. The next best option is to make these
  // rules low-priority, so they are applied only after the formula has already
  // stabilized (including normalization).
  rule X +Int X => 2 *Int X  [simplification(200)]
  rule X +Int I *Int X => (1 +Int I) *Int X  [simplification(200), concrete(I)]
  rule I *Int X +Int X => (1 +Int I) *Int X  [simplification(200), concrete(I)]
  rule I1 *Int X +Int I2 *Int X => (I1 +Int I2) *Int X  [simplification(200), concrete(I1, I2)]

  // The backends do not allow to do meta-manipulation of terms (e.g. to sort
  // them by some criteria), so this is an attempt to catch the most common
  // non-basic cases for reverse distributivity:

  // Distance 1:
  rule (X +Int Y) +Int X => 2 *Int X +Int Y
      [simplification(200)]
  rule (X +Int Y) +Int I *Int X => (1 +Int I) *Int X +Int Y
      [simplification(200), concrete(I)]
  rule (I *Int X +Int Y) +Int X => (1 +Int I) *Int X +Int Y
      [simplification(200), concrete(I)]
  rule (I1 *Int X +Int Y) +Int I2 *Int X => (I1 +Int I2) *Int X +Int Y
      [simplification(200), symbolic(X), concrete(I1, I2)]

  rule (Y +Int X) +Int X => Y +Int 2 *Int X
      [simplification(200)]
  rule (Y +Int X) +Int I *Int X => Y +Int (1 +Int I) *Int X
      [simplification(200), concrete(I)]
  rule (Y +Int I *Int X) +Int X => Y +Int (1 +Int I) *Int X
      [simplification(200), concrete(I)]
  rule (Y +Int I1 *Int X) +Int I2 *Int X => Y +Int (I1 +Int I2) *Int X
      [simplification(200), concrete(I1, I2)]

  // Distance 2:
  rule ((X +Int Y) +Int Z) +Int X => (2 *Int X +Int Y) +Int Z
      [simplification(200)]
  rule ((X +Int Y) +Int Z) +Int I *Int X => ((1 +Int I) *Int X +Int Y) +Int Z
      [simplification(200), concrete(I)]
  rule ((I *Int X +Int Y) +Int Z) +Int X => ((1 +Int I) *Int X +Int Y) +Int Z
      [simplification(200), concrete(I)]
  rule ((I1 *Int X +Int Y) +Int Z) +Int I2 *Int X => ((I1 +Int I2) *Int X +Int Y) +Int Z
      [simplification(200), symbolic(X), concrete(I1, I2)]

  rule ((Y +Int X) +Int Z) +Int X => (Y +Int 2 *Int X) +Int Z
      [simplification(200)]
  rule ((Y +Int X) +Int Z) +Int I *Int X => (Y +Int (1 +Int I) *Int X) +Int Z
      [simplification(200), concrete(I)]
  rule ((Y +Int I *Int X) +Int Z) +Int X => (Y +Int (1 +Int I) *Int X) +Int Z
      [simplification(200), concrete(I)]
  rule ((Y +Int I1 *Int X) +Int Z) +Int I2 *Int X => (Y +Int (I1 +Int I2) *Int X) +Int Z
      [simplification(200), concrete(I1, I2)]

  // Distance 3:
  rule (((X +Int Y) +Int Z) +Int T) +Int X => ((2 *Int X +Int Y) +Int Z) +Int T
      [simplification(200)]
  rule (((X +Int Y) +Int Z) +Int T) +Int I *Int X => (((1 +Int I) *Int X +Int Y) +Int Z) +Int T
      [simplification(200), concrete(I)]
  rule (((I *Int X +Int Y) +Int Z) +Int T) +Int X => (((1 +Int I) *Int X +Int Y) +Int T) +Int Z
      [simplification(200), concrete(I)]
  rule (((I1 *Int X +Int Y) +Int Z) +Int T) +Int I2 *Int X => (((I1 +Int I2) *Int X +Int Y) +Int T) +Int Z
      [simplification(200), symbolic(X), concrete(I1, I2)]

  rule (((Y +Int X) +Int Z) +Int T) +Int X => ((Y +Int 2 *Int X) +Int Z) +Int T
      [simplification(200)]
  rule (((Y +Int X) +Int Z) +Int T) +Int I *Int X => ((Y +Int (1 +Int I) *Int X) +Int Z) +Int T
      [simplification(200), concrete(I)]
  rule (((Y +Int I *Int X) +Int Z) +Int T) +Int X => ((Y +Int (1 +Int I) *Int X) +Int Z) +Int T
      [simplification(200), concrete(I)]
  rule (((Y +Int I1 *Int X) +Int Z) +Int T) +Int I2 *Int X => ((Y +Int (I1 +Int I2) *Int X) +Int Z) +Int T
      [simplification(200), concrete(I1, I2)]

  // Distance 4:
  rule ((((X +Int Y) +Int Z) +Int T) +Int S) +Int X => (((2 *Int X +Int Y) +Int Z) +Int T) +Int S
      [simplification(200)]
  rule ((((X +Int Y) +Int Z) +Int T) +Int S) +Int I *Int X => ((((1 +Int I) *Int X +Int Y) +Int Z) +Int T) +Int S
      [simplification(200), concrete(I)]
  rule ((((I *Int X +Int Y) +Int Z) +Int T) +Int S) +Int X => ((((1 +Int I) *Int X +Int Y) +Int T) +Int S) +Int Z
      [simplification(200), concrete(I)]
  rule ((((I1 *Int X +Int Y) +Int Z) +Int T) +Int S) +Int I2 *Int X => ((((I1 +Int I2) *Int X +Int Y) +Int T) +Int S) +Int Z
      [simplification(200), symbolic(X), concrete(I1, I2)]

  rule ((((Y +Int X) +Int Z) +Int T) +Int S) +Int X => (((Y +Int 2 *Int X) +Int Z) +Int S) +Int T
      [simplification(200)]
  rule ((((Y +Int X) +Int Z) +Int T) +Int S) +Int I *Int X => (((Y +Int (1 +Int I) *Int X) +Int Z) +Int T) +Int S
      [simplification(200), concrete(I)]
  rule ((((Y +Int I *Int X) +Int Z) +Int T) +Int S) +Int X => (((Y +Int (1 +Int I) *Int X) +Int Z) +Int T) +Int S
      [simplification(200), concrete(I)]
  rule ((((Y +Int I1 *Int X) +Int Z) +Int T) +Int S) +Int I2 *Int X => (((Y +Int (I1 +Int I2) *Int X) +Int Z) +Int T) +Int S
      [simplification(200), concrete(I1, I2)]

  rule (((X modIntTotal Y) +Int Z) +Int T) modIntTotal Y => (X +Int Z +Int T) modIntTotal Y
      [simplification]
  rule (((X modIntTotal Y) +Int Z) -Int T) modIntTotal Y => (X +Int Z -Int T) modIntTotal Y
      [simplification]
  rule ((X modIntTotal Y) +Int Z) modIntTotal Y => (X +Int Z) modIntTotal Y
      [simplification]
  rule (X +Int (Z modIntTotal Y)) modIntTotal Y => (X +Int Z) modIntTotal Y
      [simplification]

  rule (X +Int Y) modIntTotal Z => (X +Int (Y modInt Z)) modIntTotal Z
      requires Z =/=Int 0 andBool Y >=Int Z
      [simplification, concrete(Y, Z), preserves-definedness]
  rule {((X +Int Y) modIntTotal M) #Equals ((X +Int Z) modIntTotal M)}
      => {(Y modIntTotal M) #Equals (Z modIntTotal M)}
      [simplification]
  rule X modIntTotal Y => X requires 0 <=Int X andBool X <Int Y

  rule {(A modIntTotal C) #Equals (B modIntTotal C)} => #Top
      requires A ==Int B
      [simplification]


  rule {0 #Equals A ^IntTotal _B} => #Bottom
      requires A =/=Int 0
      [simplification(40)]
  rule {A ^IntTotal _B #Equals 0} => #Bottom
      requires A =/=Int 0
      [simplification(40)]
  rule {0 #Equals A ^IntTotal B} => {0 #Equals A}
      requires B =/=Int 0
      [simplification(50)]

  rule {0 #Equals A divIntTotal B} => {true #Equals A <Int B}
      requires 0 <=Int A andBool 0 <Int B
      [simplification]
  rule {A divIntTotal B #Equals 0} => {true #Equals A <Int B}
      requires 0 <=Int A andBool 0 <Int B
      [simplification]

  // log2IntTotal(X) is the index of the highest bit. This means that
  // X < 2^(log2IntTotal(X) + 1) since the highest bit of the right term
  // has a higher index.
  // We need
  // 2^(log2IntTotal(X) + 1) <= 2 ^IntTotal (((log2IntTotal(X) +Int 8) divIntTotal 8) *Int 8)
  // which is equivalent to
  // log2IntTotal(X) + 1 <= ((log2IntTotal(X) +Int 8) divIntTotal 8) *Int 8.
  // Let us denote log2IntTotal(X) by Y >= 0
  // Y + 1 <= (Y divIntTotal 8 + 1) *Int 8.
  // Y + 1 <= (Y divIntTotal 8) *Int 8 + 8.
  // Y <= (Y divIntTotal 8) *Int 8 + 7.
  // Let A be Y divIntTotal 8
  // Let B be Y modIntTotal 8.
  // A * 8 + B <= A * 8 + 7, which is obviously true.
  rule A:Int <Int 2 ^IntTotal (8 *Int (( log2IntTotal(A) +Int 8) divIntTotal 8))
      => true
      requires 0 <Int A
      [simplification]
endmodule
```
