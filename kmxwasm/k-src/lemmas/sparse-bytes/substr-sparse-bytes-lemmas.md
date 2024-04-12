```k
module SUBSTR-SPARSE-BYTES-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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
endmodule

module SUBSTR-SPARSE-BYTES-SET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC


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
endmodule

module SUBSTR-SPARSE-BYTES-REPLACE-AT-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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
endmodule
```