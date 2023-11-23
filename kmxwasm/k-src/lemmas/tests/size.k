module SIZE
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            size (
                SBChunk ( #empty ( 808 ) )
                SBChunk ( #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) ) )
            )
        ) => doneSimplification(5)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            size (
                SBChunk ( #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) ) )
            )
        ) => doneSimplification(813)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
endmodule
