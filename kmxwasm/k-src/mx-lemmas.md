```k
requires "ceils.k"
requires "lemmas/bytes-normalization-lemmas.md"
requires "lemmas/int-encoding-lemmas.md"
requires "lemmas/int-inequalities-lemmas.md"
requires "lemmas/int-length-lemmas.md"
requires "lemmas/int-normalization-lemmas.md"
requires "lemmas/sparse-bytes-lemmas.md"

module MX-LEMMAS-BASIC
  imports BOOL
  imports INT
  imports INT-ENCODING-BASIC
  imports INT-LENGTH-LEMMAS-BASIC
  imports INT-NORMALIZATION-LEMMAS-BASIC

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

  rule {false #Equals B:Bool} => #Not ({true #Equals B:Bool})
      [simplification]

  rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:FValType > _:Float) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:RefValType > _:Int) #Equals undefined } => #Bottom  [simplification]

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

  rule #getRange(SBChunk(A:SBItem) B:SparseBytes, Start, Width)
      => #getRange(B, Start -Int size(SBChunk(A)), Width)
    requires size(SBChunk(A)) <=Int Start
    [simplification]
  rule #getRange(SBChunk(A:SBItem) _B:SparseBytes, Start, Width)
      => #getRange(SBChunk(A), Start, Width)
    requires Start <Int size(SBChunk(A)) andBool Start +Int Width <=Int size(SBChunk(A))
    [simplification]
  rule #getRange(SBChunk(A:SBItem) B:SparseBytes, Start, Width)
      => #splitGetRange(SBChunk(A) B, Start, size(SBChunk(A)) -Int Start, Start +Int Width -Int size(SBChunk(A)))
    requires Start <Int size(SBChunk(A)) andBool size(SBChunk(A)) <Int Start +Int Width
    [simplification]

  rule #getRange(M:SparseBytes SBChunk(_), Start:Int, Width:Int)
      => #getRange(M, Start, Width)
      requires Start +Int Width <=Int size(M)
      [simplification, concrete(Width)]
  rule #getRange(M:SparseBytes SBChunk(A), Start:Int, Width:Int)
      => #getRange(SBChunk(A), Start -Int size(M), Width)
      requires 0 <Int size(M) andBool size(M) <=Int Start
      [simplification, concrete(Width)]

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
  // rule #getRange(padRightBytesTotal(B:Bytes, PadLen:Int, Val:Int), Start:Int, GetLen:Int)
  //     => #getRange(B, Start, GetLen)
  //     requires true
  //         andBool definedPadRightBytes(B, PadLen, Val)
  //         andBool (PadLen <Int Start orBool Start +Int GetLen <Int lengthBytes(B))
  //     [simplification]

  // ----------------------------------------

  rule #setRange(.SparseBytes, 0, Value:Int, Width:Int)
      => SBChunk(#bytes(Int2Bytes(Width, Value, LE)))
      [simplification, concrete(Width)]
  rule #setRange(.SparseBytes, Addr:Int, Value:Int, Width:Int)
      => SBChunk(#empty(Addr)) SBChunk(#bytes(Int2Bytes(Width, Value, LE)))
      requires 0 <Int Addr
      [simplification, concrete(Width, Addr)]
  rule #setRange(SBChunk(A) M:SparseBytes, Addr:Int, Value:Int, Width:Int)
      => SBChunk(A) #setRange(M, Addr -Int size(SBChunk(A)), Value, Width)
      requires size(SBChunk(A)) <=Int Addr
      [simplification, concrete(Width)]
  rule #setRange(SBChunk(A) M:SparseBytes, Addr:Int, Value:Int, Width:Int)
      => substrSparseBytes(SBChunk(A), 0, Addr)
        #setRange(
          substrSparseBytes(SBChunk(A) M, Addr, size(SBChunk(A) M)),
          0, Value, Width
        )
      requires 0 <Int Addr
        andBool Addr <Int size(SBChunk(A))
      [simplification, concrete(Width)]
  rule #setRange(M:SparseBytes, 0, Value:Int, Width:Int)
      => SBChunk(#bytes(Int2Bytes(Width, Value, LE)))
        substrSparseBytes(M, Width, size(M))
      requires Width <Int size(M)
      [simplification, concrete(Width)]
  rule #setRange(M:SparseBytes, 0, Value:Int, Width:Int)
      => SBChunk(#bytes(Int2Bytes(Width, Value, LE)))
      requires size(M) <=Int Width
      [simplification, concrete(Width)]
  rule #setRange(M:SparseBytes SBChunk(A), Addr:Int, Value:Int, Width:Int)
      => #setRange(M, Addr, Value, Width) SBChunk(A)
      requires Addr +Int Width <=Int size(M)
      [simplification, concrete(Width)]
  rule #setRange(M:SparseBytes SBChunk(A), Addr:Int, Value:Int, Width:Int)
      => M
        #setRange(
          SBChunk(A),
          Addr -Int size(M),
          Value, Width
        )
      requires 0 <Int size(M) andBool size(M) <=Int Addr
      [simplification, concrete(Width)]

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

  syntax SparseBytes ::= #splitReplaceAt(SparseBytes, addr:Int, value:Bytes, width:Int)  [function]
  rule #splitReplaceAt(M:SparseBytes, Addr:Int, Value:Bytes, Width:Int)
      => replaceAt(
            replaceAt(
                M, Addr,
                substrBytes(Value, 0, Width)
            ),
            Addr +Int Width,
            substrBytes(Value, Width, lengthBytes(Value))
        )
      requires 0 <Int Width andBool Width <Int lengthBytes(Value)
        andBool 0 <Int Addr

  rule #setRange(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => replaceAt(
          #setRange(M, Addr2, Val2, Width2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, Width2)
        andBool 0 <=Int Addr1
      [simplification, concrete(Addr2,Val2,Width2), symbolic(Val1)]

  rule #setRange(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => replaceAt(
          #setRange(M, Addr2, Val2, Width2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, Width2)
        andBool Addr1 <Int Addr2
        andBool 0 <=Int Addr1
      [simplification, symbolic(Val1,Val2)]

  rule #setRange(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(M, Addr2, Val2, Width2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int lengthBytes(Val1) <=Int Addr2 +Int Width2
        andBool 0 <Int lengthBytes(Val1)
        andBool #setRangeActuallySets(Addr2, Val2, Width2)
        // Implied: 0 <=Int Addr2 <=Int Addr1
      [simplification]
      // TODO: Consider adding rules for when Addr1 or lengthBytes(Val1) are symbolic

  rule #setRange(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #setRange(
            #splitReplaceAt(
                M, Addr1, Val1,
                Addr2 -Int Addr1
            ),
            Addr2, Val2, Width2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1, Width2)]
  rule #setRange(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Int, Width2:Int
      )
      => #splitSetRange(
            replaceAt(M, Addr1, Val1),
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
          replaceAt(M:SparseBytes, Addr:Int, Val1:Bytes),
          Addr:Int, Val2:Int, Width2:Int
      )
      => #setRange(
            #splitReplaceAt(M, Addr, Val1, Width2),
            Addr, Val2, Width2
        )
      requires Width2 <Int lengthBytes(Val1)
      [simplification, concrete(Width2)]

  // ----------------------------------------

  rule replaceAt(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => #setRange(
          replaceAt(M, Addr2, Val2),
          Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, lengthBytes(Val2))
        andBool 0 <=Int Addr2
      [simplification, concrete(Addr2,Val2), symbolic(Val1)]

  rule replaceAt(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => #setRange(
          replaceAt(M, Addr2, Val2),
          Addr1, Val1, Width1
      )
      requires disjontRanges(Addr1, Width1, Addr2, lengthBytes(Val2))
        andBool Addr1 <Int Addr2
        andBool 0 <=Int Addr2
      [simplification, symbolic(Val1,Val2)]

  rule replaceAt(
          #setRange(M:SparseBytes, Addr1:Int, _Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => replaceAt(M, Addr2, Val2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int Width1 <=Int Addr2 +Int lengthBytes(Val2)
        andBool 0 <Int Width1
      [simplification]
      // TODO: Consider adding rules for when Addr1 or Width1 are symbolic

  rule replaceAt(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => replaceAt(
            #splitSetRange(
                M, Addr1, Val1,
                Addr2 -Int Addr1,
                Width1 -Int (Addr2 -Int Addr1)
            ),
            Addr2, Val2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int Width1
      [simplification, concrete(Addr2, Addr1, Width1)]
  rule replaceAt(
          #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int),
          Addr2:Int, Val2:Bytes
      )
      => #splitReplaceAt(
            #setRange(M, Addr1, Val1, Width1),
            Addr2,
            Val2,
            Addr1 -Int Addr2
        )
      requires Addr2 <Int Addr1
          andBool Addr1 <Int Addr2 +Int lengthBytes(Val2)
          andBool Addr2 +Int lengthBytes(Val2) <Int Addr1 +Int Width1
      [simplification, concrete(Addr2, Addr1, Width1)]

  rule replaceAt(
          #setRange(M:SparseBytes, Addr:Int, Val1:Int, Width1:Int),
          Addr:Int, Val2:Bytes
      )
      => replaceAt(
            #splitSetRange(M, Addr, Val1, lengthBytes(Val2), Width1 -Int lengthBytes(Val2)),
            Addr, Val2
        )
      requires lengthBytes(Val2) <Int Width1
      [simplification, concrete(Width1)]

  // ----------------------------------------

  rule replaceAt(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAt(
          replaceAt(M, Addr2, Val2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, lengthBytes(Val2))
        andBool 0 <=Int Addr1
        andBool 0 <=Int Addr2
      [simplification, concrete(Addr2,Val2), symbolic(Val1)]

  rule replaceAt(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAt(
          replaceAt(M, Addr2, Val2),
          Addr1, Val1
      )
      requires disjontRanges(Addr1, lengthBytes(Val1), Addr2, lengthBytes(Val2))
        andBool Addr1 <Int Addr2
        andBool 0 <=Int Addr1
      [simplification, symbolic(Val1,Val2)]

  rule replaceAt(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAt(M, Addr2, Val2)
      requires Addr2 <=Int Addr1
        andBool Addr1 +Int lengthBytes(Val1) <=Int Addr2 +Int lengthBytes(Val2)
        andBool 0 <Int lengthBytes(Val1)
      [simplification]
      // TODO: Consider adding rules for when Addr1 or Width1 are symbolic

  rule replaceAt(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => replaceAt(
            #splitReplaceAt(
                M, Addr1, Val1,
                Addr2 -Int Addr1
            ),
            Addr2, Val2
        )
      requires Addr1 <Int Addr2 andBool Addr2 <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1)]
  rule replaceAt(
          replaceAt(M:SparseBytes, Addr1:Int, Val1:Bytes),
          Addr2:Int, Val2:Bytes
      )
      => #splitReplaceAt(
            replaceAt(M, Addr1, Val1),
            Addr2,
            Val2,
            Addr1 -Int Addr2
        )
      requires Addr2 <Int Addr1
          andBool Addr1 <Int Addr2 +Int lengthBytes(Val2)
          andBool Addr2 +Int lengthBytes(Val2) <Int Addr1 +Int lengthBytes(Val1)
      [simplification, concrete(Addr2, Addr1)]

  rule replaceAt(
          replaceAt(M:SparseBytes, Addr:Int, Val1:Bytes),
          Addr:Int, Val2:Bytes
      )
      => replaceAt(
            #splitReplaceAt(M, Addr, Val1, lengthBytes(Val2)),
            Addr, Val2
        )
      requires lengthBytes(Val2) <Int lengthBytes(Val1)
      [simplification]

  // ----------------------------------------

  syntax SparseBytes ::= replaceAtBLast(current:Bytes, rest:SparseBytes, start:Int, replacement:Bytes)  [function, total]
  syntax SparseBytes ::= findLast(replacementEnd:Int, processedSize:Int, reversedProcessed:SparseBytes, unprocessed:SparseBytes)  [function, total]
  syntax Bool ::= replaceAtBLastIsBetter(replacementEnd:Int, processedSize:Int, unprocessed:SparseBytes)  [function, total]
  syntax SparseBytes ::= reverseLast(reversed:SparseBytes, unprocessed:SparseBytes)  [function, total]
  syntax SparseBytes ::= rconcat(reversed:SparseBytes, unprocessed:SparseBytes)  [function, total]

  rule replaceAtB(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes)
      => replaceAtBLast(Current, findLast(Start +Int lengthBytes(Value), lengthBytes(Current), .SparseBytes, Rest), Start, Value)
      requires 0 <=Int Start
        andBool replaceAtBLastIsBetter(Start +Int lengthBytes(Value), lengthBytes(Current), Rest)
        // andBool Start +Int lengthBytes(Value)
        //       <=Int lengthBytes(Current) +Int size(removeLast(Rest))
      [simplification]

  rule replaceAtBLast(Current, findLast(ReplaceEnd, ProcessedSize, S:SparseBytes, SBIC:SBItemChunk), Start, Value)
      => concat(replaceAtBLast(Current, reverseLast(.SparseBytes, S), Start, Value), SBIC)
      requires ReplaceEnd <=Int ProcessedSize
      [simplification(50)]
  rule replaceAtBLast(Current, findLast(ReplaceEnd, ProcessedSize, S:SparseBytes, SBIC:SBItemChunk S2:SparseBytes), Start, Value)
      => replaceAtBLast(Current, findLast(ReplaceEnd, ProcessedSize +Int size(SBIC), rconcat(SBIC, S), S2), Start, Value)
      requires 0 <Int size(S2)
      [simplification(51)]
  rule replaceAtBLast(Current, findLast(ReplaceEnd, ProcessedSize, S:SparseBytes, concat(S1:SparseBytes, S2:SparseBytes)), Start, Value)
      => replaceAtBLast(Current, findLast(ReplaceEnd, ProcessedSize +Int size(S1), rconcat(S1, S), S2), Start, Value)
      [simplification(51)]
  rule replaceAtBLast(Current, findLast(ReplaceEnd, ProcessedSize, S:SparseBytes, S2:SparseBytes), Start, Value)
      => concat(replaceAtBLast(Current, reverseLast(.SparseBytes, S), Start, Value), S2)
      requires ReplaceEnd <=Int ProcessedSize
      [simplification(52)]

  rule reverseLast(A, rconcat(B, C)) => reverseLast(concat(B, A), C)
      [simplification(50)]
  rule reverseLast(A, B) => concat(B, A)
      [simplification(51)]

  rule replaceAtBLastIsBetter(ReplaceEnd, ProcessedSize, SBIC:SBItemChunk) => true
      requires ReplaceEnd <=Int ProcessedSize
      [simplification(50)]
  rule replaceAtBLastIsBetter(ReplaceEnd, ProcessedSize, SBIC:SBItemChunk A)
      => replaceAtBLastIsBetter(ReplaceEnd, ProcessedSize +Int size(SBIC), A)
      requires 0 <Int size(A)
      [simplification(51)]
  rule replaceAtBLastIsBetter(ReplaceEnd, ProcessedSize, concat(A, B))
      => replaceAtBLastIsBetter(ReplaceEnd, ProcessedSize +Int size(A), B)
      [simplification(51)]
  rule replaceAtBLastIsBetter(ReplaceEnd, ProcessedSize, A) => true
      requires ReplaceEnd <=Int ProcessedSize
      [simplification(52)]

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
      => Int2Bytes(Width, Val, LE)
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

  // rule padRightBytesTotal
  //     ( #setRange(M:SparseBytes, Addr1:Int, Val1:Int, Width1:Int)
  //     , Len, 0
  //     )
  //   => #setRange
  //     ( padRightBytesTotal(M, Len, 0)
  //     , Addr1, Val1, Width1
  //     )
  //     [simplification]

  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => maxInt(Addr +Int Width, size(M))
    requires #setRangeActuallySets(Addr, Val, Width)
      [simplification]
  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => size(M)
    requires notBool (#setRangeActuallySets(Addr, Val, Width))
      [simplification]

  syntax SparseBytes ::= splitSubstrSparseBytes(SparseBytes, start:Int, middle: Int, end:Int)  [function]
  rule splitSubstrSparseBytes(M:SparseBytes, Start:Int, Middle:Int, End:Int)
      => concat(substrSparseBytes(M, Start, Middle), substrSparseBytes(M, Middle, End))
    requires 0 <=Int Start
      andBool Start <=Int Middle
      andBool Middle <=Int End
  rule splitSubstrSparseBytes(_M:SparseBytes, Start:Int, Middle:Int, End:Int)
      => .SparseBytes
    requires Start <Int 0
      orBool Middle <Int Start
      orBool End <Int Middle

  rule substrSparseBytes(
      #setRange(M:SparseBytes, Addr:Int, _Val:Int, Width:Int),
      Start:Int, End:Int)
    => substrSparseBytes(M, Start, End)
    requires disjontRanges(Addr, Width, Start, End -Int Start)
      andBool (
          Addr <=Int size(M)
          orBool End <=Int size(M)
          orBool Addr <=Int Start
      )
    [simplification]
  rule substrSparseBytes(
      #setRange(M:SparseBytes, Addr:Int, _Val:Int, Width:Int),
      Start:Int, End:Int)
    => SBChunk(#empty(End -Int Start))
    requires disjontRanges(Addr, Width, Start, End -Int Start)
      andBool size(M) <Int Addr
      andBool size(M) <Int End
      andBool Start <Int Addr
      andBool size(M) <=Int Start
      andBool Start <=Int End
      // Implied: 0 <=Int Start
    [simplification]
  rule substrSparseBytes(
      #setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int),
      Start:Int, End:Int)
    => splitSubstrSparseBytes(#setRange(M, Addr, Val, Width), Start, size(M), End)
    requires disjontRanges(Addr, Width, Start, End -Int Start)
      andBool size(M) <Int Addr
      andBool size(M) <Int End
      // Implied: andBool Start <Int Addr
      andBool Start <Int size(M)
      // Implied: andBool Start <=Int End
    [simplification]
  rule substrSparseBytes(
      #setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int)
      , Start:Int, End:Int
      )
      => splitSubstrSparseBytes(#setRange(M, Addr, Val, Width), Start, Addr, End)
      requires Start <Int Addr andBool Addr <Int End
      [simplification]
  rule substrSparseBytes(
      #setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int)
      , Start:Int, End:Int
      )
      => splitSubstrSparseBytes(#setRange(M, Addr, Val, Width), Start, Addr +Int Width, End)
      requires Start <Int Addr +Int Width andBool Addr +Int Width <Int End
      [simplification]
  rule substrSparseBytes(
      #setRange(_M:SparseBytes, Addr:Int, Val:Int, Width:Int)
      , Start:Int, End:Int
      )
      => substrSparseBytes(SBChunk(#bytes(Int2Bytes(Width, Val, LE))), Start -Int Addr, End -Int Addr)
      requires Addr <=Int Start andBool End <=Int Addr +Int Width
        andBool #setRangeActuallySets(Addr, Val, Width)
        // Implied: 0 <=Int Start and 0 <=Int Start - Addr
        //          Start <=Int End iff Start -Int Addr <=Int End -Int Addr
      [simplification]

  rule substrSparseBytes(
      replaceAt(M:SparseBytes, Addr:Int, Src:Bytes),
      Start:Int, End:Int)
    => substrSparseBytes(M, Start, End)
    requires disjontRanges(Addr, lengthBytes(Src), Start, End -Int Start)
      andBool (
          Addr <=Int size(M)
          orBool End <=Int size(M)
          orBool Addr <=Int Start
      )
    [simplification]
  rule substrSparseBytes(
      replaceAt(M:SparseBytes, Addr:Int, Src:Bytes),
      Start:Int, End:Int)
    => SBChunk(#empty(End -Int Start))
    requires disjontRanges(Addr, lengthBytes(Src), Start, End -Int Start)
      andBool size(M) <Int Addr
      andBool size(M) <Int End
      andBool Start <Int Addr
      andBool size(M) <=Int Start
      andBool Start <=Int End
      // Implied: 0 <=Int Start
    [simplification]
  rule substrSparseBytes(
      replaceAt(M:SparseBytes, Addr:Int, Src:Bytes),
      Start:Int, End:Int)
    => splitSubstrSparseBytes(replaceAt(M, Addr, Src), Start, size(M), End)
    requires disjontRanges(Addr, lengthBytes(Src), Start, End -Int Start)
      andBool size(M) <Int Addr
      andBool size(M) <Int End
      andBool Start <Int size(M)
      // Implied: Start <Int Addr
      // Implied: Start <=Int End
    [simplification]
  rule substrSparseBytes(
      replaceAt(M:SparseBytes, Addr:Int, Src:Bytes)
      , Start:Int, End:Int
      )
      => splitSubstrSparseBytes(replaceAt(M, Addr, Src), Start, Addr, End)
      requires Start <Int Addr andBool Addr <Int End
        andBool 0 <=Int Start
      [simplification]
  rule substrSparseBytes(
      replaceAt(M:SparseBytes, Addr:Int, Src:Bytes)
      , Start:Int, End:Int
      )
      => splitSubstrSparseBytes(replaceAt(M, Addr, Src), Start, Addr +Int lengthBytes(Src), End)
      requires Start <Int Addr +Int lengthBytes(Src)
        andBool Addr +Int lengthBytes(Src) <Int End
        andBool 0 <=Int Addr
      [simplification]
  rule substrSparseBytes(
      replaceAt(_M:SparseBytes, Addr:Int, Src:Bytes)
      , Start:Int, End:Int
      )
      => SBChunk(#bytes(substrBytes(Src, Start -Int Addr, End -Int Addr)))
      requires Addr <=Int Start andBool End <=Int Addr +Int lengthBytes(Src)
        andBool 0 <=Int Addr
        andBool Start <=Int End
      [simplification]

  rule substrSparseBytes(B:SparseBytes, 0:Int, Len:Int) => B
      requires true
        andBool Len ==Int size(B)
      [simplification]

  rule substrSparseBytes(SBChunk(#bytes(Int2Bytes(Size:Int, Val:Int, LE))), Start:Int, End:Int)
      => substrSparseBytes(SBChunk(#bytes(Int2Bytes(Size -Int Start, Val >>Int (8 *Int Start), LE))), 0, End -Int Start)
      requires 0 <Int Start andBool Start <Int Size
      [simplification]
  rule substrSparseBytes(SBChunk(#bytes(Int2Bytes(Size:Int, Val:Int, LE))), 0, End:Int)
      => substrSparseBytes(SBChunk(#bytes(Int2Bytes(End, Val &Int ((1 <<Int (8 *Int End)) -Int 1), LE))), 0, End)
      requires 0 <Int End andBool End <Int Size
      [simplification]

  rule substrSparseBytes(concat(A:SparseBytes, B:SparseBytes), Start:Int, End:Int)
      => substrSparseBytes(B, Start -Int size(A), End -Int size(A))
      requires size(A) <=Int Start
      [simplification]
  rule substrSparseBytes(concat(A:SparseBytes, _:SparseBytes), Start:Int, End:Int)
      => substrSparseBytes(A, Start, End)
      requires End <=Int size(A)
      [simplification]
  rule substrSparseBytes(concat(A:SparseBytes, B:SparseBytes), Start:Int, End:Int)
      => concat(
        substrSparseBytes(A, Start, size(A)),
        substrSparseBytes(B, 0, End -Int size(A))
      )
      requires Start <Int size(A)
          andBool size(A) <Int End
      [simplification]

  rule substrBytesTotal(_, Start:Int, Start:Int)
      => b""
      [simplification(40)]
  rule substrBytesTotal(Int2Bytes(Size:Int, Value:Int, LE), Start:Int, End:Int)
      => Int2Bytes(
          End -Int Start,
          (Value >>Int (8 *Int Start)),
          LE
      )
      requires 0 <=Int Start andBool Start <=Int End andBool End <=Int Size
      [simplification]

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
