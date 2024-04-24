```k
requires "ceils.k"
requires "lemmas/int-normalization-lemmas.md"
requires "lemmas/int-inequalities-lemmas.md"
requires "lemmas/sparse-bytes/sparse-bytes-lemmas.md"

module MX-LEMMAS-BASIC
  imports BOOL
  imports INT
  imports INT-NORMALIZATION-LEMMAS-BASIC
  imports public SPARSE-BYTES-LEMMAS-BASIC

endmodule

module MX-LEMMAS  [symbolic]
  imports private CEILS
  imports private ELROND
  imports private INT-INEQUALITIES-LEMMAS
  imports private INT-KORE
  imports private INT-NORMALIZATION-LEMMAS
  imports public MX-LEMMAS-BASIC
  imports private SET
  imports private SPARSE-BYTES-LEMMAS
  imports private WASM-TEXT

  rule Bytes2Int(#getBytesRange(_:SparseBytes, _:Int, N:Int), _:Endianness, _:Signedness) <Int M:Int
        => true
      requires 2 ^Int (8 *Int N) <=Int M
      [simplification]
  rule N <=Int Bytes2Int(_:Bytes, _:Endianness, Unsigned)
        => true
      requires N <=Int 0
      [simplification]

  rule Bytes2Int(Int2Bytes(Length:Int, Value:Int, E), E:Endianness, Unsigned)
      => Value modInt (2 ^Int (Length *Int 8))
      requires 0 <=Int Value
      [simplification]
  rule Bytes2Int(Int2Bytes(Value:Int, E, S), E:Endianness, S:Signedness)
      => Value
      [simplification]
  rule Bytes2Int(Int2Bytes(Value:Int, E, Signed), E:Endianness, Unsigned)
      => Value
      requires 0 <=Int Value
      [simplification]

  rule { b"" #Equals Int2Bytes(Len:Int, _Value:Int, _E:Endianness) }:Bool
      => {0 #Equals Len}
      [simplification]
  rule { b"" #Equals Int2Bytes(Value:Int, _E:Endianness, _S:Signedness) }:Bool
      => {0 #Equals Value}
      [simplification]
  rule { b"" #Equals substrBytesTotal(B:Bytes, Start:Int, End:Int) }
      => {0 #Equals End -Int Start}
      requires definedSubstrBytes(B, Start, End)
      [simplification]
  rule { b"" #Equals A }
      => #Bottom
      requires lengthBytes(A) >Int 0
      [simplification(100)]
  // rule { b"" #Equals B:Bytes } => {0 #Equals lengthBytes(B)}

  rule {false #Equals B:Bool} => #Not ({true #Equals B:Bool})
      [simplification]

  rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:FValType > _:Float) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:RefValType > _:Int) #Equals undefined } => #Bottom  [simplification]

  rule padRightBytesTotal (B:Bytes, Length:Int, Value:Int) => B
      requires Length <=Int lengthBytes(B)
          andBool definedPadRightBytes(B, Length, Value)
  // rule padRightBytesTotal(replaceAtBytesTotal(Dest:Bytes, Pos:Int, Source:Bytes), Length:Int, Value:Int)
  //     => replaceAtBytesTotal(padRightBytesTotal(Dest, Length, Value), Pos, Source)
  //     requires definedReplaceAtBytes(Dest, Pos, Source)
  //         andBool definedPadRightBytes(Dest, Length, Value)
  //     [simplification]
  rule padRightBytesTotal(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2:Int, Value:Int)
      => padRightBytesTotal(B, maxInt (Length1, Length2), Value:Int)
      requires definedPadRightBytes(B, Length1, Value)
          andBool definedPadRightBytes(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2, Value)
      [simplification]


  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => maxInt(Addr +Int Width, size(M))
    requires #setRangeActuallySets(Addr, Val, Width)
      [simplification]
  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => size(M)
    requires notBool (#setRangeActuallySets(Addr, Val, Width))
      [simplification]

  rule substrBytesTotal(Int2Bytes(Size:Int, Value:Int, LE), Start:Int, End:Int)
      => Int2Bytes(
          End -Int Start,
          (Value >>Int (8 *Int Start)),
          LE
      )
      requires 0 <=Int Start andBool Start <=Int End andBool End <=Int Size
      [simplification]
  rule substrBytesTotal(A:Bytes +Bytes _B:Bytes, Start:Int, End:Int)
      => substrBytesTotal(A, Start, End)
      requires End <=Int lengthBytes(A)
      [simplification]
  rule substrBytesTotal(A:Bytes +Bytes B:Bytes, Start:Int, End:Int)
      => substrBytesTotal(B, Start -Int lengthBytes(A), End -Int lengthBytes(A))
      requires lengthBytes(A) <=Int Start
      [simplification]
  rule substrBytesTotal(A:Bytes +Bytes B:Bytes, Start:Int, End:Int)
      => substrBytesTotal(A, Start, lengthBytes(A)) +Bytes substrBytesTotal(B, 0, End -Int lengthBytes(A))
      requires Start <Int lengthBytes(A) andBool lengthBytes(A) <Int End
      [simplification]
  rule substrBytesTotal(B:Bytes, 0:Int, Len:Int) => B
      requires true
        andBool Len ==Int lengthBytes(B)
      [simplification]

  rule replaceAtBytesTotal(Dest:Bytes, Start:Int, Src:Bytes)
      => substrBytes(Dest, 0, Start)
        +Bytes Src
        +Bytes substrBytes(Dest, Start +Int lengthBytes(Src), lengthBytes(Dest))
      requires 0 <=Int Start andBool Start +Int lengthBytes(Src) <=Int lengthBytes(Dest)
      [simplification]


  rule lengthBytes(Int2Bytes(Len:Int, _:Int, _:Endianness)) => Len  [simplification]
  rule lengthBytes(substrBytesTotal(B:Bytes, Start:Int, End:Int)) => End -Int Start
      requires definedSubstrBytes(B, Start, End)
      [simplification]
  rule lengthBytes(padRightBytesTotal(B:Bytes, Length:Int, Value:Int))
      => maxInt(lengthBytes(B:Bytes), Length:Int)
      requires definedPadRightBytes(B, Length, Value)
      [simplification]
  rule lengthBytes(A +Bytes B) => lengthBytes(A) +Int lengthBytes(B)
      [simplification]
  rule 0 <=Int lengthBytes(_:Bytes) => true
      [simplification]
  rule lengthBytes(replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes))
      => lengthBytes(Dest)
      requires 0 <=Int Index andBool Index +Int lengthBytes(Src) <=Int lengthBytes(Dest)
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
  rule size(merge(A:SBItemChunk, B:SparseBytes)) => size(A) +Int size(B)
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

  rule b"" +Bytes B => B
  rule B +Bytes b"" => B
      [simplification]
  rule (A +Bytes B) +Bytes C => A +Bytes (B +Bytes C)
      [simplification, concrete(B, C), symbolic(A)]
  rule A +Bytes (B +Bytes C) => (A +Bytes B) +Bytes C
      [simplification, concrete(A, B), symbolic(C)]

  rule notBool notBool B => B
      [simplification]

  // rule -1 <=Int #bigIntSign(_) => true  [simplification, smt-lemma]
  // rule #bigIntSign(_) <=Int 1 => true  [simplification, smt-lemma]

  rule X <=Int #bigIntSign(_) => true requires X <=Int -1  [simplification]
  rule X <Int #bigIntSign(_) => true requires X <Int -1  [simplification]
  rule #bigIntSign(_) <=Int X => true requires 1 <=Int X  [simplification]
  rule #bigIntSign(_) <Int X => true requires 1 <Int X  [simplification]

  rule 0 <=Int #bigIntSign(X) => true requires 0 <=Int X  [simplification]
  rule #bigIntSign(X) <=Int 0 => true requires X <=Int 0  [simplification]
endmodule

```
