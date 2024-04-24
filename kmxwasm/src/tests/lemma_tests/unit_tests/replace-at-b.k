module REPLACE-AT-B
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 0, b"1234" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 0, Int2Bytes ( 4 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"1234" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( 4 , A , LE ) ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 0, b"123" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 0, Int2Bytes ( 3 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"123\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( 3, A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x0012\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAtB(
                    Int2Bytes ( 1 , A , LE ) +Bytes b"\x00",
                    SBChunk ( #bytes ( b"\x00\x00" ) ),
                    1, Int2Bytes ( 2 , A , LE )
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x0012\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( 1 , A , LE ) +Bytes Int2Bytes ( 2 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAtB(
                  b"\x00" +Bytes Int2Bytes ( 1 , A , LE ),
                  SBChunk( #bytes(b"\x00\x00" ) ),
                  1, Int2Bytes ( 2 , A , LE )
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x0012\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAtB(
                  b"\x00\x00",
                  SBChunk( #bytes(Int2Bytes ( 1 , A , LE ) +Bytes b"\x00" ) ),
                  1, Int2Bytes ( 2 , A , LE )
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x0012\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #bytes ( b"\x00\x00\x00" ) ), 1, b"123" )
            )
            ListItem(
                replaceAtB(
                  b"\x00\x00",
                  SBChunk( #bytes(Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00" ) ),
                  1, Int2Bytes ( 3 , A , LE )
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00123\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 3 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #empty ( 2 ) ), 0, b"1234" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #empty ( 2 ) ), 0, Int2Bytes ( 4 , A , LE ))
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"1234" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( 4 , A , LE ) ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #empty ( 2 ) ), 1, b"123" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #empty ( 2 ) ), 1, Int2Bytes ( 3 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00123" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 3 , A , LE ) ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #empty ( 2 ) ), 1, b"12" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", SBChunk ( #empty ( 2 ) ), 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x0012\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"0", .SparseBytes, 0, b"12" )
            )
            ListItem(
                replaceAtB( b"0", .SparseBytes, 0, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"12" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB( b"\x00\x00", .SparseBytes, 1, b"12" )
            )
            ListItem(
                replaceAtB( b"\x00\x00", .SparseBytes, 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x0012" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
