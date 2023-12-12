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

endmodule
