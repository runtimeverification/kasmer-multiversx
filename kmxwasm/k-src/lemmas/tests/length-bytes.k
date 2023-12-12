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

endmodule
