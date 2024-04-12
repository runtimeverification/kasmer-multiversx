```k

module SPARSE-BYTES-LEMMAS-BASIC
  imports CEILS-SYNTAX
  imports SPARSE-BYTES
  imports WASM-DATA-COMMON

  syntax SparseBytes ::= concat(SparseBytes, SparseBytes)  [function, total, symbol(concatSparseBytes)]
  rule concat(.SparseBytes, A:SparseBytes) => A
  rule concat(A:SBItemChunk B:SparseBytes, C:SparseBytes) => A concat(B, C)

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

  syntax Int ::= #splitGetRange(SparseBytes, addr:Int, width:Int, additionalwidth:Int)  [function]
  rule #splitGetRange(M:SparseBytes, Addr:Int, Width:Int, AdditionalWidth:Int)
      => #getRange(M, Addr, Width)
        |Int #getRange(M, Addr +Int Width, AdditionalWidth) <<Int (8 *Int Width)

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

endmodule

```