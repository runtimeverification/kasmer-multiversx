```k
module SPARSE-BYTES-LEMMAS-SYNTAX
  imports SPARSE-BYTES

  syntax SparseBytes ::= concat(SparseBytes, SparseBytes)  [function, total]

  syntax SparseBytes ::= narrow(initialFormula:SparseBytes, toNarrow:SparseBytes)  [function, total]
  syntax Bool ::= isNarrowable(initialFormula:SparseBytes, toNarrow:SparseBytes)  [function, total]
endmodule

module SPARSE-BYTES-LEMMAS
  imports SPARSE-BYTES-LEMMAS-SYNTAX

  rule concat(.SparseBytes, A:SparseBytes) => A
  rule concat(A:SBItemChunk B:SparseBytes, C:SparseBytes) => A concat(B, C)

  rule concat(A, .SparseBytes) => A
      [simplification]
  rule concat(concat(A:SparseBytes, B:SparseBytes), C:SparseBytes) => concat(A, concat(B, C))
      [simplification]

  // Narrowing

  syntax ReversedSparseBytes  ::= ".ReversedSparseBytes"
                                | rconcat(SparseBytes, ReversedSparseBytes)

  syntax SparseBytes  ::= reverse(ReversedSparseBytes)  [function, total]
                        | #reverse(ReversedSparseBytes, SparseBytes)  [function, total]
  rule reverse(R:ReversedSparseBytes) => #reverse(R, .SparseBytes)
  rule #reverse(.ReversedSparseBytes, B:SparseBytes) => B
  rule #reverse(rconcat(A, B), C:SparseBytes) => #reverse(B, concat(A, C))

  syntax SparseBytes ::= structureReverse(SparseBytes, SparseBytes, Int, ReversedSparseBytes)  [function, total]

  rule structureReverse(A, SBI:SBItemChunk SB:SparseBytes, Size:Int, RSB:ReversedSparseBytes)
      => structureReverse(A, SB, Size +Int size(SBI), rconcat(SBI, RSB))
      [simplification(50)]
  rule structureReverse(A, concat(SB1:SparseBytes, SB2:SparseBytes), Size:Int, RSB:ReversedSparseBytes)
      => structureReverse(A, SB2, Size +Int size(SB1), rconcat(SB1, RSB))
      [simplification(50)]
  rule structureReverse(A, SB:SparseBytes, Size:Int, RSB:ReversedSparseBytes)
      => structureReverse(A, .SparseBytes, Size, rconcat(SB, RSB))
      [simplification(51)]

  syntax Limits ::= limits(start:Int, size:Int)
  syntax SparseBytes  ::= limit(SparseBytes)  [function, total]
                        | limitsResult(SparseBytes, Limits)  [function, total, no-evaluators]
                        | setLimits(SparseBytes, Limits)  [function, total]
                        | limitsSet(expression:SparseBytes, replaced:SparseBytes, limits:Limits)  [function, total, no-evaluators]

  syntax SparseBytes  ::= replaceArgument(expression:SparseBytes, argument:SparseBytes)  [function, total]
                        | argumentReplaced(expression:SparseBytes, replaced:SparseBytes, argument:SparseBytes)  [function, total, no-evaluators]

  syntax Bool ::= #isNarrowable(SparseBytes)  [function, total]
  syntax SparseBytes  ::= #narrow(SparseBytes)  [function, total]
                        | #narrowEnd(SparseBytes, SparseBytes)  [function, total]
                        | narrowSetup(initialFormula:SparseBytes, limits:SparseBytes, toNarrow:SparseBytes)  [function, total]
                        | narrowPrefix(initialFormula:SparseBytes, prefix:ReversedSparseBytes, limits:Limits, toNarrow:SparseBytes)  [function, total]
                        | narrowReverse(initialFormula:SparseBytes, prefix:SparseBytes, limits:Limits, reversed:SparseBytes)  [function, total]
                        | narrowSuffix(initialFormula:SparseBytes, prefix:SparseBytes, suffix:SparseBytes, limits:Limits, toNarrow:ReversedSparseBytes, toNarrowSize:Int)  [function, total]
                        | narrowLimitsEnd(initialFormula:SparseBytes, prefix:SparseBytes, suffix:SparseBytes, argument:SparseBytes, final:SparseBytes, limits:Limits)  [function, total]
                        | narrowed(initialFormula:SparseBytes, prefix:SparseBytes, argument:SparseBytes, suffix:SparseBytes)  [function, total]

  rule narrow(... initialFormula:Initial:SparseBytes, toNarrow:ToNarrow:SparseBytes)
      => #narrow(narrowSetup(... initialFormula:Initial, limits:limit(Initial), toNarrow:ToNarrow))
      [simplification]
  rule #narrow(narrowed(... initialFormula:Initial:SparseBytes, prefix:Prefix:SparseBytes, argument:Argument:SparseBytes, suffix:Suffix:SparseBytes))
      => #narrowEnd(narrowed(... initialFormula:Initial, prefix:Prefix, argument:Argument, suffix:Suffix), replaceArgument(Initial, Argument))
      [simplification]
  rule #narrowEnd
        ( narrowed(... initialFormula:Initial:SparseBytes, prefix:Prefix:SparseBytes, argument:Argument:SparseBytes, suffix:Suffix:SparseBytes)
        , argumentReplaced(Initial, Final, Argument)
        )
      => concat(Prefix, concat(Final, Suffix))
      [simplification]

  rule isNarrowable(... initialFormula:Initial:SparseBytes, toNarrow:ToNarrow:SparseBytes)
      => #isNarrowable(narrowSetup(... initialFormula:Initial, limits:limit(Initial), toNarrow:ToNarrow))
      [simplification]
  rule #isNarrowable(narrowed(... initialFormula:_:SparseBytes, prefix:Prefix:SparseBytes, argument:_:SparseBytes, suffix:Suffix:SparseBytes))
      => true
      requires 0 <Int size(Prefix) +Int size(Suffix)
      [simplification]

  rule narrowSetup(... initialFormula:Initial:SparseBytes, limits:limitsResult(_, L:Limits), toNarrow:ToNarrow:SparseBytes)
      => narrowPrefix(... initialFormula:Initial, prefix:.ReversedSparseBytes, limits:L, toNarrow:ToNarrow)
      [simplification]

  rule narrowPrefix(... initialFormula:Initial:SparseBytes, prefix:Prefix, limits:limits(Start, Size), toNarrow:(A:SBItemChunk ToNarrow:SparseBytes))
      => narrowPrefix(... initialFormula:Initial, prefix: rconcat(A, Prefix), limits:limits(Start -Int size(A), Size), toNarrow:ToNarrow)
      requires size(A) <=Int Start
      [simplification(50)]
  rule narrowPrefix(... initialFormula:Initial:SparseBytes, prefix:Prefix, limits:limits(Start, Size), toNarrow:concat(A:SparseBytes, ToNarrow:SparseBytes))
      => narrowPrefix(... initialFormula:Initial, prefix:rconcat(A, Prefix), limits:limits(Start -Int size(A), Size), toNarrow:ToNarrow)
      requires size(A) <=Int Start
      [simplification(50)]
  rule narrowPrefix(... initialFormula:Initial:SparseBytes, prefix:Prefix, limits:L:Limits, toNarrow:ToNarrow:SparseBytes)
      => narrowReverse
          ( ... initialFormula:Initial
          , prefix:reverse(Prefix)
          , limits:L
          , reversed:structureReverse(ToNarrow, ToNarrow, 0, .ReversedSparseBytes)
          )
      [simplification(51)]

  rule narrowReverse
          ( ... initialFormula:Initial:SparseBytes
          , prefix:Prefix:SparseBytes
          , limits:L:Limits
          , reversed:structureReverse(_:SparseBytes, .SparseBytes, ReversedSize:Int, Reversed:ReversedSparseBytes)
          )
      => narrowSuffix
          ( ... initialFormula:Initial
          , prefix:Prefix
          , suffix:.SparseBytes
          , limits:L
          , toNarrow:Reversed
          , toNarrowSize:ReversedSize
          )

  rule narrowSuffix
          ( ... initialFormula: Initial:SparseBytes
          , prefix: Prefix:SparseBytes
          , suffix: Suffix:SparseBytes
          , limits: limits(Start, Size)
          , toNarrow: rconcat(A:SparseBytes, ToNarrow:ReversedSparseBytes)
          , toNarrowSize: ToNarrowSize
          )
      => narrowSuffix
          (... initialFormula:Initial
          , prefix: Prefix
          , suffix: concat(A, Suffix)
          , limits: limits(Start, Size)
          , toNarrow: ToNarrow
          , toNarrowSize: ToNarrowSize -Int size(A)
          )
      requires Start +Int Size <=Int ToNarrowSize -Int size(ToNarrow)
      [simplification(50)]
  rule narrowSuffix
          ( ... initialFormula:Initial:SparseBytes
          , prefix:Prefix:SparseBytes
          , suffix:Suffix:SparseBytes
          , limits:L:Limits
          , toNarrow:ToNarrow:ReversedSparseBytes
          , toNarrowSize:_
          )
      => narrowLimitsEnd
          (... initialFormula:Initial
          , prefix: Prefix
          , suffix: Suffix
          , argument: reverse(ToNarrow)
          , final: setLimits(Initial, L)
          , limits: L
          )
      [simplification(51)]

    rule narrowLimitsEnd
          ( ... initialFormula:Initial:SparseBytes
          , prefix:Prefix:SparseBytes
          , suffix:Suffix:SparseBytes
          , argument:Argument:SparseBytes
          , final:limitsSet(Initial:SparseBytes, Final:SparseBytes, L)
          , limits:L
          )
        => narrowed
          ( ... initialFormula:Final
          , prefix: Prefix
          , argument:Argument            
          , suffix: Suffix
          )

endmodule

```
