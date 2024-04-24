module REPLACE-AT-REPLACE-AT
    imports MX-WASM-LEMMA-TESTS
    imports REPLACE-AT-B-LEMMAS-BASIC


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"1234" ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    replaceAt( A, 0, b"1234" ),
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"12" ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    replaceAt( A, 0, b"12" ),
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    replaceAt( A, 1, b"12" ),
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 2, b"12" ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    replaceAt( A, 2, b"12" ),
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"ab" ),
                    0, Int2Bytes(2, 515, LE)
                )
            )
            // TODO: This test is broken for two reasons:
            // 1. Unevaluated #Ceil ( #splitReplaceAt ( #setRange ( A , 1 , 258 , 2 ) , 0 , b"\x03\x02" , 1 ) )
            // 2. Unevaluated #splitReplaceAt ( #setRange ( A , 1 , 258 , 2 ) , 0 , b"\x03\x02" , 1 ) )
            // ListItem(
            //     replaceAt(
            //         replaceAt( A, 1, b"ab" ),
            //         0, Int2Bytes(2, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x03\x02b\x00" ) )
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" ),
                    2, Int2Bytes(2, 515, LE)
                )
            )
            // ListItem(
            //     replaceAt(
            //         replaceAt( A, 1, b"12" ),
            //         2, Int2Bytes(2, 515, LE)
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
            //     replaceAt(
            //         replaceAt( A, 1, b"1" ),
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
                    replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"1234" ),
                    1, Int2Bytes(2, 515, LE)
                )
            )
            // ListItem(
            //     replaceAt(
            //         replaceAt( A, 0, b"1234" ),
            //         1, Int2Bytes(2, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"1\x03\x024" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            // TODO: The symbolic part of this test is not working, it probably
            // does not matter anyway.
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
                    replaceAt
                      ( SBChunk( #bytes( Int2Bytes(2, 1, LE) ) )
                        SBChunk( #empty(10 -Int 2) )
                        SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                      , 0, b"1234"
                      ),
                    10, Int2Bytes(4, 515, LE)
                )
            )
            ListItem(
                replaceAt(
                    replaceAt
                      ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
                        SBChunk( #empty(100 -Int A) )
                        SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                      , 0, Int2Bytes(B, 1, LE)
                      ),
                    100, Int2Bytes(4, 515, LE)
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"1234\x00\x00\x00\x00\x00\x00" ) )
                  SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                concat
                  ( replaceAt
                      ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
                        SBChunk( #empty(100 -Int A) )
                      , 0, Int2Bytes(B, 1, LE)
                      )
                  , SBChunk( #bytes( Int2Bytes(4, 515, LE) ) )
                  )
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 100
          andBool 0 <Int B andBool B <Int 100

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt(
                    #setRange(
                        replaceAt
                          ( SBChunk( #bytes( Int2Bytes(4, 1, LE) ) )
                            SBChunk( #empty(100 -Int 4) )
                            SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                          , 0, b"12"
                          ),
                        0, 258, 3
                    ),
                    100, Int2Bytes(4, 515, LE)
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            ListItem(
                replaceAt(
                    #setRange(
                        replaceAt
                          ( SBChunk( #bytes( Int2Bytes(A, 1, LE) ) )
                            SBChunk( #empty(100 -Int A) )
                            SBChunk( #bytes ( b"\x00\x00\x00\x00" ) )
                          , 0, Int2Bytes(B, 1, LE)
                          ),
                        0, 258, C
                    ),
                    100, Int2Bytes(4, 515, LE)
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01\x00\x00" ) )
                  SBChunk ( #empty ( 96 ) )
                  SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( C , 258 , LE ) ) )
                  replaceAt
                    ( substrSparseBytes
                      ( replaceAtB
                        ( Int2Bytes ( A , 1 , LE )
                        , SBChunk ( #empty ( -1 *Int A +Int 100 ) )
                          SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
                          .SparseBytes
                        , 0 , Int2Bytes ( B , 1 , LE )
                        )
                      , C , 104
                      )
                    , -1 *Int C +Int 100, b"\x03\x02\x00\x00"
                    )
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <=Int 100
          andBool 0 <Int B andBool B <=Int 100
          andBool 0 <Int C andBool C <=Int 100

endmodule
