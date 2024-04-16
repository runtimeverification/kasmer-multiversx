```k
module REPLACE-AT-LEMMAS-BASIC
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    syntax SBSetFunction ::= replaceAt(value:Bytes)
endmodule

module REPLACE-AT-LEMMAS
    imports REPLACE-AT-LEMMAS-BASIC

    rule functionSparseBytesWellDefined(
            replaceAt(_Val:Bytes), _SBSize:Int, Addr:Int, Width:Int
        )
        => 0 <=Int Addr andBool 0 <Int Width
    rule updateSparseBytesSize(
            replaceAt(Val:Bytes), SBSize:Int, Addr:Int, Width:Int
        )
        => maxInt(SBSize +Int lengthBytes(Val), Addr +Int Width)
        requires functionSparseBytesWellDefined(
            replaceAt(Val:Bytes), SBSize, Addr, Width
        )
    rule startOffset(replaceAt(_:Bytes)) => 0
    rule functionCommutesAtStart(replaceAt(_:Bytes)) => true
    rule getReplacementSparseBytes(
            replaceAt(Value:Bytes), SB:SparseBytes, Addr:Int, Width:Int
        )
        => SBChunk(#bytes(Value))
        requires functionSparseBytesWellDefined(
                replaceAt(Value:Bytes), size(SB), Addr, Width
            )
          andBool Width ==Int lengthBytes(Value)

    rule replaceAt(SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAt(Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAt(Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(SB)]
    rule replaceAt(SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAt(Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAt(Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(Addr)]
    rule replaceAt(SB:SparseBytes, Addr:Int, Value:Bytes)
        => updateSparseBytes(
              replaceAt(Value), SB, Addr, lengthBytes(Value)
          )
        requires functionSparseBytesWellDefined(
              replaceAt(Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, symbolic(Value)]

    rule updateSparseBytes(
              replaceAt(Value), SB, Addr, lengthBytes(Value)
          )
        => replaceAt(SB, Addr, Value)
        requires functionSparseBytesWellDefined(
              replaceAt(Value), size(SB), Addr, lengthBytes(Value)
          )
      [simplification, concrete]
endmodule

```