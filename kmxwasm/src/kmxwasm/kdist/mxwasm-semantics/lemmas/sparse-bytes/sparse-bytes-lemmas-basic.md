```k

module SPARSE-BYTES-LEMMAS-BASIC
  imports CEILS-SYNTAX
  imports SPARSE-BYTES
  imports WASM-DATA-COMMON

  syntax SparseBytes ::= concat(SparseBytes, SparseBytes)  [function, total, symbol(concatSparseBytes)]
  rule concat(.SparseBytes, A:SparseBytes) => A
  rule concat(A:SBItemChunk B:SparseBytes, C:SparseBytes) => merge(A, concat(B, C))
  syntax SparseBytes ::= merge(SBItemChunk, SparseBytes)  [function, total, symbol(mergeSparseBytes)]
  rule merge(SBChunk(#bytes(A)), SBChunk(#bytes(B)) C:SparseBytes) => SBChunk(#bytes(A +Bytes B)) C
  rule merge(SBChunk(#empty(A)), SBChunk(#empty(B)) C:SparseBytes) => SBChunk(#empty(A +Int B)) C
  rule merge(A:SBItemChunk, B:SparseBytes) => A B [owise]

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

```