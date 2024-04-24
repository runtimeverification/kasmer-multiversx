```k
module SUBSTR-SPARSE-BYTES-LEMMAS-BASIC
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    imports GET-BYTES-RANGE-LEMMAS-BASIC
endmodule

module SUBSTR-SPARSE-BYTES-LEMMAS
    imports SPARSE-BYTES-LEMMAS-BASIC
    imports SUBSTR-SPARSE-BYTES-LEMMAS-BASIC

    rule functionCommutesAtStart(substr) => true

    rule substrSparseBytes(SBI:SBItemChunk SB, Start:Int, End:Int)
        => extractSparseBytes(substr, SBI SB, Start, End -Int Start)
        requires 0 <Int size(SB)
            andBool 0 <=Int Start andBool Start <=Int End
        [simplification]
    rule substrSparseBytes(concat(SB1, SB2), Start:Int, End:Int)
        => extractSparseBytes(substr, concat(SB1, SB2), Start, End -Int Start)
        requires 0 <=Int Start andBool Start <=Int End
        [simplification]
    rule substrSparseBytes(merge(SB1, SB2), Start:Int, End:Int)
        => extractSparseBytes(substr, merge(SB1, SB2), Start, End -Int Start)
        requires 0 <=Int Start andBool Start <=Int End
        [simplification]
    rule substrSparseBytes(extractSparseBytes(F, SB, A, W), Start:Int, End:Int)
        => extractSparseBytes(substr, extractSparseBytes(F, SB, A, W), Start, End -Int Start)
        requires 0 <=Int Start andBool Start <=Int End
        [simplification]
    rule substrSparseBytes(substrSparseBytes(SB, A, W), Start:Int, End:Int)
        => extractSparseBytes(substr, substrSparseBytes(SB, A, W), Start, End -Int Start)
        requires 0 <=Int Start andBool Start <=Int End
        [simplification]

    rule extractSparseBytes(substr, SB, Start, Width)
        => substrSparseBytes(SB, Start, Start +Int Width)
        // requires size(SB) <=Int Start +Int Width
        [simplification, concrete]

    rule extractSparseBytes(substr, SB, 0, Width)
        => SB
        requires size(SB) <=Int Width
        [simplification]

    rule extractSparseBytes(
            substr, SBChunk(#bytes(Int2Bytes(Size:Int, Val:Int, LE))),
            Start:Int, Width:Int
        )
        => extractSparseBytes(
            substr, SBChunk(#bytes(Int2Bytes(Size -Int Start, Val >>Int (8 *Int Start), LE))),
            0, Width
        )
        requires 0 <Int Start andBool Start <Int Size
        [simplification]
    rule extractSparseBytes(
            substr, SBChunk(#bytes(Int2Bytes(Size:Int, Val:Int, LE))),
            0, Width:Int
        )
        => extractSparseBytes(
            substr, SBChunk(#bytes(Int2Bytes(Width, Val &Int ((1 <<Int (8 *Int Width)) -Int 1), LE))),
            0, Width
        )
        requires 0 <Int Width andBool Width <Int Size
        [simplification]

endmodule

```