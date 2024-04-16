```k

module GET-RANGE-LEMMAS-BASIC
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    imports GET-BYTES-RANGE-LEMMAS-BASIC
endmodule

module GET-RANGE-LEMMAS
    imports GET-RANGE-LEMMAS-BASIC

    rule #getRange(SB, Addr:Int, Width:Int)
        => Bytes2Int(unwrap(extractSparseBytes(getBytesRange, SB, Addr, Width)), LE, Unsigned)
        requires Addr <Int size(SB)
             andBool functionSparseBytesWellDefined(getBytesRange, size(SB), Addr, Width)
        [simplification]

endmodule
```