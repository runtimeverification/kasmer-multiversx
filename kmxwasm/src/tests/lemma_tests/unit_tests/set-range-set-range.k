module SET-RANGE-SET-RANGE
    imports MX-WASM-LEMMA-TESTS


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 4 ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    #setRange( A, 0, 258, 4 ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) ) )
            ListItem( #setRange( A, 0, 515, 4 ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 2 ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    #setRange( A, 0, 258, 2 ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) ) )
            ListItem( #setRange( A, 0, 515, 4 ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    #setRange( A, 1, 258, 2 ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) ) )
            ListItem( #setRange( A, 0, 515, 4 ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 2, 258, 2 ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    #setRange( A, 2, 258, 2 ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) ) )
            ListItem( #setRange( A, 0, 515, 4 ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 ),
                    0, 515, 2
                )
            )
            // TODO: This test works, but the Haskell backend can't figure that out
            // because list unification is broken.
            //
            // ListItem(
            //     #setRange(
            //         #setRange( A, 1, 258, 2 ),
            //         0, 515, 2
            //     )
            // )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x03\x02\x01\x00" ) ) )
            // ListItem(
            //   ( SBChunk ( #bytes ( b"\x03" ) )
            //     SBChunk ( #bytes ( b"\x02" ) )
            //     // TODO: this is fairly bad. Either we should produce a
            //     // better result, or perhaps we should not handle this input.
            //     substrSparseBytes
            //       ( substrSparseBytes
            //         ( #setRange ( A , 1 , 258 , 2 )
            //         , 1
            //         , maxInt ( 3 , size ( A ) )
            //         )
            //       , 1
            //       , maxInt ( 3 , size ( A ) ) +Int -1
            //       )
            //   ):SparseBytes:KItem
            // )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 ),
                    2, 515, 2
                )
            )
            ListItem(
                #setRange(
                    #setRange( A, 1, 258, 2 ),
                    2, 515, 2
                )
            )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x00\x02\x03\x02" ) ) )
            ListItem(
                #setRange(
                    #setRange( A, 1, 2, 1 ),
                    2, 515, 2
                )
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 4 ),
                    1, 515, 2
                )
            )
            ListItem(
                #setRange(
                    #setRange( A, 0, 258, 4 ),
                    1, 515, 2
                )
            )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x02\x03\x02\x00" ) ) )
            // TODO: This result seems broken, especially the conflict between
            // "1 , 1 , 2" and "1 , 515 , 2". I'm not sure we need to handle
            // this, though.
            ListItem(
                #setRange
                  ( #setRange
                    ( #setRange
                      ( #setRange ( A , 0 , 2 , 1 )
                      , 1 , 1 , 2
                      )
                    , 3 , 0 , 1
                    )
                  , 1 , 515 , 2
                  )
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    #setRange
                      ( SBChunk( #bytes( Int2Bytes(2, 1, LE) ) )
                        SBChunk( #empty(10 -Int 2) )
                        SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                      , 0, 258, 4
                      ),
                    10, 515, 4
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            // ListItem(
            //     #setRange(
            //         #setRange
            //           ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //             SBChunk( #empty(100 -Int A) )
            //             SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //           , 0, 258, B
            //           ),
            //         100, 515, 4
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
                #setRange(
                    #setRange(
                        #setRange
                          ( SBChunk( #bytes( Int2Bytes(4, 1, LE) ) )
                            SBChunk( #empty(100 -Int 4) )
                            SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                          , 0, 258, 2
                          ),
                        0, 258, 3
                    ),
                    100, 515, 4
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            // ListItem(
            //     #setRange(
            //         #setRange(
            //             #setRange
            //               ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //                 SBChunk( #empty(100 -Int A) )
            //                 SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //               , 0, 258, B
            //               ),
            //             0, 258, C
            //         ),
            //         100, 515, 4
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
