module GET-RANGE
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            #getRange (
                SBChunk (
                    #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , ARG_0:Int , LE ) )
                )
                , 0 , 1
            )
        ) => doneSimplification(4)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            #getRange (
                SBChunk ( #empty ( 808 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) ) )
                , 12452 , 4
            )
        ) => doneSimplification(0)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
endmodule
