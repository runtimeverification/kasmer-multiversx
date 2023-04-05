```k
module ELROND-LEMMAS
  imports public ELROND-IMPL

  syntax Bool ::= definedSubstrBytes(Bytes, startIndex: Int, endIndex: Int)  [function, total]
  rule definedSubstrBytes(B:Bytes, StartIndex:Int, EndIndex:Int)
      => (0 <=Int StartIndex) andBool (0 <=Int EndIndex)
          andBool (StartIndex <Int lengthBytes(B))
          andBool (EndIndex <=Int lengthBytes(B))

  syntax Bool ::= definedReplaceAtBytes(dest: Bytes, index: Int, src: Bytes)  [function, total]
  rule definedReplaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes)
      =>  (0 <=Int Index)
          andBool (Index +Int lengthBytes(Src) <=Int lengthBytes(Dest))

  syntax Bool ::= definedPadRightBytes(Bytes, length: Int, value: Int)  [function, total]
  rule definedPadRightBytes(_B:Bytes, Length:Int, Value:Int)
      =>  (0 <=Int Length)
          andBool (0 <=Int Value)
          andBool (Value <=Int 255)

  syntax Bool ::= definedModInt(Int, Int)  [function, total]
  rule definedModInt (_:Int, X:Int) => X =/=Int 0

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

  syntax MapIntwToBytesw ::= MapIntwToBytesw "{" key:Intw "<-" value:Bytesw "}"  [function, total]
  rule M:MapIntwToBytesw{Key:Intw <- Value:Bytesw} => M (Key Int2Bytes|-> Value)
    requires notBool Key in_keys(M)
  rule (Key Int2Bytes|-> _:Bytesw M:MapIntwToBytesw){Key:Intw <- Value:Bytesw} => M (Key Int2Bytes|-> Value)
  rule (M:MapIntwToBytesw{Key:Intw <- Value:Bytesw})(A:Intw Int2Bytes|-> B:Bytesw N:MapIntwToBytesw)
      => (M (A Int2Bytes|-> B)) {Key <- Value} N
      requires notBool A ==K B
      [simplification]

  rule M:MapIntwToBytesw{Key1:Intw <- Value1:Bytesw}[Key2:Intw <- Value2:Bytesw]
      => ((M:MapIntwToBytesw[Key2 <- Value2]{Key1 <- Value1}) #And #Not ({Key1 #Equals Key2}))
        #Or ((M:MapIntwToBytesw[Key2 <- Value2]) #And {Key1 #Equals Key2})
      [simplification(20)]
  rule M:MapIntwToBytesw[Key:Intw <- Value:Bytesw]
      => M:MapIntwToBytesw{Key <- Value}
      [simplification(100)]
  rule M:MapIntwToBytesw{Key1:Intw <- _Value1:Bytesw}[Key2:Intw] orDefault Value2:Bytesw
      => M[Key2] orDefault Value2
      requires Key1 =/=K Key2
      [simplification]
  rule _M:MapIntwToBytesw{Key:Intw <- Value1:Bytesw}[Key:Intw] orDefault _Value2:Bytesw
      => Value1
      [simplification]
  // rule M:MapIntwToBytesw{Key1:Intw <- Value1:Bytesw}[Key2:Intw] orDefault Value2:Bytesw
  //     => (M[Key2] orDefault Value2 #And #Not ({Key1 #Equals Key2}))
  //       #Or (Value1 #And {Key1 #Equals Key2})
  //     [simplification]
  rule M:MapIntwToBytesw{Key1:Intw <- Value1:Bytesw}[Key2:Intw]
      => (M[Key2] #And #Not ({Key1 #Equals Key2}))
        #Or (Value1 #And {Key1 #Equals Key2})
      [simplification]

  rule Key1:Intw in_keys(_:MapIntwToBytesw{Key1:Intw <- _:Bytesw})
      => true
      [simplification]
  rule Key1:Intw in_keys(M:MapIntwToBytesw{Key2:Intw <- _:Bytesw})
      => Key1 in_keys(M)
      requires notBool Key1 ==K Key2
      [simplification]

  rule Bytes2Int(Int2Bytes(Length:Int, Value:Int, E), E:Endianness, Unsigned)
      => Value modInt (2 ^Int (Length *Int 8))
      requires 0 <=Int Value
      [simplification]
  rule Bytes2Int(Int2Bytes(Value:Int, E, S), E:Endianness, S:Signedness)
      => Value
      [simplification]

  rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:ValType > _:Int) #Equals undefined } => #Bottom  [simplification]

  rule #Ceil(replaceAtBytes (@Dest:Bytes, @Index:Int, @Src:Bytes))
      =>  ( {definedReplaceAtBytes(@Dest, @Index, @Src) #Equals true}
          #And #Ceil(@Dest)
          )
        #And
          ( #Ceil(@Index)
          #And #Ceil(@Src)
          )
        [simplification]
  rule #Ceil(substrBytes(@B:Bytes, @StartIndex:Int, @EndIndex:Int))
      =>  ( {definedSubstrBytes(@B, @StartIndex, @EndIndex) #Equals true}
          #And #Ceil(@B)
          )
        #And
          ( #Ceil(@StartIndex)
          #And #Ceil(@EndIndex)
          )
        [simplification]
  rule #Ceil(padRightBytes (@B:Bytes, @Length:Int, @Value:Int))
      =>  ( {definedPadRightBytes(@B, @Length, @Value) #Equals true}
          #And #Ceil(@B)
          )
        #And
          ( #Ceil(@Length)
          #And #Ceil(@Value)
          )
        [simplification]

  rule #Ceil(#signed(@T:IValType, @N:Int))
      => {0 <=Int @N andBool @N <Int #pow(@T) #Equals true}
        #And #Ceil(@T)
        #And #Ceil(@N)
        [simplification]

  rule substrBytes(replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes), Start:Int, End:Int)
      => substrBytes(Dest, Start, End)
      requires (End <=Int Index orBool Index +Int lengthBytes(Src) <=Int Start)
          andBool definedReplaceAtBytes(Dest, Index, Src)
      [simplification]
  rule substrBytes(replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes), Start:Int, End:Int)
      => substrBytes(Src, Start -Int Index, End -Int Index)
      requires Index <=Int Start andBool End <=Int Index +Int lengthBytes(Src)
          andBool definedReplaceAtBytes(Dest, Index, Src)
      [simplification]
  rule substrBytes(B:Bytes, 0:Int, L:Int) => B
      requires lengthBytes(B) ==Int L
      [simplification]

  rule padRightBytes (B:Bytes, Length:Int, _Value:Int) => B
      requires Length <=Int lengthBytes(B)

  rule #getBytesRange(replaceAtBytes(Dest:Bytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getBytesRange(Dest, Start, Len)
      requires (Start +Int Len <=Int Index) orBool (Index +Int lengthBytes (Source) <=Int Start)
      [simplification]
  rule #getBytesRange(replaceAtBytes(_Dest:Bytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getBytesRange(Source, Start -Int Index, Len)
      requires (Index <=Int Start) andBool (Start +Int Len <=Int Index +Int lengthBytes (Source))
      [simplification]
  rule #getBytesRange(padRightBytes(B:Bytes, PadLen:Int, Val:Int), Start:Int, GetLen:Int)
      => #getBytesRange(B, Start, GetLen)
      requires true
          andBool definedPadRightBytes(B, PadLen, Val)
          andBool (PadLen <Int Start orBool Start +Int GetLen <Int lengthBytes(B))
      [simplification]
  // rule #substrBytes(#replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes), Start:Int, End:Int)
  //     => Dest
  //     requires (End <=Int Index orBool Index +Int lengthBytes(Src) <=Int Start)
  //         andBool definedReplaceAtBytes(Dest, Index, Src)
  //     [simplification]
  // rule #substrBytes(#replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes), Start:Int, End:Int)
  //     => #substrBytes(Src, Start -Int Index, End -Int Index)
  //     requires Index <=Int Start andBool End <=Int Index +Int lengthBytes(Src)
  //         andBool definedReplaceAtBytes(Dest, Index, Src)
  //     [simplification]

  rule lengthBytes(Int2Bytes(Len:Int, _:Int, _:Endianness)) => Len  [simplification]
  rule lengthBytes(padRightBytes(B:Bytes, Length:Int, _Value:Int))
      => maxInt(lengthBytes(B:Bytes), Length:Int)
      [simplification]
  rule lengthBytes(replaceAtBytes(Dest:Bytes, _Index:Int, _Src:Bytes) #as _Ceil)
      => lengthBytes(Dest)
      [simplification]
  // rule lengthBytes(#replaceAtBytes(Dest:Bytes, _Index:Int, _Src:Bytes) #as _Ceil)
  //     => lengthBytes(Dest)
  //     [simplification]
  rule 0 <=Int lengthBytes(_:Bytes) => true  [simplification]

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

  syntax Int ::= Int "modIntTotal" Int  [function, total, klabel(_modIntTotal_), symbol, left, smt-hook(mod)]
  rule _ modIntTotal 0 => 0
  rule X modIntTotal Y => X modInt Y [concrete, simplification]

  rule X modInt Y => X modIntTotal Y
      requires definedModInt(X, Y)
      [simplification, symbolic]

endmodule
```