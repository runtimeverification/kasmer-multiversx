```k
module SET-RANGE-LEMMAS
  imports SET-RANGE-REPLACE-AT-LEMMAS
  imports SET-RANGE-SET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

  rule #setRange(.SparseBytes, 0, Value:Int, Width:Int)
      => SBChunk(#bytes(Int2Bytes(Width, Value, LE)))
      [simplification, concrete(Width)]
  rule #setRange(.SparseBytes, Addr:Int, Value:Int, Width:Int)
      => SBChunk(#empty(Addr)) SBChunk(#bytes(Int2Bytes(Width, Value, LE)))
      requires 0 <Int Addr
      [simplification, concrete(Width, Addr)]
  rule #setRange(SBChunk(A) M:SparseBytes, Addr:Int, Value:Int, Width:Int)
      => concat
          ( substrSparseBytes(SBChunk(A), 0, Addr)
          , #setRange(
              substrSparseBytes(SBChunk(A) M, Addr, size(SBChunk(A) M)),
              0, Value, Width
            )
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

endmodule

module SET-RANGE-SET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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

endmodule

module SET-RANGE-REPLACE-AT-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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
endmodule

```