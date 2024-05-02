```k
requires "../ceils-syntax.k"

module INT-LENGTH-LEMMAS-BASIC
  imports BINARY-SEARCH-SYNTAX
  imports INT

  syntax Int ::= lengthInBytes(Int)  [function]
  rule lengthInBytes(A) => (log2Int(A) +Int 8) divInt 8

  syntax Int ::= maxForLength(Int)  [function]
  // We want the largest X for which
  // A = (log2IntTotal(X) +Int 8) divIntTotal 8
  // We want the largest X which means the largest log2IntTotal(X) +Int 8, which means
  // (log2IntTotal(X) +Int 8) modInt 8 == 7, which means
  // A * 8 + 7 == log2IntTotal(X) +Int 8, i.e.,
  // A * 8 - 1 == log2IntTotal(X)
  // But 2 ^ log2IntTotal(X) <=Int X <Int 2 ^ (log2IntTotal(X) + 1), so
  // the maximum X for a given log2IntTotal(X) value is
  // 2 ^ (log2IntTotal(X) + 1) - 1.
  //
  // This means that X is 2 ^ (A * 8 - 1 + 1) - 1, i.e.,
  // X = 2 ^ (A * 8) - 1
  rule maxForLength(A) => 2 ^Int (A *Int 8) -Int 1 requires 0 <Int A

  syntax BinSearchBeforeLambda ::= ValueLessMFL(Int)
  rule evaluate(ValueLessMFL(B), X) => B <=Int maxForLength(X)
endmodule

module INT-LENGTH-LEMMAS  [symbolic]
  imports BINARY-SEARCH
  imports BOOL
  imports CEILS-SYNTAX
  imports INT
  imports INT-LENGTH-LEMMAS-BASIC

  rule lengthBytes(Int2Bytes(A:Int, BE, Unsigned)) => lengthInBytes(A)
      requires 0 <Int A
      [simplification]

  rule A <Int (log2IntTotal(B) +Int 8) divIntTotal 8 => false
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(A), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule A <=Int (log2IntTotal(B) +Int 8) divIntTotal 8 => false
      requires findLowerUnknown(ValueLessMFL(B), LtThan(A), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule A <Int -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => true
      // ((log2IntTotal(B) +Int 8) divIntTotal 8) <Int -A
      requires findLowerUnknown(ValueLessMFL(B), LtThan((-1) *Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule A <=Int -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => true
      // ((log2IntTotal(B) +Int 8) divIntTotal 8) <=Int -A
      requires findLowerUnknown(ValueLessMFL(B), LeqThan((-1) *Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule A <Int -1 *Int (((log2IntTotal(B) +Int 8) divIntTotal 8)) => false
      requires 0 <=Int A
        andBool 0 <Int B
      [simplification]
  rule A <=Int -1 *Int (((log2IntTotal(B) +Int 8) divIntTotal 8)) => false
      requires 0 <Int A
        andBool 0 <Int B
      [simplification]

  rule (log2IntTotal(B) +Int 8) divIntTotal 8 <Int A => true
      requires findLowerUnknown(ValueLessMFL(B), LtThan(A), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule (log2IntTotal(B) +Int 8) divIntTotal 8 <=Int A => true
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(A), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <Int A => false
      // -A <Int (log2IntTotal(B) +Int 8) divIntTotal 8
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(-1 *Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <=Int A => false
      // -A <=Int (log2IntTotal(B) +Int 8) divIntTotal 8
      requires findLowerUnknown(ValueLessMFL(B), LtThan(-1 *Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <Int A => true
      requires 0 <=Int A
        andBool 0 <Int B
      [simplification]
  rule -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <=Int A => true
      requires 0 <Int A
        andBool 0 <Int B
      [simplification]

  rule A +Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <=Int C => true
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(C -Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule A +Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <Int C => true
      requires findLowerUnknown(ValueLessMFL(B), LtThan(C -Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule C <Int A +Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => false
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(C -Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule C <=Int A +Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => false
      requires findLowerUnknown(ValueLessMFL(B), LtThan(C -Int A), 1, 10000)
        andBool 0 <Int B
      [simplification]

  // The four rules below, when multiplied by -1, are the same as the four above.
  rule A +Int -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <=Int C => false
      requires findLowerUnknown(ValueLessMFL(B), LtThan(A -Int C), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule A +Int -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) <Int C => false
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(A -Int C), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule C <Int A +Int -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => true
      requires findLowerUnknown(ValueLessMFL(B), LtThan(A -Int C), 1, 10000)
        andBool 0 <Int B
      [simplification]
  rule C <=Int A +Int -1 *Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => true
      requires findLowerUnknown(ValueLessMFL(B), LeqThan(A -Int C), 1, 10000)
        andBool 0 <Int B
      [simplification]

  rule 0 <Int ((log2IntTotal(B) +Int 8) divIntTotal 8) => true requires 0 <Int B
      [simplification, smt-lemma]
endmodule

module BINARY-SEARCH-SYNTAX
  imports BOOL
  imports INT

  syntax Bool ::= evaluate(BinSearchResultLambda, min:Int, max:Int)  [function, total, no-evaluators]

  syntax BinSearchBeforeLambda
  syntax Bool ::= evaluate(BinSearchBeforeLambda, Int)  [function, total]

  syntax Bool ::= findLowerUnknown(BinSearchBeforeLambda, BinSearchResultLambda, min:Int, max:Int)
      [function, total, no-evaluators]

  syntax BinSearchResultLambda ::=  GeqThan(Int)
                                  | GtThan(Int)
                                  | LeqThan(Int)
                                  | LtThan(Int)
endmodule

module BINARY-SEARCH [symbolic]
  imports BINARY-SEARCH-SYNTAX

  rule findLowerUnknown(_:BinSearchBeforeLambda, R:BinSearchResultLambda, Min, Max)
      => evaluate(R, Min, Max)
      requires Max <=Int Min +Int 1

  rule findLowerUnknown(B:BinSearchBeforeLambda, R:BinSearchResultLambda, Min, Max)
      => findLowerUnknown(B, R, Min, (Min +Int Max) /Int 2)
      requires Min <Int Max -Int 1
        andBool evaluate(B, (Min +Int Max) /Int 2)
      [simplification(50)]
  rule findLowerUnknown(B:BinSearchBeforeLambda, R:BinSearchResultLambda, Min, Max)
      => findLowerUnknown(B, R, (Min +Int Max) /Int 2, Max)
      requires Min <Int Max -Int 1
      [simplification(51)]

  rule evaluate(GeqThan(A), _:Int, Max:Int) => true
      requires A <=Int Max
  rule evaluate(GtThan(A), _:Int, Max:Int) => true
      requires A <Int Max
  rule evaluate(LtThan(A), _:Int, Max:Int) => true
      requires Max <Int A
  rule evaluate(LeqThan(A), _:Int, Max:Int) => true
      requires Max <=Int A
endmodule

```