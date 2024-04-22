module REPLACE-AT-SET-RANGE
    imports MX-WASM-LEMMA-TESTS


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 4 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    #setRange( A, 0, 258, 4 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem( replaceAt( A, 0, Int2Bytes(4, 515, LE) ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    #setRange( A, 0, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem( replaceAt( A, 0, Int2Bytes(4, 515, LE) ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    #setRange( A, 1, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem( replaceAt( A, 0, Int2Bytes(4, 515, LE) ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 2, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    #setRange( A, 2, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem( replaceAt( A, 0, Int2Bytes(4, 515, LE) ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 ),
                    0, Int2Bytes(2, 515, LE)
                )
            )
            // TODO: This test is broken for two reasons:
            // 1. Unevaluated #Ceil ( #splitReplaceAt ( #setRange ( A , 1 , 258 , 2 ) , 0 , b"\x03\x02" , 1 ) )
            // 2. Unevaluated #splitReplaceAt ( #setRange ( A , 1 , 258 , 2 ) , 0 , b"\x03\x02" , 1 ) )
            // ListItem(
            //     replaceAt(
            //         #setRange( A, 1, 258, 2 ),
            //         0, Int2Bytes(2, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x01\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            // ListItem(
            // )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 ),
                    2, Int2Bytes(2, 515, LE)
                )
            )
            // ListItem(
            //     replaceAt(
            //         #setRange( A, 1, 258, 2 ),
            //         2, Int2Bytes(2, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x03\x02" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            // TODO: The symbolic part of this test is not working, it probably
            // does not matter anyway.
            // ListItem(
            //     replaceAt(
            //         #setRange( A, 1, 2, 1 ),
            //         2, Int2Bytes(2, 515, LE)
            //     )
            // )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 4 ),
                    1, Int2Bytes(2, 515, LE)
                )
            )
            // ListItem(
            //     replaceAt(
            //         #setRange( A, 0, 258, 4 ),
            //         1, Int2Bytes(2, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x03\x02\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            // TODO: The symbolic part of this test is not working, it probably
            // does not matter anyway.
            // ListItem(
            //     concat(
            //       #setRange( A, 0, 258, 1 ),
            //       concat(
            //         replaceAt
            //           ( #setRange( A, 0, 258, 4 )
            //           , 1 , Int2Bytes(2, 515, LE)
            //           ),
            //         #setRange( A, 4, 0, 1 ),
            //       )
            //     )
            // )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange
                      ( SBChunk( #bytes( Int2Bytes(2, 1, LE) ) )
                        SBChunk( #empty(10 -Int 2) )
                        SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                      , 0, 258, 4
                      ),
                    10, Int2Bytes(4, 515, LE)
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            // ListItem(
            //     replaceAt(
            //         #setRange
            //           ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //             SBChunk( #empty(100 -Int A) )
            //             SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //           , 0, 258, B
            //           ),
            //         100, Int2Bytes(4, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00" ) )
                  SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                ):SparseBytes:KItem
            )
            // ListItem(
            //     ( #setRange
            //         ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //           SBChunk( #empty(100 -Int A) )
            //         , 0, 258, B
            //         )
            //       SBChunk( #bytes ( b"\x03\x02\x00\x00" ) )
            //     ):SparseBytes:KItem
            // )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <=Int 100
          andBool 0 <Int B andBool B <=Int 100

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange(
                        #setRange
                          ( SBChunk( #bytes( Int2Bytes(4, 1, LE) ) )
                            SBChunk( #empty(100 -Int 4) )
                            SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                          , 0, 258, 2
                          ),
                        0, 258, 3
                    ),
                    100, Int2Bytes(4, 515, LE)
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            // ListItem(
            //     replaceAt(
            //         #setRange(
            //             #setRange
            //               ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //                 SBChunk( #empty(100 -Int A) )
            //                 SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //               , 0, 258, B
            //               ),
            //             0, 258, C
            //         ),
            //         100, Int2Bytes(4, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01\x00\x00" ) )
                  SBChunk ( #empty ( 96 ) )
                  SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                ):SparseBytes:KItem
            )
            // ListItem(
            //     ( #setRange(
            //           #setRange
            //             ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //               SBChunk( #empty(100 -Int A) )
            //               SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //             , 0, 258, B
            //             ),
            //           0, 258, C
            //       )
            //       SBChunk( #bytes ( b"\x03\x02\x00\x00" ) )
            //     ):SparseBytes:KItem
            // )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <=Int 100
          andBool 0 <Int B andBool B <=Int 100
          andBool 0 <Int C andBool C <=Int 100

endmodule
