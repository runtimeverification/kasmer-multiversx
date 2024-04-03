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

    claim
      <k>
        runSimplification(
            lengthBytes(
                b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
                +Bytes
                  Int2Bytes
                    ( 1
                    , ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)
                    , LE
                    )
                +Bytes Int2Bytes
                  ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE )
                +Bytes b"\x00\x00\x00\x00\x01"
                +Bytes Int2Bytes
                  ( 8
                  , int64encoding
                    ( ... value: (ARG_1:Int) +Int (ARG_2:Int), b8pos: 0 , b7pos: 1 , b6pos: 2
                    , b5pos: 3 , b4pos: 4 , b3pos: 5, b2pos: 6 , b1pos: 7
                    )
                  , LE
                  )
                +Bytes Int2Bytes
                  ( 8
                  , int64encoding
                    ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (_ARG_3:Int)) +Int (A_RG_4:Int)
                    , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5
                    , b2pos: 6 , b1pos: 7
                    )
                  , LE
                  )
            )
        ) => doneSimplification( ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int 113 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
