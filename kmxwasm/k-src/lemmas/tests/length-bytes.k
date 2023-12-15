module LENGTH-BYTES
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            lengthBytes(substrBytesTotal(B, 7, 8))
        ) => doneSimplification(1)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 7 <Int lengthBytes(B)

    claim
      <k>
        runSimplification(
            lengthBytes(
                replaceAtBytesTotal
                  ( ... dest: b"\x00\x00\x00\x00\x00\x00\x00\x00"
                  , index: 0
                  , src: Int2Bytes ( 4, _:Int, LE )
                  )
            )
        ) => doneSimplification(8)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
