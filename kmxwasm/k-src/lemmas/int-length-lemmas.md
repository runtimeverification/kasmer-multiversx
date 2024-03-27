```k
module INT-LENGTH-LEMMAS  [symbolic]
  imports BOOL
  imports INT

  syntax Int ::= lenghtInBytes(Int)  [function]
  rule lenghtInBytes(A) => (log2Int(A) +Int 8) divInt 8

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
  rule maxForLength(A) => 2 ^Int (A *Int 8) - 1 requires 0 <Int A


  syntax Bool ::= aLessThanLenBinSearchUp(a:Int, b:Int, low:Int, high:Int)  [function, total]

  // Expected input data:
  //    * 0 <= A, X
  //    * 0 <Int B, Y
  //    * X <Int Y
  //    * Concrete X, Y
  // Invariant (preserved, not enforced): maxForLength(X) <Int B
  // Exit condition: B <=Int maxForLength(Y)
  rule aLessThanLenBinSearchUp(A, B, X, Y)
      => aLessThanLenBinSearchUp(A, B, Y, 2 *Int Y)
      requires maxForLength(Y) <Int B andBool Y <Int 10000 andBool 0 <Int Y
  rule aLessThanLenBinSearchUp(A, B, X, Y)
      => aLessThanLenBinSearchMid(A, B, X, Y)
      requires B <=Int maxForLength(Y)

  syntax Bool ::= aLessThanLenBinSearchMid(a:Int, b:Int, low:Int, high:Int)  [function, total]
  rule aLessThanLenBinSearchMid(A, B, X, Y) => true
      requires A <=Int maxForLength(X)
  rule aLessThanLenBinSearchMid(A, B, X, Y) => false
      requires maxForLength(Y) <Int A
  rule aLessThanLenBinSearchMid(A, B, X, Y) => aLessThanLenBinSearchMid(A, B, X, (X +Int Y) /Int 2)
      requires X <Int Y -Int 1 andBool B <=Int maxForLength((X +Int Y) /Int 2)
  rule aLessThanLenBinSearchMid(A, B, X, Y) => aLessThanLenBinSearchMid(A, B, (X +Int Y) /Int 2, Y)
      requires X <Int Y -Int 1 andBool maxForLength((X +Int Y) /Int 2) <Int B


  rule A <Int (log2IntTotal(B) +Int 8) divIntTotal 8 => false
      requires aLessThanLenBinSearchUp(A, B, 1, 2)
        andBool 0 <Int B
      [simplification]


endmodule
```