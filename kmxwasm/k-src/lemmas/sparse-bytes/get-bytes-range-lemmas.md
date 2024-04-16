```k
module GET-BYTES-RANGE-LEMMAS-BASIC
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    syntax SBGetFunction ::= "getBytesRange"
endmodule

module GET-BYTES-RANGE-LEMMAS  [symbolic]
    imports GET-BYTES-RANGE-LEMMAS-BASIC

    rule functionSparseBytesWellDefined(
            getBytesRange, _SbSize:Int, Start:Int, Width:Int
        )
        => 0 <Int Width andBool 0 <=Int Start
    rule functionCommutesAtStart(getBytesRange) => true

    rule #getBytesRange(SB, Addr:Int, Width:Int)
        => unwrap(extractSparseBytes(getBytesRange, SB, Addr, Width))
        requires (0 <Int Addr orBool Addr +Int Width =/=Int size(SB))
             andBool Addr <Int size(SB)
             andBool functionSparseBytesWellDefined(getBytesRange, size(SB), Addr, Width)
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