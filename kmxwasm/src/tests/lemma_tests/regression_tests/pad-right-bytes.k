module PAD-RIGHT-BYTES
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            padRightBytes(Int2Bytes(ILen:Int, Value:Int, LE:Endianness), PLen:Int, _PValue:Int)
        ) => doneSimplification(
            Int2Bytes(ILen:Int, Value:Int, LE:Endianness)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires PLen <=Int ILen

endmodule
