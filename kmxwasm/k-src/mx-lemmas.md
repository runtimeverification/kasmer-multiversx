```k
requires "ceils.k"
requires "lemmas/bytes-normalization-lemmas.md"
requires "lemmas/int-encoding-lemmas.md"
requires "lemmas/int-inequalities-lemmas.md"
requires "lemmas/int-length-lemmas.md"
requires "lemmas/int-normalization-lemmas.md"
requires "lemmas/sparse-bytes-lemmas.md"
requires "lemmas/pair-specific-lemmas.md"

requires "lemmas/sparse-bytes/sparse-bytes-lemmas.md"

module MX-LEMMAS-BASIC
  imports BOOL
  imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
  imports INT
  imports INT-ENCODING-BASIC
  imports INT-LENGTH-LEMMAS-BASIC
  imports INT-NORMALIZATION-LEMMAS-BASIC
  imports SPARSE-BYTES-LEMMAS-BASIC
  imports SPARSE-BYTES-LEMMAS-SYNTAX
endmodule

module MX-LEMMAS  [symbolic]
  imports private BYTES-NORMALIZATION-LEMMAS
  imports private CEILS
  imports private ELROND
  imports private INT-ENCODING-LEMMAS
  imports private INT-INEQUALITIES-LEMMAS
  imports private INT-LENGTH-LEMMAS
  imports private INT-KORE
  imports private INT-NORMALIZATION-LEMMAS
  imports public MX-LEMMAS-BASIC
  imports private SPARSE-BYTES-LEMMAS
  imports private SPARSE-BYTES-LEMMAS2
  imports private PAIR-SPECIFIC-LEMMAS
  imports private SET
  imports private WASM-TEXT

  rule Bytes2Int(#getBytesRange(_:SparseBytes, _:Int, N:Int), _:Endianness, _:Signedness) <Int M:Int
        => true
      requires 2 ^Int (8 *Int N) <=Int M
      [simplification]

  rule {false #Equals B:Bool} => #Not ({true #Equals B:Bool})
      [simplification]

  rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:FValType > _:Float) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:RefValType > _:Int) #Equals undefined } => #Bottom  [simplification]

  // TODO: REMOVE -------------------------------

  syntax Expression ::= #getRangeExpression(SparseBytes, Int, Int)
  rule #getRange(B:SparseBytes, Start:Int, Width:Int)
      => narrowInt(#getRangeExpression(B, Start, Width), B)
      requires isNarrowable(#getRangeExpression(B, Start, Width), B)
      [simplification]
  rule extractLimit(#getRangeExpression(B:SparseBytes, Start:Int, Width:Int))
      => limitExtracted(#getRangeExpression(B, Start, Width), limits(Start, Width))
      [simplification]
  rule replaceArgument(... expression: #getRangeExpression(B:SparseBytes, Start:Int, Width:Int), argument: Argument)
      => argumentReplaced(... expression: #getRangeExpression(B, Start, Width), replaced: #getRangeExpression(Argument, Start, Width), argument: Argument)
      [simplification]
  rule setLimits(#getRangeExpression(B:SparseBytes, Start:Int, Width:Int), limits(LStart, LSize))
      => limitsSet
          ( ... expression: #getRangeExpression(B, Start, Width)
          , replaced: #getRangeExpression(B, LStart, LSize)
          , limits: limits(LStart, LSize)
          )
      [simplification]
  rule intFromExpression(#getRangeExpression(B, Start, Width)) => #getRange(B, Start, Width)

  // TODO: Delete ----------------------------------------

  syntax Expression ::= #setRangeExpression(SparseBytes, Int, Int, Int)

  rule #setRange(B:SparseBytes, Start:Int, Value:Int, Width:Int)
      => narrowSparseBytes(#setRangeExpression(B, Start, Value, Width), B)
      requires isNarrowable(#setRangeExpression(B, Start, Value, Width), B)
      [simplification]
  rule extractLimit(#setRangeExpression(B:SparseBytes, Start:Int, Value:Int, Width:Int))
      => limitExtracted(#setRangeExpression(B, Start, Value, Width), limits(Start, Width))
      [simplification]
  rule replaceArgument(... expression: #setRangeExpression(B:SparseBytes, Start:Int, Value:Int, Width:Int), argument: Argument)
      => argumentReplaced(... expression: #setRangeExpression(B, Start, Value, Width), replaced: #setRangeExpression(Argument, Start, Value, Width), argument: Argument)
      [simplification]
  rule setLimits(#setRangeExpression(B:SparseBytes, Start:Int, Value:Int, Width:Int), limits(LStart, LSize))
      => limitsSet
          ( ... expression: #setRangeExpression(B, Start, Value, Width)
          , replaced: #setRangeExpression(B, LStart, Value, LSize)
          , limits: limits(LStart, LSize)
          )
      [simplification]
  rule sparseBytesFromExpression(#setRangeExpression(B:SparseBytes, Start:Int, Value:Int, Width:Int))
      => #setRange(B, Start, Value, Width)

  // TODO: Delete ----------------------------------------

  syntax Expression ::= replaceAtBExpression(Bytes, SparseBytes, Int, Bytes)

  rule replaceAtB(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes)
      => narrowSparseBytes(replaceAtBExpression(Current, Rest, Start, Value), Rest)
      requires isNarrowable(replaceAtBExpression(Current, Rest, Start, Value), Rest)
      [simplification]
  rule extractLimit(replaceAtBExpression(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes))
      => limitExtracted
          ( replaceAtBExpression(Current, Rest, Start, Value)
          , limits(Start -Int lengthBytes(Current), lengthBytes(Value))
          )
      [simplification]
  rule setLimits(replaceAtBExpression(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes), limits(LStart, LSize))
      => limitsSet
          ( ... expression: replaceAtBExpression(Current, Rest, Start, Value)
          , replaced: replaceAtBExpression(Current, Rest, LStart +Int lengthBytes(Current), Value)
          , limits: limits(LStart, LSize)
          )
      requires LSize ==Int lengthBytes(Value)
      [simplification]
  rule replaceArgument
          ( ... expression: replaceAtBExpression(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes)
          , argument:Argument
          )
      => argumentReplaced
          ( ... expression: replaceAtBExpression(Current, Rest, Start, Value)
          , replaced: replaceAtBExpression(Current, Argument, Start, Value)
          , argument:Argument
          )
      [simplification]
  rule sparseBytesFromExpression(replaceAtBExpression(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes))
      => replaceAtB(Current, Rest, Start, Value)

  // ----------------------------------------

  // rule padRightBytesTotal
  //     ( #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int)
  //     , Len, 0
  //     )
  //   => #setRange
  //     ( padRightBytesTotal(M, Len, 0)
  //     , Addr1, Val1, Width1
  //     )
  //     [simplification]
  // rule padRightBytesTotal(replaceAtBytesTotal(Dest:Bytes, Pos:Int, Source:Bytes), Length:Int, Value:Int)
  //     => replaceAtBytesTotal(padRightBytesTotal(Dest, Length, Value), Pos, Source)
  //     requires definedReplaceAtBytes(Dest, Pos, Source)
  //         andBool definedPadRightBytes(Dest, Length, Value)
  //     [simplification]

  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => maxInt(Addr +Int Width, size(M))
    requires #setRangeActuallySets(Addr, Val, Width)
      [simplification]
  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => size(M)
    requires notBool (#setRangeActuallySets(Addr, Val, Width))
      [simplification]

  rule size(replaceAtB(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes))
      => lengthBytes(Current) +Int size(Rest)
      requires Start +Int lengthBytes(Value) <=Int lengthBytes(Current) +Int size(Rest)
      [simplification]

  rule size(replaceAt(Dest:SparseBytes, Index:Int, Src:Bytes))
      => maxInt(size(Dest), Index +Int lengthBytes(Src))
      requires 0 <=Int Index
      [simplification]
  rule size(substrSparseBytes(B:SparseBytes, Start:Int, End:Int))
      => End -Int Start
      requires 0 <=Int Start andBool Start <=Int End andBool End <=Int size(B)
      [simplification]
  rule size(concat(A:SparseBytes, B:SparseBytes)) => size(A) +Int size(B)
      [simplification]
  rule 0 <=Int size(_:SparseBytes) => true
      [simplification]

  rule 0 <=Int #signedTotal(T:IValType, N:Int) => 0 <=Int N andBool N <Int #pow1(T)
      requires definedSigned(T, N)
      [simplification]

  rule #signedTotal(IType:IValType, A:Int modIntTotal M:Int) => A
      requires M ==Int #pow(IType)
          andBool 0 -Int #pow1(IType) <=Int A
          andBool A <Int #pow1(IType)
      [simplification]

  rule -1 <=Int #cmpInt(_:Int, _:Int) => true
      [simplification, smt-lemma]
  rule #cmpInt(_:Int, _:Int) <=Int 1 => true
      [simplification, smt-lemma]

  rule #cmpInt(A:Int, B:Int) <Int 0 => A <Int B
      [simplification]
  rule 0 <Int #cmpInt(A:Int, B:Int) => B <Int A
      [simplification]

  rule #cmpInt(A, B) modIntTotal M ==Int 0 => A ==Int B
      requires M >Int 1
      [simplification]

  rule (A +String B) +String C => A +String (B +String C)
      [simplification, concrete(B,C)]

  rule notBool notBool B => B
      [simplification]

  // rule -1 <=Int #bigIntSign(_) => true  [simplification, smt-lemma]
  // rule #bigIntSign(_) <=Int 1 => true  [simplification, smt-lemma]

  rule X <=Int #bigIntSign(_) => true requires X <=Int -1  [simplification]
  rule X <Int #bigIntSign(_) => true requires X <Int -1  [simplification]
  rule #bigIntSign(_) <=Int X => true requires 1 <=Int X  [simplification]
  rule #bigIntSign(_) <Int X => true requires 1 <Int X  [simplification]

  // TODO: Rewrite the following two rules similar to the third.
  rule 0 <=Int #bigIntSign(X) => true requires 0 <=Int X  [simplification]
  rule #bigIntSign(X) <=Int 0 => true requires X <=Int 0  [simplification]
  rule 0 <Int #bigIntSign(X) => 0 <Int X  [simplification]
  rule #bigIntSign(X) <Int 0 => X <Int 0  [simplification]
  rule #bigIntSign(X) ==Int 0 => X ==Int 0  [simplification]

  // #if is parametric in the sort of the return value, and matching
  // works on exact sort matches, so we need symplification rules
  // for all possible combinations.
  rule #typeMatches(T, #if _ #then A:Val #else B:Val #fi) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:IVal) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:FVal) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:RefVal) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]

  // #if is parametric in the sort of the return value, and matching
  // works on exact sort matches, so we need symplification rules
  // for all possible combinations.
  rule #typeMatches(T, #if _ #then A:Val #else B #fi) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:IVal) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:FVal) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:RefVal) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
endmodule

```
