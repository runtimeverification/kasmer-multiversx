```k
requires "backend-fixes.md"

module ELROND-LEMMAS
  imports private BACKEND-FIXES
  imports public ELROND-IMPL

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

  rule (X modInt Y +Int Z) modInt Y => (X +Int Z) modInt Y
      [simplification]
  rule (X +Int Z modInt Y) modInt Y => (X +Int Z) modInt Y
      [simplification]

endmodule
```