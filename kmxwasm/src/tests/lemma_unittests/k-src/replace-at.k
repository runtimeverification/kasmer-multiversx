module REPLACE-AT
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            updateSparseBytes
              ( replaceAt
                ( ... value: b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00"
                  +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) <<IntTotal (24) , LE )
                  +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE )
                  +Bytes b"\x00\x00\x00\x00\x01"
                  +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                  +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                  +Bytes b"\x00"
                )
              , SBChunk ( #bytes
                  ( b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00"
                    +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) <<IntTotal (24) , LE )
                    +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE )
                    +Bytes b"\x00\x00\x00\x00\x01"
                    +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) 
                    +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                    +Bytes b"\x00"
                  )
                )
                .SparseBytes
              , 0
              , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114)
              )
        ) => doneSimplification(
            ( SBChunk ( #bytes
                ( b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00"
                  +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) <<IntTotal (24) , LE )
                  +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE )
                  +Bytes b"\x00\x00\x00\x00\x01"
                  +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) 
                  +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                  +Bytes b"\x00"
                )
              )
              .SparseBytes
            ):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            replaceAt
              ( SBChunk ( #bytes (
                  Int2Bytes ( 8 , A , LE )
                  +Bytes b"\x00"
                ) )
              , 0
              , Int2Bytes ( 8 , A , LE )
                +Bytes b"\x00"
              )
        ) => doneSimplification(
            (SBChunk ( #bytes ( Int2Bytes ( 8 , A , LE ) +Bytes b"\x00" ) ) .SparseBytes):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            replaceAt
              ( merge ( SBChunk ( #bytes ( b"J\xff\xff\xff\x00\x00\x00\rFIRST-123456" ) ),
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                merge ( SBChunk ( #bytes ( b"\x00" ) ) ,
                concat
                  ( updateSparseBytes
                    ( replaceAt ( ... value: Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE ) )
                    , updateSparseBytes ( setRange ( ... value: ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) ) , concat ( updateSparseBytes ( setRange ( ... value: 0 ) , SBChunk ( #bytes ( Int2Bytes ( ((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8) , (ARG_0:Int) +Int (-1000) , BE ) ) )  .SparseBytes , 0 , 1 ) , SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8))) +Int (9974) ) )  .SparseBytes ) , 1 , 1 )
                    , 2 , ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)
                    )
                  , SBChunk ( #bytes ( b"\x04\x00\x00\x00\x01" ) )
                    SBChunk ( #empty ( 7 ) )
                    SBChunk ( #bytes ( b"\x01" ) )
                    .SparseBytes
                  ) ) ) ) ) ) ) ) ) ) ) )
              , 8 , b"SECOND-123456"
              )
        ) => doneSimplification(
            ( merge
              ( SBChunk ( #bytes ( b"J\xff\xff\xff\x00\x00\x00\rSECOND-123456\x00\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              , concat
                ( updateSparseBytes
                  ( replaceAt ( ... value: Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE ) )
                  , updateSparseBytes ( setRange ( ... value: ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) ) , concat ( updateSparseBytes ( setRange ( ... value: 0 ) , SBChunk ( #bytes ( Int2Bytes ( ((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8) , (ARG_0:Int) +Int (-1000) , BE ) ) )  .SparseBytes , 0 , 1 ) , SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8))) +Int (9974) ) )  .SparseBytes ) , 1 , 1 )
                  , 2 , ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)
                  )
                , SBChunk ( #bytes ( b"\x04\x00\x00\x00\x01" ) )
                  SBChunk ( #empty ( 7 ) )
                  SBChunk ( #bytes ( b"\x01" ) )
                  .SparseBytes
                )
              )
            ):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
