module REPLACE-AT
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            replaceAt
              ( SBChunk ( #bytes (
                  Int2Bytes ( 8 , A , LE )
                  +Bytes b"\x00"
                ) )
              , 0
              , Int2Bytes ( 8 , A , LE )
                +Bytes b"\x00"
              )
        ) => doneSimplification(
            (SBChunk ( #bytes ( Int2Bytes ( 8 , A , LE ) +Bytes b"\x00" ) ) .SparseBytes):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
