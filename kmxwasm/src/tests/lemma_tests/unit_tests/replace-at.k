module REPLACE-AT
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"1234" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, Int2Bytes ( 4 , A , LE ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, b"123" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, Int2Bytes ( 3 , A , LE ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, Int2Bytes ( 2 , A , LE ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes (
                    Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00\x00" ) ), 1, Int2Bytes ( 2 , A , LE ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAt(
                  SBChunk( #bytes(b"\x00" +Bytes Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00" ) ),
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAt(
                  SBChunk( #bytes(b"\x00\x00" +Bytes Int2Bytes ( 1 , A , LE ) +Bytes b"\x00" ) ),
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00" ) ), 1, b"123" )
            )
            ListItem(
                replaceAt(
                  SBChunk( #bytes(b"\x00\x00" +Bytes Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00" ) ),
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
                replaceAt( SBChunk ( #empty ( 4 ) ), 0, b"1234" )
            )
            ListItem(
                replaceAt(SBChunk ( #empty ( 4 ) ), 0, Int2Bytes ( 4 , A , LE ))
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
                replaceAt( SBChunk ( #empty ( 4 ) ), 1, b"123" )
            )
            ListItem(
                replaceAt( SBChunk ( #empty ( 4 ) ), 1, Int2Bytes ( 3 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"123" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 3 , A , LE ) ) )
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
                replaceAt( SBChunk ( #empty ( 4 ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #empty ( 4 ) ), 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"12" ) )
                  SBChunk ( #empty ( 1 ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
                  SBChunk ( #empty ( 1 ) )
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
                replaceAt( .SparseBytes, 10, b"12" )
            )
            ListItem(
                replaceAt( .SparseBytes, 10, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 10 ) )
                  SBChunk ( #bytes ( b"12" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #empty ( 10 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
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
                replaceAt( .SparseBytes, 0, b"12" )
            )
            ListItem(
                replaceAt( .SparseBytes, 0, Int2Bytes ( 2 , A , LE ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00" ) ), 10, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00" ) ), 10, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" ) )
                  SBChunk ( #empty ( 9 ) )
                  SBChunk ( #bytes ( b"12" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" ) )
                  SBChunk ( #empty ( 9 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00" ) ), 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" ) )
                  SBChunk ( #bytes ( b"12" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
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
                replaceAt( SBChunk ( #bytes ( b"\x00\x00" ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #bytes ( b"\x00\x00" ) ), 1, Int2Bytes ( 2 , A , LE ) )
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


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAt( SBChunk ( #empty ( 1 ) ), 10, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #empty ( 1 ) ), 10, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #empty ( 9 ) )
                  SBChunk ( #bytes ( b"12" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #empty ( 9 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
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
                replaceAt( SBChunk ( #empty ( 1 ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #empty ( 1 ) ), 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"12" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
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
                replaceAt( SBChunk ( #empty ( 2 ) ), 1, b"12" )
            )
            ListItem(
                replaceAt( SBChunk ( #empty ( 2 ) ), 1, Int2Bytes ( 2 , A , LE ) )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"12" ) )
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( Int2Bytes ( 2 , A , LE ) ) )
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
