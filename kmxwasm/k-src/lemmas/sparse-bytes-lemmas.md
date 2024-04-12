```k
module SPARSE-BYTES-LEMMAS-SYNTAX
  imports SPARSE-BYTES

  syntax Expression

  syntax SparseBytes ::= narrowSparseBytes(initialFormula: Expression, toNarrow: SparseBytes)  [function, total]
  syntax Int ::= narrowInt(initialFormula: Expression, toNarrow: SparseBytes)  [function, total]

  syntax Bool ::= isNarrowable(initialFormula: Expression, toNarrow: SparseBytes)  [function, total]

  syntax SparseBytes ::= sparseBytesFromExpression(Expression)  [function, total]
  syntax Int ::= intFromExpression(Expression)  [function, total]

  syntax Limits ::= limits(start: Int, size: Int)
  syntax Expression ::= extractLimit(Expression)  [function, total]
                      | limitExtracted(Expression, Limits)  [function, total, no-evaluators]
                      | setLimits(Expression, Limits)  [function, total]
                      | limitsSet(expression: Expression, replaced: Expression, limits: Limits)  [function, total, no-evaluators]

  syntax Expression ::= extractArgument(expression: Expression)  [function, total]
                      | argumentExtracted(expression: Expression, argument: SparseBytes)  [function, total]
                      | replaceArgument(expression: Expression, argument: SparseBytes)  [function, total]
                      | argumentReplaced(expression: Expression, replaced: Expression, argument: SparseBytes)  [function, total, no-evaluators]

endmodule

module SPARSE-BYTES-LEMMAS
  imports private SPARSE-BYTES-LEMMAS-BASIC
  imports SPARSE-BYTES-LEMMAS-SYNTAX

  // Narrowing

  syntax ReversedSparseBytes  ::= ".ReversedSparseBytes"
                                | rconcat(SparseBytes, ReversedSparseBytes)

  syntax SparseBytes  ::= reverse(ReversedSparseBytes)  [function, total]
                        | #reverse(ReversedSparseBytes, SparseBytes)  [function, total]
  rule reverse(R:ReversedSparseBytes) => #reverse(R, .SparseBytes)
  rule #reverse(.ReversedSparseBytes, B:SparseBytes) => B
  rule #reverse(rconcat(A, B), C:SparseBytes) => #reverse(B, concat(A, C))

  syntax SparseBytes  ::= structureReverse(SparseBytes, SparseBytes, Int, ReversedSparseBytes)  [function, total]
                        | structureReverseDone(SparseBytes, Int, ReversedSparseBytes)  [function, total, no-evaluators]

  rule structureReverse(A, SBI:SBItemChunk SB:SparseBytes, Size:Int, RSB:ReversedSparseBytes)
      => structureReverse(A, SB, Size +Int size(SBI), rconcat(SBI, RSB))
      [simplification(50)]
  rule structureReverse(A, concat(SB1:SparseBytes, SB2:SparseBytes), Size:Int, RSB:ReversedSparseBytes)
      => structureReverse(A, SB2, Size +Int size(SB1), rconcat(SB1, RSB))
      [simplification(50)]
  rule structureReverse(A, SB:SparseBytes, Size:Int, RSB:ReversedSparseBytes)
      => structureReverseDone(A, Size +Int size(SB), rconcat(SB, RSB))
      [simplification(51)]

  syntax Bool ::= #isNarrowable(Expression)  [function, total]
  syntax SparseBytes  ::= #narrow(Expression)  [function, total]
                        | #narrowEnd(Expression, Expression)  [function, total]
  syntax Int          ::= #narrowInt(Expression)  [function, total]
                        | #narrowEndInt(Expression, Expression)  [function, total]
  syntax Expression   ::= narrowSetup(initialFormula: Expression, limits: Expression, toNarrow: SparseBytes)  [function, total]
                        | narrowPrefix(initialFormula: Expression, prefix: ReversedSparseBytes, limits: Limits, toNarrow: SparseBytes)  [function, total]
                        | narrowReverse(initialFormula: Expression, prefix: SparseBytes, limits: Limits, reversed: SparseBytes)  [function, total]
                        | narrowSuffix(initialFormula: Expression, prefix: SparseBytes, suffix: SparseBytes, limits: Limits, toNarrow: ReversedSparseBytes, toNarrowSize: Int)  [function, total]
                        | narrowLimitsEnd(initialFormula: Expression, prefix: SparseBytes, suffix: SparseBytes, argument: SparseBytes, final: Expression, limits: Limits)  [function, total]
                        | narrowed(initialFormula: Expression, prefix: SparseBytes, argument: SparseBytes, suffix: SparseBytes)  [function, total, no-evaluators]

  rule narrowSparseBytes(... initialFormula: Initial:Expression, toNarrow: ToNarrow:SparseBytes)
      => #narrow(narrowSetup(... initialFormula: Initial, limits: extractLimit(Initial), toNarrow: ToNarrow))
      [simplification]
  rule #narrow(narrowed(... initialFormula: Initial:Expression, prefix: Prefix:SparseBytes, argument: Argument:SparseBytes, suffix: Suffix:SparseBytes))
      => #narrowEnd(narrowed(... initialFormula: Initial, prefix: Prefix, argument: Argument, suffix: Suffix), replaceArgument(Initial, Argument))
      [simplification]
  rule #narrowEnd
        ( narrowed(... initialFormula: Initial:Expression, prefix: Prefix:SparseBytes, argument: Argument:SparseBytes, suffix: Suffix:SparseBytes)
        , argumentReplaced(Initial, Final:Expression, Argument)
        )
      => concat(Prefix, concat(sparseBytesFromExpression(Final), Suffix))
      [simplification]

  rule narrowInt(... initialFormula: Initial:Expression, toNarrow: ToNarrow:SparseBytes)
      => #narrowInt(narrowSetup(... initialFormula: Initial, limits: extractLimit(Initial), toNarrow: ToNarrow))
      [simplification]
  rule #narrowInt(narrowed(... initialFormula: Initial:Expression, prefix: Prefix:SparseBytes, argument: Argument:SparseBytes, suffix: Suffix:SparseBytes))
      => #narrowEndInt(narrowed(... initialFormula: Initial, prefix: Prefix, argument: Argument, suffix: Suffix), replaceArgument(Initial, Argument))
      [simplification]
  rule #narrowEndInt
        ( narrowed(... initialFormula: Initial:Expression, prefix: _Prefix:SparseBytes, argument: Argument:SparseBytes, suffix: _Suffix:SparseBytes)
        , argumentReplaced(Initial, Final:Expression, Argument)
        )
      => intFromExpression(Final)
      [simplification]



  rule isNarrowable(... initialFormula: Initial:Expression, toNarrow: ToNarrow:SparseBytes)
      => #isNarrowable(narrowSetup(... initialFormula: Initial, limits: extractLimit(Initial), toNarrow: ToNarrow))
      [simplification]
  rule #isNarrowable(narrowed(... initialFormula: _:Expression, prefix: Prefix:SparseBytes, argument: _:SparseBytes, suffix: Suffix:SparseBytes))
      => true
      requires 0 <Int size(Prefix) +Int size(Suffix)
      [simplification]

  rule narrowSetup(... initialFormula: Initial:Expression, limits: limitExtracted(_, L:Limits), toNarrow: ToNarrow:SparseBytes)
      => narrowPrefix(... initialFormula: Initial, prefix: .ReversedSparseBytes, limits: L, toNarrow: ToNarrow)
      [simplification]

  rule narrowPrefix(... initialFormula: Initial:Expression, prefix: Prefix, limits: limits(Start, Size), toNarrow: (A:SBItemChunk ToNarrow:SparseBytes))
      => narrowPrefix(... initialFormula: Initial, prefix: rconcat(A, Prefix), limits: limits(Start -Int size(A), Size), toNarrow: ToNarrow)
      requires size(A) <=Int Start
      [simplification(50)]
  rule narrowPrefix(... initialFormula: Initial:Expression, prefix: Prefix, limits: limits(Start, Size), toNarrow: concat(A:SparseBytes, ToNarrow:SparseBytes))
      => narrowPrefix(... initialFormula: Initial, prefix: rconcat(A, Prefix), limits: limits(Start -Int size(A), Size), toNarrow: ToNarrow)
      requires size(A) <=Int Start
      [simplification(50)]
  rule narrowPrefix(... initialFormula: Initial:Expression, prefix: Prefix, limits: L:Limits, toNarrow: ToNarrow:SparseBytes)
      => narrowReverse
          ( ... initialFormula: Initial
          , prefix: reverse(Prefix)
          , limits: L
          , reversed: structureReverse(ToNarrow, ToNarrow, 0, .ReversedSparseBytes)
          )
      [simplification(51)]

  rule narrowReverse
          ( ... initialFormula: Initial:Expression
          , prefix: Prefix:SparseBytes
          , limits: L:Limits
          , reversed: structureReverseDone(_:SparseBytes, ReversedSize:Int, Reversed:ReversedSparseBytes)
          )
      => narrowSuffix
          ( ... initialFormula: Initial
          , prefix: Prefix
          , suffix: .SparseBytes
          , limits: L
          , toNarrow: Reversed
          , toNarrowSize: ReversedSize
          )
      [simplification]

  rule narrowSuffix
          ( ... initialFormula: Initial:Expression
          , prefix: Prefix:SparseBytes
          , suffix: Suffix:SparseBytes
          , limits: limits(Start, Size)
          , toNarrow: rconcat(A:SparseBytes, ToNarrow:ReversedSparseBytes)
          , toNarrowSize: ToNarrowSize
          )
      => narrowSuffix
          (... initialFormula: Initial
          , prefix: Prefix
          , suffix: concat(A, Suffix)
          , limits: limits(Start, Size)
          , toNarrow: ToNarrow
          , toNarrowSize: ToNarrowSize -Int size(A)
          )
      requires Start +Int Size <=Int ToNarrowSize -Int size(A)
      [simplification(50)]
  rule narrowSuffix
          ( ... initialFormula: Initial:Expression
          , prefix: Prefix:SparseBytes
          , suffix: Suffix:SparseBytes
          , limits: L:Limits
          , toNarrow: ToNarrow:ReversedSparseBytes
          , toNarrowSize: _
          )
      => narrowLimitsEnd
          (... initialFormula: Initial
          , prefix: Prefix
          , suffix: Suffix
          , argument: reverse(ToNarrow)
          , final: setLimits(Initial, L)
          , limits: L
          )
      [simplification(51)]

    rule narrowLimitsEnd
          ( ... initialFormula: Initial:Expression
          , prefix: Prefix:SparseBytes
          , suffix: Suffix:SparseBytes
          , argument: Argument:SparseBytes
          , final: limitsSet(Initial:Expression, Final:Expression, L)
          , limits: L
          )
      => narrowed
          ( ... initialFormula: Final
          , prefix: Prefix
          , argument: Argument            
          , suffix: Suffix
          )
      [simplification]

endmodule

```
