```k
require "ceils.k"

module MX-LEMMAS  [symbolic]
  imports private CEILS
  imports private ELROND
  imports private INT-KORE
  imports private SET
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

  rule 0 <=Int A +Int B => true
      requires 0 <=Int A andBool 0 <=Int B
      [simplification]
  rule {false #Equals B:Bool} => #Not ({true #Equals B:Bool})
      [simplification]

  rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:ValType > _:Int) #Equals undefined } => #Bottom  [simplification]

  rule padRightBytesTotal (B:Bytes, Length:Int, Value:Int) => B
      requires Length <=Int lengthBytes(B)
          andBool definedPadRightBytes(B, Length, Value)
  rule padRightBytesTotal(replaceAtBytesTotal(Dest:Bytes, Pos:Int, Source:Bytes), Length:Int, Value:Int)
      => replaceAtBytesTotal(padRightBytesTotal(Dest, Length, Value), Pos, Source)
      requires definedReplaceAtBytes(Dest, Pos, Source)
          andBool definedPadRightBytes(Dest, Length, Value)
      [simplification]
  rule padRightBytesTotal(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2:Int, Value:Int)
      => padRightBytesTotal(B, maxInt (Length1, Length2), Value:Int)
      requires definedPadRightBytes(B, Length1, Value)
          andBool definedPadRightBytes(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2, Value)
      [simplification]

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

  rule #getRange(A +Bytes B, Start, Width)
      => #getRange(B, Start -Int lengthBytes(A), Width)
    requires lengthBytes(A) <=Int Start
    [simplification]
  rule #getRange(A +Bytes _, Start, Width)
      => #getRange(A, Start, Width)
    requires Start <Int lengthBytes(A) andBool Start +Int Width <=Int lengthBytes(A)
    [simplification]
  rule #getRange(A +Bytes B, Start, Width)
      => #splitGetRange(A +Bytes B, Start, lengthBytes(A) -Int Start, Start +Int Width -Int lengthBytes(A))
    requires Start <Int lengthBytes(A) andBool lengthBytes(A) <Int Start +Int Width
    [simplification]

  rule #getRange(
          Int2Bytes(IntWidth:Int, Value:Int, LE),
          0,
          RangeWidth:Int
      )
    => Value &Int ((1 <<Int (8 *Int RangeWidth)) -Int 1)
    requires 0 <=Int RangeWidth
      andBool RangeWidth <=Int IntWidth
      andBool 0 <=Int Value
    [simplification]


  rule #getSparseBytes(replaceAt(Dest:SparseBytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getSparseBytes(Dest, Start, Len)
      requires disjontRanges(Start, Len, Index, lengthBytes(Source))//(Start +Int Len <=Int Index) orBool (Index +Int lengthBytes (Source) <=Int Start)
        andBool definedReplaceAtBytes(Dest, Index, Source)
      [simplification]
  rule #getSparseBytes(replaceAt(Dest:SparseBytes, Index:Int, Source:Bytes), Start:Int, Len:Int)
      => #getSparseBytes(Source, Start -Int Index, Len)
      requires (Index <=Int Start) andBool (Start +Int Len <=Int Index +Int lengthBytes (Source))
        andBool definedReplaceAtBytes(Dest, Index, Source)
      [simplification]
  rule #getSparseBytes(padRightBytesTotal(B:Bytes, PadLen:Int, Val:Int), Start:Int, GetLen:Int)
      => #getSparseBytes(B, Start, GetLen)
      requires true
          andBool definedPadRightBytes(B, PadLen, Val)
          andBool (PadLen <Int Start orBool Start +Int GetLen <Int lengthBytes(B))
      [simplification]

  // ----------------------------------------

  syntax SparseBytes ::= #splitSetRange(SparseBytes, addr:Int, value:Int, width:Int, additionalwidth:Int)  [function]
  rule #splitSetRange(M:SparseBytes, Addr:Int, Value:Int, Width:Int, AdditionalWidth:Int)
      => #setRange(
            #setRange(
                M, Addr,
                Value &Int ((1 <<Int (8 *Int Width)) -Int 1),
                Width
            ),
            Addr +Int Width, Value >>Int (8 *Int Width), AdditionalWidth
        )

  rule #setRange(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(
          #setRange(M, Addr2, Val2, Width2),
          Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, Width2)
      [simplification, concrete(Addr2,Val2,Width2), symbolic(Val1)]

  rule #setRange(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(
          #setRange(M, Addr2, Val2, Width2),
          Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, Width2)
        andBool Addr1 <Int Addr2
      [simplification, symbolic(Val1,Val2)]

  rule #setRange(
          #setRange(M:SparseBytes, Addr1:Int, _Val1:Int, Width1:Int),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(M, Addr2, Val2, Width2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int Width1 <=Int Addr2 +Int Width2
        andBool 0 <Int Width1
        andBool #setRangeActuallySets(Addr2, Val2, Width2)
      [simplification]
      // TODO: Consider adding rules for when Addr1 or Width1 are symbolic

  rule #setRange(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(
            #splitSetRange(
                M, Addr1, Val1,
                Addr2 -Int Addr1,
                Width1 -Int (Addr2 -Int Addr1)
            ),
            Addr2, Val2, Width2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int Width1
      [simplification, concrete(Addr2, Addr1, Width2, Width1)]
  rule #setRange(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #splitSetRange(
            #setRange(M, Addr1, Val1, Width1),
            Addr2,
            Val2,
            Addr1 -Int Addr2,
            Width2 -Int (Addr1 -Int Addr2)
        )
      requires Addr2 <Int Addr1
          andBool Addr1 <Int Addr2 +Int Width2
          andBool Addr2 +Int Width2 <Int Addr1 +Int Width1
      [simplification, concrete(Addr2, Addr1, Width2, Width1)]

  rule #setRange(
          #setRange(M:SparseBytes, Addr:Int, Val1:Int, Width1:Int),
          Addr:Int, Val2:Int, Width2:Int
      )
      => #setRange(
            #splitSetRange(M, Addr, Val1, Width2, Width1 -Int Width2),
            Addr, Val2, Width2
        )
      requires Width2 <Int Width1
      [simplification, concrete(Width2, Width1)]

  // ----------------------------------------

  syntax Bytes ::= #splitReplaceAtBytes(Bytes, addr:Int, value:Bytes, width:Int)  [function]
  rule #splitReplaceAtBytes(M:Bytes, Addr:Int, Value:Bytes, Width:Int)
      => replaceAtBytesTotal(
            replaceAtBytesTotal(
                M, Addr,
                substrBytes(Value, 0, Width)
            ),
            Addr +Int Width,
            substrBytes(Value, Width, lengthBytes(Value))
        )
      requires 0 <Int Width andBool Width <Int lengthBytes(Value)

  rule #setRange(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => replaceAtBytesTotal(
          #setRange(M, Addr2, Val2, Width2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, Width2)
      [simplification, concrete(Addr2,Val2,Width2), symbolic(Val1)]

  rule #setRange(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => replaceAtBytesTotal(
          #setRange(M, Addr2, Val2, Width2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, Width2)
        andBool Addr1 <Int Addr2
      [simplification, symbolic(Val1,Val2)]

  rule #setRange(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(M, Addr2, Val2, Width2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int lengthBytes(Val1) <=Int Addr2 +Int Width2
        andBool 0 <Int lengthBytes(Val1)
        andBool #setRangeActuallySets(Addr2, Val2, Width2)
      [simplification]
      // TODO: Consider adding rules for when Addr1 or lengthBytes(Val1) are symbolic

  rule #setRange(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(
            #splitReplaceAtBytes(
                M, Addr1, Val1,
                Addr2 -Int Addr1
            ),
            Addr2, Val2, Width2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1, Width2)]
  rule #setRange(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #splitSetRange(
            replaceAtBytesTotal(M, Addr1, Val1),
            Addr2,
            Val2,
            Addr1 -Int Addr2,
            Width2 -Int (Addr1 -Int Addr2)
        )
      requires Addr2 <Int Addr1
          andBool Addr1 <Int Addr2 +Int Width2
          andBool Addr2 +Int Width2 <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1, Width2)]

  rule #setRange(
          replaceAtBytesTotal(M:Bytes, Addr:Int, Val1:Bytes),
          Addr:Int, Val2:Int, Width2:Int
      )
      => #setRange(
            #splitReplaceAtBytes(M, Addr, Val1, Width2),
            Addr, Val2, Width2
        )
      requires Width2 <Int lengthBytes(Val1)
      [simplification, concrete(Width2)]

  // ----------------------------------------

  rule replaceAtBytesTotal(
          #setRange(M:Bytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => #setRange(
          replaceAtBytesTotal(M, Addr2, Val2),
          Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, lengthBytes(Val2))
      [simplification, concrete(Addr2,Val2), symbolic(Val1)]

  rule replaceAtBytesTotal(
          #setRange(M:Bytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => #setRange(
          replaceAtBytesTotal(M, Addr2, Val2),
          Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, lengthBytes(Val2))
        andBool Addr1 <Int Addr2
      [simplification, symbolic(Val1,Val2)]

  rule replaceAtBytesTotal(
          #setRange(M:Bytes, Addr1:Int, _Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(M, Addr2, Val2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int Width1 <=Int Addr2 +Int lengthBytes(Val2)
        andBool 0 <Int Width1
        andBool definedReplaceAtBytes(M, Addr2, Val2)
      [simplification]
      // TODO: Consider adding rules for when Addr1 or Width1 are symbolic

  rule replaceAtBytesTotal(
          #setRange(M:Bytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(
            #splitSetRange(
                M, Addr1, Val1,
                Addr2 -Int Addr1,
                Width1 -Int (Addr2 -Int Addr1)
            ),
            Addr2, Val2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int Width1
      [simplification, concrete(Addr2, Addr1, Width1)]
  rule replaceAtBytesTotal(
          #setRange(M:Bytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => #splitReplaceAtBytes(
            #setRange(M, Addr1, Val1, Width1),
            Addr2,
            Val2,
            Addr1 -Int Addr2
        )
      requires Addr2 <Int Addr1
          andBool Addr1 <Int Addr2 +Int lengthBytes(Val2)
          andBool Addr2 +Int lengthBytes(Val2) <Int Addr1 +Int Width1
      [simplification, concrete(Addr2, Addr1, Width1)]

  rule replaceAtBytesTotal(
          #setRange(M:Bytes, Addr:Int, Val1:Int, Width1:Int),
          Addr:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(
            #splitSetRange(M, Addr, Val1, lengthBytes(Val2), Width1 -Int lengthBytes(Val2)),
            Addr, Val2
        )
      requires lengthBytes(Val2) <Int Width1
      [simplification, concrete(Width1)]

  // ----------------------------------------

  rule replaceAtBytesTotal(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(
          replaceAtBytesTotal(M, Addr2, Val2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, lengthBytes(Val2))
      [simplification, concrete(Addr2,Val2), symbolic(Val1)]

  rule replaceAtBytesTotal(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(
          replaceAtBytesTotal(M, Addr2, Val2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, lengthBytes(Val2))
        andBool Addr1 <Int Addr2
      [simplification, symbolic(Val1,Val2)]

  rule replaceAtBytesTotal(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(M, Addr2, Val2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int lengthBytes(Val1) <=Int Addr2 +Int lengthBytes(Val2)
        andBool 0 <Int lengthBytes(Val1)
        andBool definedReplaceAtBytes(M, Addr2, Val2)
      [simplification]
      // TODO: Consider adding rules for when Addr1 or Width1 are symbolic

  rule replaceAtBytesTotal(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(
            #splitReplaceAtBytes(
                M, Addr1, Val1,
                Addr2 -Int Addr1
            ),
            Addr2, Val2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1)]
  rule replaceAtBytesTotal(
          replaceAtBytesTotal(M:Bytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => #splitReplaceAtBytes(
            replaceAtBytesTotal(M, Addr1, Val1),
            Addr2,
            Val2,
            Addr1 -Int Addr2
        )
      requires Addr2 <Int Addr1
          andBool Addr1 <Int Addr2 +Int lengthBytes(Val2)
          andBool Addr2 +Int lengthBytes(Val2) <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1)]

  rule replaceAtBytesTotal(
          replaceAtBytesTotal(M:Bytes, Addr:Int, Val1:Bytes),
          Addr:Int, Val2:Bytes
      )
      => replaceAtBytesTotal(
            #splitReplaceAtBytes(M, Addr, Val1, lengthBytes(Val2)),
            Addr, Val2
        )
      requires lengthBytes(Val2) <Int lengthBytes(Val1)
      [simplification]

  // ----------------------------------------

  syntax Int ::= #splitGetRange(SparseBytes, addr:Int, width:Int, additionalwidth:Int)  [function]
  rule #splitGetRange(M:SparseBytes, Addr:Int, Width:Int, AdditionalWidth:Int)
      => #getRange(M, Addr, Width)
        |Int #getRange(M, Addr +Int Width, AdditionalWidth) <<Int (8 *Int Width)

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


  rule #getBytesRange(
          #setRange(M:SparseBytes, SetAddr:Int, _SetVal:Int, SetWidth:Int),
          GetAddr:Int, GetWidth:Int
      )
      => #getBytesRange(M, GetAddr, GetWidth)
      requires disjontRanges(SetAddr, SetWidth, GetAddr, GetWidth)
      [simplification]
  rule #getBytesRange(
          #setRange(_M:SparseBytes, Addr:Int, Val:Int, Width:Int),
          Addr:Int, Width:Int
      )
      => SBChunk(#bytes(Int2Bytes(Width, Val, LE)))
      requires #setRangeActuallySets(Addr, Val, Width)
      [simplification]

  rule replaceAt
      ( #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int)
      , Addr2
      , Src:Bytes
      )
    => #setRange
      ( replaceAt(M, Addr2, Src)
      , Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, lengthBytes(Src))
    [simplification, concrete(Addr2, Src), symbolic(Val1)]

  rule padRightBytesTotal
      ( #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int)
      , Len, 0
      )
    => #setRange
      ( padRightBytesTotal(M, Len, 0)
      , Addr1, Val1, Width1
      )
      [simplification]

  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => maxInt(Addr +Int Width, size(M))
    requires #setRangeActuallySets(Addr, Val, Width)
      [simplification]
  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => size(M)
    requires notBool (#setRangeActuallySets(Addr, Val, Width))
      [simplification]

  syntax Bytes ::= splitSubstrBytesTotal(Bytes, start:Int, middle: Int, end:Int)  [function]
  rule splitSubstrBytesTotal(M:Bytes, Start:Int, Middle:Int, End:Int)
      => substrBytesTotal(M, Start, Middle) +Bytes substrBytesTotal(M, Middle, End)

  rule substrSparseBytes(
      #setRange(M:SparseBytes, Addr:Int, _Val:Int, Width:Int),
      Start:Int, End:Int)
    => substrSparseBytes(M, Start, End)
    requires disjontRanges(Addr, Width, Start, End -Int Start)
    [simplification]
  rule substrBytesTotal(
      #setRange(_M:Bytes, Addr:Int, _Val:Int, _Width:Int) #as SR:Bytes
      , Start:Int, End:Int
      )
      => splitSubstrBytesTotal(SR, Start, Addr, End)
      requires Start <Int Addr andBool Addr <Int End
      [simplification]
  rule substrBytesTotal(
      #setRange(_M:Bytes, Addr:Int, _Val:Int, Width:Int) #as SR:Bytes
      , Start:Int, End:Int
      )
      => splitSubstrBytesTotal(SR, Start, Addr +Int Width, End)
      requires Start <Int Addr +Int Width andBool Addr +Int Width <Int End
      [simplification]
  rule substrBytesTotal(
      #setRange(_M:Bytes, Addr:Int, Val:Int, Width:Int)
      , Start:Int, End:Int
      )
      => substrBytesTotal(Int2Bytes(Width, Val, LE), Start -Int Addr, End -Int Addr)
      requires Addr <=Int Start andBool End <=Int Addr +Int Width
        andBool #setRangeActuallySets(Addr, Val, Width)
      [simplification]

  rule substrBytesTotal(
      replaceAtBytesTotal(M:Bytes, Addr:Int, Src:Bytes),
      Start:Int, End:Int)
    => substrBytesTotal(M, Start, End)
    requires disjontRanges(Addr, lengthBytes(Src), Start, End -Int Start)
        andBool definedSubstrBytes(M, Start, End)
    [simplification]
  rule substrBytesTotal(
      replaceAtBytesTotal(_M:Bytes, Addr:Int, _Src:Bytes) #as SR:Bytes
      , Start:Int, End:Int
      )
      => splitSubstrBytesTotal(SR, Start, Addr, End)
      requires Start <Int Addr andBool Addr <Int End
      [simplification]
  rule substrBytesTotal(
      replaceAtBytesTotal(_M:Bytes, Addr:Int, Src:Bytes) #as SR:Bytes
      , Start:Int, End:Int
      )
      => splitSubstrBytesTotal(SR, Start, Addr +Int lengthBytes(Src), End)
      requires Start <Int Addr +Int lengthBytes(Src)
        andBool Addr +Int lengthBytes(Src) <Int End
      [simplification]
  rule substrBytesTotal(
      replaceAtBytesTotal(M:Bytes, Addr:Int, Src:Bytes)
      , Start:Int, End:Int
      )
      => substrBytesTotal(Src, Start -Int Addr, End -Int (Addr +Int lengthBytes(Src)))
      requires Addr <=Int Start andBool End <=Int Addr +Int lengthBytes(Src)
        andBool definedReplaceAtBytes(M, Addr, Src)
      [simplification]

  rule substrBytesTotal(B:Bytes, 0:Int, Len:Int) => B
      requires true
          andBool Len ==Int lengthBytes(B)
      [simplification]

  rule substrBytesTotal(Int2Bytes(Size:Int, Val:Int, LE), Start:Int, End:Int)
      => substrBytesTotal(Int2Bytes(Size -Int Start, Val >>Int (8 *Int Start), LE), 0, End -Int Start)
      requires 0 <Int Start andBool Start <Int Size
      [simplification]
  rule substrBytesTotal(Int2Bytes(Size:Int, Val:Int, LE), 0, End:Int)
      => substrBytesTotal(Int2Bytes(End, Val &Int ((1 <<Int (8 *Int End)) -Int 1), LE), 0, End)
      requires 0 <Int End andBool End <Int Size
      [simplification]

  rule substrBytesTotal(A +Bytes B, Start:Int, End:Int)
      => substrBytesTotal(B, Start -Int lengthBytes(A), End -Int lengthBytes(A))
      requires lengthBytes(A) <=Int Start
      [simplification]
  rule substrBytesTotal(A +Bytes _, Start:Int, End:Int)
      => substrBytesTotal(A, Start, End)
      requires End <=Int lengthBytes(A)
      [simplification]
  rule substrBytesTotal(A +Bytes B, Start:Int, End:Int)
      => substrBytesTotal(A, Start, lengthBytes(A))
        +Bytes substrBytesTotal(B, 0, End -Int lengthBytes(A))
      requires Start <Int lengthBytes(A)
          andBool lengthBytes(A) <Int End
      [simplification]

  syntax Bool ::= #setRangeActuallySets(addr:Int, val:Int, width:Int)  [function, total]
  rule #setRangeActuallySets(Addr:Int, Val:Int, Width:Int)
      => 0 <Int Width andBool 0 <=Int Val andBool 0 <=Int Addr

  syntax Bool ::= disjontRangesSimple(start1:Int, len1:Int, start2:Int, len2:Int)  [function, total]
  rule disjontRangesSimple(Start1:Int, Len1:Int, Start2:Int, Len2:Int)
      => (Start1 +Int Len1 <=Int Start2)
        orBool (Start2 +Int Len2 <=Int Start1)

  syntax Bool ::= disjontRanges(start1:Int, len1:Int, start2:Int, len2:Int)  [function, total]
  rule disjontRanges(Start1:Int, Len1:Int, Start2:Int, Len2:Int)
      => true
    requires disjontRangesSimple(Start1:Int, Len1:Int, Start2:Int, Len2:Int)
  rule disjontRanges(Start1:Int, Len1:Int, Start2:Int, Len2:Int)
      => false
    requires notBool disjontRangesSimple(Start1:Int, Len1:Int, Start2:Int, Len2:Int)

  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int) +Int B1:Int, Len1:Int
        , (A2:Int modIntTotal M2:Int) +Int B2:Int, Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      )
    [simplification]

  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int), Len1:Int
        , (A2:Int modIntTotal M2:Int) +Int B2:Int, Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      )
    [simplification]
  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int) +Int B1:Int, Len1:Int
        , (A2:Int modIntTotal M2:Int), Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 , Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      )
    [simplification]
  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int), Len1:Int
        , (A2:Int modIntTotal M2:Int), Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1, Len1, A2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      )
    [simplification]


  rule lengthBytes(Int2Bytes(Len:Int, _:Int, _:Endianness)) => Len  [simplification]
  rule lengthBytes(padRightBytesTotal(B:Bytes, Length:Int, Value:Int))
      => maxInt(lengthBytes(B:Bytes), Length:Int)
      requires definedPadRightBytes(B, Length, Value)
      [simplification]
  rule lengthBytes(replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes))
      => lengthBytes(Dest)
      requires definedReplaceAtBytes(Dest, Index, Src)
      [simplification]
  rule lengthBytes(substrBytesTotal(B:Bytes, Start:Int, End:Int))
      => End -Int Start
      requires definedSubstrBytes(B, Start, End)
      [simplification]
  rule lengthBytes(A +Bytes B) => lengthBytes(A) +Int lengthBytes(B)
      [simplification]
  rule 0 <=Int lengthBytes(_:Bytes) => true
      [simplification]

  rule X -Int X => 0  [simplification]
  rule X:KItem in (A:Set -Set B:Set) => (X in A) andBool notBool (X in B)  [simplification]

  rule (((X modIntTotal Y) +Int Z) +Int T) modIntTotal Y => (X +Int Z +Int T) modIntTotal Y
      [simplification]
  rule (((X modIntTotal Y) +Int Z) -Int T) modIntTotal Y => (X +Int Z -Int T) modIntTotal Y
      [simplification]
  rule ((X modIntTotal Y) +Int Z) modIntTotal Y => (X +Int Z) modIntTotal Y
      [simplification]
  rule (X +Int (Z modIntTotal Y)) modIntTotal Y => (X +Int Z) modIntTotal Y
      [simplification]
  rule (_X modIntTotal Y) <Int Y => true
      requires Y >Int 0
      [simplification, smt-lemma]
  rule 0 <=Int (_X modIntTotal Y) => true
      requires Y >Int 0
      [simplification, smt-lemma]
  rule (X +Int Y) modIntTotal Z => (X +Int (Y modInt Z)) modIntTotal Z
      requires Z =/=Int 0 andBool Y >=Int Z
      [simplification, concrete(Y, Z)]
  rule {((X +Int Y) modIntTotal M) #Equals ((X +Int Z) modIntTotal M)}
      => {(Y modIntTotal M) #Equals (Z modIntTotal M)}
      [simplification]
  rule X modIntTotal Y => X requires 0 <=Int X andBool X <Int Y

  rule {(A modIntTotal C) #Equals (B modIntTotal C)} => #Top
      requires A ==Int B
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

  rule A &Int 255 => A requires 0 <=Int A andBool A <=Int 255
      [simplification]

  rule A +Int B <Int C => A <Int C -Int B
      [simplification, concrete(B, C)]

  rule 0 <=Int log2IntTotal(_:Int) => true
      [simplification, smt-lemma]

  rule {0 #Equals A ^IntTotal _B} => #Bottom
      requires A =/=Int 0
      [simplification(40)]
  rule {A ^IntTotal _B #Equals 0} => #Bottom
      requires A =/=Int 0
      [simplification(40)]
  rule {0 #Equals A ^IntTotal B} => {0 #Equals A}
      requires B =/=Int 0
      [simplification(50)]

  // log2IntTotal(X) is the index of the highest bit. This means that
  // X < 2^(log2IntTotal(X) + 1) since the highest bit of the right term
  // has a higher index.
  // We need
  // 2^(log2IntTotal(X) + 1) <= 2 ^IntTotal (((log2IntTotal(X) +Int 8) divIntTotal 8) *Int 8)
  // which is equivalent to
  // log2IntTotal(X) + 1 <= ((log2IntTotal(X) +Int 8) divIntTotal 8) *Int 8.
  // Let us denote log2IntTotal(X) by Y >= 0
  // Y + 1 <= (Y divIntTotal 8 + 1) *Int 8.
  // Y + 1 <= (Y divIntTotal 8) *Int 8 + 8.
  // Y <= (Y divIntTotal 8) *Int 8 + 7.
  // Let A be Y divIntTotal 8
  // Let B be Y modIntTotal 8.
  // A * 8 + B <= A * 8 + 7, which is obviously true.
  rule A:Int <Int 2 ^IntTotal ((( log2IntTotal(A) +Int 8) divIntTotal 8) *Int 8)
      => true
      requires 0 <Int A
      [simplification]

  rule 0 |Int I:Int => I
      [simplification]
  rule I:Int |Int 0 => I
      [simplification]

  rule (A +String B) +String C => A +String (B +String C)
      [simplification, concrete(B,C)]

  rule (A <<IntTotal B) modIntTotal M
        => (A <<IntTotal B) &Int (M -Int 1)
      requires M ==Int 1 <<Int 32
          andBool 0 <=Int A
          andBool B <=Int 32
      [simplification, concrete(B)]
  rule (A <<IntTotal B) modIntTotal M
        => (A <<IntTotal B) &Int (M -Int 1)
      requires M ==Int 1 <<Int 64
          andBool 0 <=Int A
          andBool B <=Int 64
      [simplification, concrete(B)]
  rule (A <<IntTotal B) &Int M
        => (A &Int ((1 <<Int (32 -Int B)) -Int 1)) <<IntTotal B
      requires M ==Int (1 <<Int 32) -Int 1
          andBool 0 <=Int A
          andBool B <=Int 32
      [simplification, concrete(B)]
  rule (A <<IntTotal B) &Int M
        => (A &Int ((1 <<Int (64 -Int B)) -Int 1)) <<IntTotal B
      requires M ==Int (1 <<Int 64) -Int 1
          andBool 0 <=Int A
          andBool B <=Int 64
      [simplification, concrete(B)]

  rule (A <<IntTotal B) &Int M => 0
      requires 0 <Int M
          andBool M <Int (1 <<Int B)
          andBool 0 <=Int A
      [simplification, concrete(B)]

  rule (A &Int B) >>IntTotal C
      => (A >>IntTotal C) &Int (B >>IntTotal C)
      requires definedShlInt(A &Int B, C)
      [simplification, concrete(B, C)]
  rule ((A &Int B) <<IntTotal C) &Int D
      => (A &Int (B &Int (D >>IntTotal C))) <<IntTotal C
      requires 0 <=Int D andBool 0 <=Int A
      [simplification, concrete(B, C, D)]

  rule (A |Int B) <Int M => true
      requires A <Int 2 ^Int log2Int(M) andBool B <Int 2 ^Int log2Int(M)
      [simplification, concrete(M)]

  rule (A |Int B) >>Int C => (A >>Int C) |Int (B >>Int C)
      requires definedShlInt(A |Int B, C)
          andBool definedShlInt(A, C)
          andBool definedShrInt(B, C)
      [simplification]

  rule (A <<IntTotal B) <<IntTotal C => A <<IntTotal (B +Int C)
      requires 0 <=Int B andBool 0 <=Int C
      [simplification]
  rule (A >>IntTotal B) >>IntTotal C => A >>IntTotal (B +Int C)
      requires 0 <=Int B andBool 0 <=Int C
      [simplification]
  rule (A <<IntTotal B) >>IntTotal C => A <<IntTotal (B -Int C)
      requires C <=Int B andBool 0 <=Int C
          andBool definedShlInt(A, B)
          andBool definedShrInt(A, C)
      [simplification]
  rule (A <<IntTotal B) >>IntTotal C => A >>IntTotal (C -Int B)
      requires B <=Int C andBool 0 <=Int B
          andBool definedShlInt(A, B)
          andBool definedShrInt(A, C)
      [simplification]

  rule (A |Int B) modIntTotal M => (A |Int B) &Int (M -Int 1)
      requires 0 <=Int A andBool 0 <=Int B
        andBool M ==Int 1 <<Int 32
      [simplification]

  rule (A |Int B) modIntTotal M => (A |Int B) &Int (M -Int 1)
      requires 0 <=Int A andBool 0 <=Int B
        andBool M ==Int 1 <<Int 64
      [simplification]

  rule (A |Int B) &Int C => (A &Int C) |Int (B &Int C)
      [simplification]

  rule (A <<IntTotal 0) => A
      requires definedShlInt(A, 0)
      [simplification]

  rule (A >>IntTotal 0) => A
      requires definedShrInt(A, 0)
      [simplification]

  rule A |Int B => B |Int A
      [simplification, concrete(A), symbolic(B)]
  rule A |Int 0 => A
      [simplification]
  rule (A |Int B) |Int C => A |Int (B |Int C)
      [simplification, concrete(B, C), symbolic(A)]

  rule 0 <=Int A |Int B => 0 <=Int A andBool 0 <=Int B
      [simplification]
  rule 0 <=Int A &Int B => 0 <=Int A orBool 0 <=Int B
      [simplification]
  rule 0 <=Int A <<IntTotal B => 0 <=Int A
      requires definedShlInt(A, B)
      [simplification]
  rule 0 <=Int A >>IntTotal B => 0 <=Int A
      requires definedShrInt(A, B)
      [simplification]

  rule A |Int B <=Int C => A <=Int C andBool B <=Int C
      requires
          ( ( (  C +Int 1 ==Int (1 <<Int 8)
          orBool C +Int 1 ==Int (1 <<Int 16) )
          orBool C +Int 1 ==Int (1 <<Int 24) )
          orBool C +Int 1 ==Int (1 <<Int 32)
          )
      [simplification, concrete(C)]
  rule A &Int B <=Int C => true
      requires
          0 <=Int A
          andBool 0 <=Int B
          andBool (A <=Int C orBool B <=Int C)
      [simplification]
  rule A <<IntTotal B <=Int C => A <=Int (C >>Int B)
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShlInt(A, B)
      [simplification, concrete(B, C)]
  rule A >>IntTotal B <=Int C => A <=Int ((C +Int 1) <<Int B) -Int 1
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShrInt(A, B)
      [simplification, concrete(B, C)]

  rule A |Int B <Int C => A <Int C andBool B <Int C
      requires
          ( ( (  C ==Int (1 <<Int 8)
          orBool C ==Int (1 <<Int 16) )
          orBool C ==Int (1 <<Int 24) )
          orBool C ==Int (1 <<Int 32)
          )
      [simplification, concrete(C)]
  rule A &Int B <Int C => true
      requires
          0 <=Int A
          andBool 0 <=Int B
          andBool (A <Int C orBool B <Int C)
      [simplification]
  rule A <<IntTotal B <Int C => A <=Int ((C -Int 1) >>Int B) +Int 1
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShlInt(A, B)
      [simplification, concrete(B, C)]
  rule A >>IntTotal B <Int C => A <Int (C <<Int B)
      requires 0 <=Int A
          andBool 0 <=Int C
          andBool definedShrInt(A, B)
      [simplification, concrete(B, C)]

  rule (A &Int B) => A
      requires
          0 <=Int A
          andBool A <Int B
          andBool (
              B ==Int ((1 <<Int 8) -Int 1)
              orBool B ==Int ((1 <<Int 16) -Int 1)
              orBool B ==Int ((1 <<Int 32) -Int 1)
              orBool B ==Int ((1 <<Int 64) -Int 1)
          )
      [simplification]
  rule (A &Int B) => 0
      requires
          0 <=Int A
          andBool (
              ( A <Int ((1 <<Int 8) -Int 1)
                andBool B &Int ((1 <<Int 8) -Int 1) ==Int 0
              )
              orBool ( A <Int ((1 <<Int 16) -Int 1)
                andBool B &Int ((1 <<Int 16) -Int 1) ==Int 0
              )
              orBool ( A <Int ((1 <<Int 32) -Int 1)
                andBool B &Int ((1 <<Int 32) -Int 1) ==Int 0
              )
          )
      [simplification]

  rule A &Int B => B &Int A
      [simplification, concrete(A), symbolic(B)]
  rule _A &Int 0 => 0
      [simplification]
  rule (A &Int B) &Int C => A &Int (B &Int C)
      [simplification, concrete(B, C), symbolic(A)]

  rule b"" +Bytes B => B
  rule B +Bytes b"" => B
      [simplification]
  rule (A +Bytes B) +Bytes C => A +Bytes (B +Bytes C)
      [simplification, concrete(B, C), symbolic(A)]
  rule A +Bytes (B +Bytes C) => (A +Bytes B) +Bytes C
      [simplification, concrete(A, B), symbolic(C)]
endmodule

```
