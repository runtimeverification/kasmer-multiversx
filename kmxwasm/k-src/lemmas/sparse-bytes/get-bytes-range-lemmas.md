```k
module GET-BYTES-RANGE-LEMMAS
  imports private GET-BYTES-RANGE-SET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC
endmodule

module GET-BYTES-RANGE-SET-RANGE-LEMMAS
  imports SPARSE-BYTES-LEMMAS-BASIC

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
endmodule

```