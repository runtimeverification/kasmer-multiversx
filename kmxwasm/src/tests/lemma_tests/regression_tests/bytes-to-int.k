module BYTES-TO-INT
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            Bytes2Int
              ( padRightBytesTotal
                ( substrBytesTotal
                  ( Int2Bytes
                    ( 8
                    , ((ARG_0:Int) <<IntTotal (56)) |Int (((ARG_0:Int) <<IntTotal (40)) &Int (71776119061217280))
                    , LE
                    )
                  , 7
                  , 8
                  )
                , 1
                , 0
                )
              , BE
              , Unsigned
              )
          ) => doneSimplification( Bytes2Int ( Int2Bytes ( 1 , ARG_0 , LE ) , BE , Unsigned ) )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            Bytes2Int 
              ( substrBytesTotal
                ( replaceAtBytesTotal
                  ( ... dest: b"\x00\x00\x00\x00\x00\x00\x00\x00"
                  , index: 0
                  , src: Int2Bytes
                    ( 4
                    , ( (((ARG_0:Int) &Int (255)) <<IntTotal (24))
                      |Int (((ARG_0:Int) &Int (65280)) <<IntTotal (8))
                      )
                      |Int
                      ( (((ARG_0:Int) >>IntTotal (8)) &Int (65280))
                      |Int ((ARG_0:Int) >>IntTotal (24))
                      )
                    , LE
                    )
                  )
                , 0
                , 1
                )
              , LE
              , Unsigned
              )
        ) => doneSimplification( (ARG_0 >>IntTotal 24) &Int 255 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int ARG_0
endmodule
