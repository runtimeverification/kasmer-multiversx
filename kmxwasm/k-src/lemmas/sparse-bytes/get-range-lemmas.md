```k

module GET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC
  imports GET-RANGE-REPLACE-AT
  imports GET-RANGE-SET-RANGE

  // -------------------------------

  rule #getRange(SBChunk(A:SBItem) B:SparseBytes, Start, Width)
      => #splitGetRange(SBChunk(A) B, Start, size(SBChunk(A)) -Int Start, Start +Int Width -Int size(SBChunk(A)))
    requires Start <Int size(SBChunk(A)) andBool size(SBChunk(A)) <Int Start +Int Width
    [simplification]

  // For some random reason, this does not work with the Haskell backend.
  // My guess is that the
  // function(constructor(constructor(function(var, var))), var, var)
  // pattern is not handled by the backend.
  //
  // rule #getRange(SBChunk(#bytes(A +Bytes B)), Start:Int, Width:Int)
  //     => #getRange(SBChunk(#bytes(A)) SBChunk(#bytes(B)), Start, Width)
  //   [simplification]
  rule #getRange(SBChunk(#bytes(A:Bytes)), Start:Int, Width:Int)
      => Bytes2Int(substrBytes(A:Bytes, Start, Start +Int Width), LE, Unsigned)
      requires 0 <=Int Start andBool 0 <=Int Width
          andBool Start +Int Width <=Int lengthBytes(A)
    [simplification]

  rule #getRange(
          SBChunk(#bytes(Int2Bytes(IntWidth:Int, Value:Int, LE))),
          0,
          RangeWidth:Int
      )
    => Value &Int ((1 <<Int (8 *Int RangeWidth)) -Int 1)
    requires 0 <=Int RangeWidth
      andBool RangeWidth <=Int IntWidth
      andBool 0 <=Int Value
    [simplification]


  // rule #getRange(padRightBytesTotal(B:Bytes, PadLen:Int, Val:Int), Start:Int, GetLen:Int)
  //     => #getRange(B, Start, GetLen)
  //     requires true
  //         andBool definedPadRightBytes(B, PadLen, Val)
  //         andBool (PadLen <Int Start orBool Start +Int GetLen <Int lengthBytes(B))
  //     [simplification]

endmodule

module GET-RANGE-SET-RANGE
  imports SPARSE-BYTES-LEMMAS-BASIC

  rule #getRange(
          #setRange(M:SparseBytes, Addr1:Int, Val:Int, Width1:Int),
          Addr2:Int, Width2:Int
      )
      => #getRange(
            #splitSetRange(M, Addr1, Val, Addr2 -Int Addr1, Width1 -Int (Addr2 -Int Addr1))
        , Addr2, Width2)
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int Width1
          andBool #setRangeActuallySets(Addr1, Val, Width1)
      [simplification]
  rule #getRange(
          #setRange(M:SparseBytes, Addr:Int, Val:Int, Width1:Int),
          Addr:Int, Width2:Int
      )
      => #getRange(
          #splitSetRange(M, Addr, Val, Width2, Width1 -Int Width2),
          Addr, Width2
      )
      requires Width2 <Int Width1
          andBool 0 <=Int Val
          andBool #setRangeActuallySets(Addr, Val, Width1)
      [simplification]
  rule #getRange(
          #setRange(M:SparseBytes, Addr1:Int, Val:Int, Width1:Int),
          Addr2:Int, Width2:Int
      )
      => #splitGetRange(
            #setRange(M, Addr1, Val, Width1)
            , Addr2
            , Addr1 -Int Addr2
            , Width2 -Int (Addr1 -Int Addr2)
        )
      requires Addr2 <Int Addr1 andBool Addr1 <Int Addr2 +Int Width2
          andBool #setRangeActuallySets(Addr1, Val, Width1)
      [simplification]
  rule #getRange(
          #setRange(M:SparseBytes, Addr:Int, Val:Int, Width1:Int),
          Addr:Int, Width2:Int
      )
      => #splitGetRange(
            #setRange(M, Addr, Val, Width1)
            , Addr
            , Width1
            , Width2 -Int Width1
        )
      requires 0 <Int Width1 andBool Width1 <Int Width2
          andBool #setRangeActuallySets(Addr, Val, Width1)
      [simplification]
endmodule

module GET-RANGE-REPLACE-AT
  imports SPARSE-BYTES-LEMMAS-BASIC

  rule #getRange(
          replaceAt(Dest, Index, Src),
          RangeStart,
          RangeWidth
      ) => #getRange(Dest, RangeStart, RangeWidth)
    requires disjontRanges(RangeStart, RangeWidth, Index, lengthBytes(Src))
    [simplification]
  rule #getRange(
          replaceAt(_Dest, Index, Src),
          RangeStart,
          RangeWidth
      ) => #getRange(SBChunk(#bytes(Src)), RangeStart -Int Index, RangeWidth)
    requires Index <=Int RangeStart
        andBool RangeStart +Int RangeWidth <=Int Index +Int lengthBytes(Src)
    [simplification]

  rule #getRange(replaceAt(Dest:SparseBytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getRange(Dest, Start, Len)
      requires disjontRanges(Start, Len, Index, lengthBytes(Source))
        andBool 0 <=Int Index
      [simplification]
  rule #getRange(
          replaceAt(Dest:SparseBytes, Index:Int, Source:Bytes),
          Start:Int, Len:Int
      )
      => #splitGetRange(
            replaceAt(Dest, Index, Source),
            Start,
            Index -Int Start,
            Start +Int Len -Int Index
        )
      requires (Start <Int Index)
        andBool (Index <Int Start +Int Len)
        andBool 0 <=Int Index
      [simplification]
  rule #getRange(
          replaceAt(Dest:SparseBytes, Index:Int, Source:Bytes),
          Start:Int, Len:Int
      )
      => #splitGetRange(
            replaceAt(Dest, Index, Source),
            Start,
            Index +Int lengthBytes (Source) -Int Start,
            Start +Int Len -Int (Index +Int lengthBytes (Source))
        )
      requires (Start <Int Index +Int lengthBytes (Source))
        andBool (Index +Int lengthBytes (Source) <Int Start +Int Len)
        andBool 0 <=Int Index
      [simplification]
  rule #getRange(replaceAt(_Dest:SparseBytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getRange(SBChunk(#bytes(Source)), Start -Int Index, Len)
      requires (Index <=Int Start) andBool (Start +Int Len <=Int Index +Int lengthBytes (Source))
        andBool 0 <=Int Index
      [simplification]
endmodule
```