```k
module REPLACE-AT-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC
  imports private REPLACE-AT-SET-RANGE-LEMMAS
  imports private REPLACE-AT-REPLACE-AT-LEMMAS
endmodule

module REPLACE-AT-SET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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
endmodule

module REPLACE-AT-REPLACE-AT-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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
endmodule
```