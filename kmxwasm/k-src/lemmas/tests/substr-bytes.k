module SUBSTR-BYTES
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            substrBytes(Int2Bytes(8, X:Int, LE), 7:Int, 8:Int)
        ) => doneSimplification(Int2Bytes(1, (X >>Int (7 *Int 8)), LE))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            substrBytes(b"1234" +Bytes Int2Bytes(1, _X:Int, LE), 1:Int, 2:Int)
        ) => doneSimplification(b"2")
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            substrBytes(b"1234" +Bytes Int2Bytes(1, X:Int, LE), 4:Int, 5:Int)
        ) => doneSimplification(Int2Bytes(1, X, LE))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            substrBytes(b"1234" +Bytes Int2Bytes(1, X:Int, LE), 3:Int, 5:Int)
        ) => doneSimplification(b"4" +Bytes Int2Bytes(1, X, LE))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
endmodule
