```k
module GET-BYTES-RANGE-LEMMAS-BASIC
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    syntax SBGetFunction ::= "getBytesRange"
endmodule

module GET-BYTES-RANGE-LEMMAS  [symbolic]
    imports GET-BYTES-RANGE-LEMMAS-BASIC

    rule functionCommutesAtStart(getBytesRange) => true

    rule #getBytesRange(SB, Addr:Int, Width:Int)
        => unwrap(extractSparseBytes(getBytesRange, SB, Addr, Width))
        requires (0 <Int Addr orBool Addr +Int Width =/=Int size(SB))
             andBool Addr <Int size(SB)
             andBool 0 <Int Width andBool 0 <=Int Addr
        [simplification]
    rule extractSparseBytes(getBytesRange, SB, Addr, Width)
        => fromBytes(#getBytesRange(SB, Addr, Width))
        requires (Addr ==Int 0 andBool Addr +Int Width ==Int size(SB))
             orBool size(SB) <=Int Addr
        [simplification]

  // rule #getBytesRange(
  //         #setRange(_M:SparseBytes, Addr:Int, Val:Int, Width:Int),
  //         Addr:Int, Width:Int
  //     )
  //     => Int2Bytes(Width, Val, LE)
  //     requires #setRangeActuallySets(Addr, Val, Width)
  //     [simplification]
endmodule

```