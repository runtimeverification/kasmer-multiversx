module REPLACE-AT-BYTES
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            replaceAtBytesTotal
              ( ... dest: b"12345678"
              , index: 0
              , src: Int2Bytes( 4, ARG_0:Int, LE )
              )
        ) => doneSimplification( Int2Bytes( 4, ARG_0:Int, LE ) +Bytes b"5678")
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int ARG_0
endmodule
