module SET-RANGE-REPLACE-AT
    imports MX-WASM-LEMMA-TESTS


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange(
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"1234" ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    replaceAt( A, 0, b"1234" ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"12" ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    replaceAt( A, 0, b"12" ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    replaceAt( A, 1, b"12" ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 2, b"12" ),
                    0, 515, 4
                )
            )
            ListItem(
                #setRange(
                    replaceAt( A, 2, b"12" ),
                    0, 515, 4
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"ab" ),
                    0, 515, 2
                )
            )
            // TODO: This test works, but the Haskell backend can't figure that out
            // because list unification is broken.
            //
            // ListItem(
            //     #setRange(
            //         replaceAt( A, 1, b"ab" ),
            //         0, 515, 2
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02b\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            // ListItem(
            //   ( SBChunk ( #bytes ( b"\x03" ) )
            //     SBChunk ( #bytes ( b"\x02" ) )
            //     // TODO: this is fairly bad. Either we should produce a
            //     // better result, or perhaps we should not handle this input.
            //     substrSparseBytes
            //       ( substrSparseBytes
            //         ( replaceAt ( A , 1 , b"ab" )
            //         , 1
            //         , maxInt ( size ( A ), 3 )
            //         )
            //       , 1
            //       , maxInt ( size ( A ), 3 ) +Int -1
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" ),
                    2, 515, 2
                )
            )
            // ListItem(
            //     #setRange(
            //         replaceAt( A, 1, b"12" ),
            //         2, 515, 2
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x001\x03\x02" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            // TODO: The symbolic part of this test is not working, it probably
            // does not matter anyway.
            // ListItem(
            //     #setRange(
            //         replaceAt( A, 1, b"1" ),
            //         2, 515, 2
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
                #setRange(
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"1234" ),
                    1, 515, 2
                )
            )
            // TODO: This is currently broken for two reasons:
            // 1. The symbolic result is #setRange ( #splitReplaceAt ( A , 0 , b"1234" , 1 ) , 1 , 515 , 2 ) ),
            //    and we should not have unevaluated #splitReplaceAt
            // 2. The result contains a #Ceil ( #splitReplaceAt ( A , 0 , b"1234" , 1 ) )
            //    which should not stay unevaluated.
            // ListItem(
            //     #setRange(
            //         replaceAt( A, 0, b"1234" ),
            //         1, 515, 2
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"1\x03\x024" ) )
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
                #setRange(
                    replaceAt
                      ( SBChunk( #bytes( Int2Bytes(2, 1, LE) ) )
                        SBChunk( #empty(10 -Int 2) )
                        SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                      , 0, b"1234"
                      ),
                    10, 515, 4
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            // ListItem(
            //     #setRange(
            //         replaceAt
            //           ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //             SBChunk( #empty(100 -Int A) )
            //             SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //           , 0, Int2Bytes(B, 1, LE)
            //           ),
            //         100, 515, 4
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"1234\x00\x00\x00\x00\x00\x00" ) )
                  SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                ):SparseBytes:KItem
            )
            // ListItem(
            //     ( replaceAt
            //         ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //           SBChunk( #empty(100 -Int A) )
            //         , 0, Int2Bytes(B, 1, LE)
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
                        replaceAt
                          ( SBChunk( #bytes( Int2Bytes(4, 1, LE) ) )
                            SBChunk( #empty(100 -Int 4) )
                            SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                          , 0, b"12"
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
            //             replaceAt
            //               ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //                 SBChunk( #empty(100 -Int A) )
            //                 SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //               , 0, Int2Bytes(B, 1, LE)
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
            //           replaceAt
            //             ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
            //               SBChunk( #empty(100 -Int A) )
            //               SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
            //             , 0, Int2Bytes(B, 1, LE)
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
