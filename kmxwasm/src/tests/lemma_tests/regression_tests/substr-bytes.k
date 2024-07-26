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

    claim
      <k>
        runSimplification(
            substrBytesTotal(
                Int2Bytes ( 8 , _ , LE )
                    +Bytes b"\x00",
                0:Int,
                0:Int
            )
        ) => doneSimplification(b"")
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            definedSubstrBytes
              ( Int2Bytes ( 8 , _ , LE )
                +Bytes b"\x00"
              , 9
              , 9
              )
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            definedSubstrBytes
              ( Int2Bytes ( 8 , _ , LE )
                +Bytes b"\x00"
              , 10
              , 10
              )
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            substrBytesTotal
              ( b"\x00\x00\x00\x07\x00\x00\x00\x00\x00\x00\x00\x00recipient address not setargument decode error (): wrong number of argumentssync resultinput too long\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00storage decode error: bad array lengthtoo few argumentsaddowner___________________________adder___________________________adderAddressownerAddress"
              , 4
              , ((-1) *Int (((log2IntTotal ( (ARG_0:Int) +Int (5) )) +Int (8)) divIntTotal (8))) +Int (12)
              )
        ) => doneSimplification(
            substrBytesTotal
                ( b"\x00\x00\x00\x00\x00\x00\x00\x00"
                , 0
                , ((-1) *Int (((log2IntTotal ( (ARG_0:Int) +Int (5) )) +Int (8)) divIntTotal (8))) +Int (8)
                )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int ARG_0 andBool ARG_0:Int <Int 100

endmodule
