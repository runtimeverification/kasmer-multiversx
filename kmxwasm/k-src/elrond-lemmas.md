```k
require "ceils.k"


module ELROND-LEMMAS
  imports public CEILS
  imports public ELROND-IMPL

  // // TODO: Should, perhaps, change domains.md to add a smtlib attribute to
  // // Bytes2Int instead of creating a new symbol that we control.
  // syntax Int ::= #Bytes2Int(Bytes, Endianness, Signedness)
  //     [function, total, smtlib(Bytes2Int)]
  // rule Bytes2Int(B:Bytes, E:Endianness, S:Signedness) => #Bytes2Int (B, E, S)
  //     [simplification, symbolic]
  // rule #Bytes2Int(B:Bytes, E:Endianness, S:Signedness) => Bytes2Int (B, E, S)
  //     [simplification, concrete]
  // rule 0 <=Int #Bytes2Int(_:Bytes, _:Endianness, Unsigned) => true
  //     [simplification, smt-lemma]

  rule Bytes2Int(#getBytesRange(_:Bytes, _:Int, N:Int), _:Endianness, _:Signedness) <Int M:Int
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

  rule 0 <=Int A +Int B => true
      requires 0 <=Int A andBool 0 <=Int B
      [simplification]

  rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:ValType > _:Int) #Equals undefined } => #Bottom  [simplification]

  rule #Ceil(#signed(@T:IValType, @N:Int))
      => {0 <=Int @N andBool @N <Int #pow(@T) #Equals true}
        #And #Ceil(@T)
        #And #Ceil(@N)
        [simplification]

  rule substrBytesTotal(replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes), Start:Int, End:Int)
      => substrBytesTotal(Dest, Start, End)
      requires (End <=Int Index orBool Index +Int lengthBytes(Src) <=Int Start)
          andBool definedReplaceAtBytes(Dest, Index, Src)
      [simplification]
  rule substrBytesTotal(replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes), Start:Int, End:Int)
      => substrBytesTotal(Src, Start -Int Index, End -Int Index)
      requires Index <=Int Start andBool End <=Int Index +Int lengthBytes(Src)
          andBool definedReplaceAtBytes(Dest, Index, Src)
      [simplification]
  rule substrBytesTotal(B:Bytes, 0:Int, Len:Int) => B
      requires true
          andBool Len ==Int lengthBytes(B)
      [simplification]

  rule padRightBytesTotal (B:Bytes, Length:Int, _Value:Int) => B
      requires Length <=Int lengthBytes(B)
  rule padRightBytesTotal(replaceAtBytesTotal(Dest:Bytes, Pos:Int, Source:Bytes) #as _Ceil, Length:Int, Value:Int)
      => replaceAtBytesTotal(padRightBytesTotal(Dest, Length, Value), Pos, Source)
      [simplification]
  rule padRightBytesTotal(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int) #as _Ceil, Length2:Int, Value:Int)
      => padRightBytesTotal(B, maxInt (Length1, Length2), Value:Int)
      [simplification]

  rule #getBytesRange(replaceAtBytesTotal(Dest:Bytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getBytesRange(Dest, Start, Len)
      requires (Start +Int Len <=Int Index) orBool (Index +Int lengthBytes (Source) <=Int Start)
      [simplification]
  rule #getBytesRange(replaceAtBytesTotal(_Dest:Bytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getBytesRange(Source, Start -Int Index, Len)
      requires (Index <=Int Start) andBool (Start +Int Len <=Int Index +Int lengthBytes (Source))
      [simplification]
  rule #getBytesRange(padRightBytesTotal(B:Bytes, PadLen:Int, Val:Int), Start:Int, GetLen:Int)
      => #getBytesRange(B, Start, GetLen)
      requires true
          andBool definedPadRightBytes(B, PadLen, Val)
          andBool (PadLen <Int Start orBool Start +Int GetLen <Int lengthBytes(B))
      [simplification]

  rule lengthBytes(Int2Bytes(Len:Int, _:Int, _:Endianness)) => Len  [simplification]
  rule lengthBytes(padRightBytesTotal(B:Bytes, Length:Int, _Value:Int))
      => maxInt(lengthBytes(B:Bytes), Length:Int)
      [simplification]
  rule lengthBytes(replaceAtBytesTotal(Dest:Bytes, _Index:Int, _Src:Bytes) #as _Ceil)
      => lengthBytes(Dest)
      [simplification]
  rule lengthBytes(substrBytesTotal(_:Bytes, Start:Int, End:Int))
      => End -Int Start
      [simplification]
  rule 0 <=Int lengthBytes(_:Bytes) => true  [simplification]

  rule X -Int X => 0  [simplification]

  rule A:Int <=Int maxInt(B:Int, C:Int) => true
      requires A <=Int B orBool A <=Int C
      [simplification]
  rule A:Int <Int maxInt(B:Int, C:Int) => true
      requires A <Int B orBool A <Int C
      [simplification]
  rule A:Int >=Int maxInt(B:Int, C:Int) => A >=Int B andBool A >=Int C
      [simplification]
  rule A:Int >Int maxInt(B:Int, C:Int) => A >Int B andBool A >Int C
      [simplification]

  rule maxInt(B:Int, C:Int) >=Int A:Int => true
      requires A <=Int B orBool A <=Int C
      [simplification]
  rule maxInt(B:Int, C:Int) >Int A:Int => true
      requires A <Int B orBool A <Int C
      [simplification]
  rule maxInt(B:Int, C:Int) <=Int A:Int => A >=Int B andBool A >=Int C
      [simplification]
  rule maxInt(B:Int, C:Int) <Int A:Int => A >Int B andBool A >Int C
      [simplification]

  rule ((X modIntTotal Y) +Int Z) modIntTotal Y => (X +Int Z) modIntTotal Y
      [simplification]
  rule (X +Int (Z modIntTotal Y)) modIntTotal Y => (X +Int Z) modIntTotal Y
      [simplification]
  rule (_X modIntTotal Y) <Int Y => true
      requires Y >Int 0
      [simplification]
  rule 0 <=Int (_X modIntTotal Y) => true
      requires Y >Int 0
      [simplification]

endmodule
```