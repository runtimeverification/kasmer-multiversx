```k
module REPLACE-AT-B-LEMMAS-BASIC
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    syntax SBSetFunction ::= replaceAtB(prefix:Bytes, value:Bytes)
endmodule

module REPLACE-AT-B-LEMMAS
    imports REPLACE-AT-B-LEMMAS-BASIC

    rule functionSparseBytesWellDefined(
            replaceAtB(_Prefix:Bytes, _Val:Bytes), _SBSize:Int, Addr:Int, Width:Int
        )
        => 0 <=Int Addr andBool 0 <Int Width
    rule updateSparseBytesSize(
            replaceAtB(Prefix:Bytes, Val:Bytes), SBSize:Int, Addr:Int, Width:Int
        )
        => maxInt(lengthBytes(Prefix) +Int SBSize, Addr +Int Width)
        requires functionSparseBytesWellDefined(
            replaceAtB(Prefix:Bytes, Val:Bytes), SBSize, Addr, Width
        )
    rule startOffset(replaceAtB(Prefix:Bytes, _Val:Bytes)) => lengthBytes(Prefix)
    rule functionCommutesAtStart(replaceAtB(_:Bytes, _:Bytes)) => false
    rule getReplacementSparseBytes(
            replaceAtB(Prefix:Bytes, Value:Bytes), SB:SparseBytes, Addr:Int, Width:Int
        )
        => SBChunk(#bytes(Value))
        requires functionSparseBytesWellDefined(
                replaceAtB(Prefix, Value), size(SB), Addr, Width
            )
          andBool Width ==Int lengthBytes(Value)

    rule replaceAtB(Prefix:Bytes, SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAtB(Prefix, Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAtB(Prefix, Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(SB)]
    rule replaceAtB(Prefix:Bytes, SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAtB(Prefix, Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAtB(Prefix, Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(Prefix)]
    rule replaceAtB(Prefix:Bytes, SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAtB(Prefix, Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAtB(Prefix, Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(Addr)]
    rule replaceAtB(Prefix:Bytes, SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAtB(Prefix, Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAtB(Prefix, Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(Value)]
endmodule
