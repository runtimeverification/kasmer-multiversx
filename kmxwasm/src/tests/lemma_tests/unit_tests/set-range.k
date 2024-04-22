module SET-RANGE
    imports MX-WASM-LEMMA-TESTS
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    imports SET-RANGE-LEMMAS-BASIC

    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 4 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, A, 4 )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01\x00\x00" ) )
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
      requires 0 <=Int A

    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, 258, 3 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 0, A, 3 )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( Int2Bytes ( 3 , A , LE ) +Bytes b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A

    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, A, 2 )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x01\x00" ) )
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
      requires 0 <=Int A

    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes (
                    Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00\x00" ) ), 1, A, 2 )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x01\x00" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange(
                  SBChunk( #bytes(b"\x00" +Bytes Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00" ) ),
                  1, A, 2
                )
            )
        ) => doneSimplification(
            // TODO: It is invalid for these two to have different
            // constructor-based representations.
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x01\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) ) )
                  SBChunk ( #bytes ( b"\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange(
                  SBChunk( #bytes(b"\x00\x00" +Bytes Int2Bytes ( 1 , A , LE ) +Bytes b"\x00" ) ),
                  1, A, 2
                )
            )
        ) => doneSimplification(
            // TODO: It is invalid for these two to have different
            // constructor-based representations.
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x01\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 2 , A , LE ) ) )
                  SBChunk ( #bytes ( b"\x00" ) )
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00" ) ), 1, 258, 3 )
            )
            ListItem(
                #setRange(
                  SBChunk( #bytes(b"\x00\x00" +Bytes Int2Bytes ( 1 , A , LE ) +Bytes b"\x00\x00" ) ),
                  1, A, 3
                )
            )
        ) => doneSimplification(
            // TODO: It is invalid for these two to have different
            // constructor-based representations.
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x01\x00\x00" ) )
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" +Bytes Int2Bytes ( 3 , A , LE ) ) )
                  SBChunk ( #bytes ( b"\x00" ) )
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #empty ( 4 ) ), 0, 258, 4 )
            )
            ListItem(
                #setRange(SBChunk ( #empty ( 4 ) ), 0, A, 4)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01\x00\x00" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #empty ( 4 ) ), 1, 258, 3 )
            )
            ListItem(
                #setRange( SBChunk ( #empty ( 4 ) ), 1, A, 3)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"\x02\x01\x00" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #empty ( 4 ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #empty ( 4 ) ), 1, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( .SparseBytes, 10, 258, 2 )
            )
            ListItem(
                #setRange( .SparseBytes, 10, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 10 ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( .SparseBytes, 0, 258, 2 )
            )
            ListItem(
                #setRange( .SparseBytes, 0, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00" ) ), 10, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00" ) ), 10, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" ) )
                  SBChunk ( #empty ( 9 ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00" ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00" ) ), 1, A, 2)
            )
        ) => doneSimplification(
            // TODO: It is invalid for these two to have different
            // constructor-based representations.
            ListItem(
                ( SBChunk ( #bytes ( b"\x00" ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00" ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #bytes ( b"\x00\x00" ) ), 1, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #bytes ( b"\x00\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #empty ( 1 ) ), 10, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #empty ( 1 ) ), 10, A, 2)
            )
        ) => doneSimplification(
            // TODO: It is invalid for these two to have different
            // constructor-based representations.
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #empty ( 9 ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #empty ( 1 ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #empty ( 1 ) ), 1, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A


    claim
      <k>
        runSimplification(
            ListItem(
                #setRange( SBChunk ( #empty ( 2 ) ), 1, 258, 2 )
            )
            ListItem(
                #setRange( SBChunk ( #empty ( 2 ) ), 1, A, 2)
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk ( #empty ( 1 ) )
                  SBChunk ( #bytes ( b"\x02\x01" ) )
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
      requires 0 <=Int A

endmodule
