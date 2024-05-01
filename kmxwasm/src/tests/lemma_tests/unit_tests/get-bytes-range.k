module GET-BYTES-RANGE
    imports MX-WASM-LEMMA-TESTS

    // Lookup in a concrete chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange (
                    SBChunk (
                        #bytes ( b"\x04\x00\x00\x00\x00" )
                    )
                    , 0 , 1
                )
            )
            ListItem(
                #getBytesRange (
                    SBChunk (
                        #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) )
                    )
                    , 0 , 1
                )
            )
        ) => doneSimplification(
            ListItem(b"\x04")
            ListItem(b"\x04")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    // Lookup in a symbolic empty chunk

    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange (
                    SBChunk ( #empty ( 5 ) )
                    , 0 , 1
                )
            )
            ListItem(
                #getBytesRange (
                    SBChunk ( #empty ( A ) )
                    , 0 , 1
                )
            )
        ) => doneSimplification(
            ListItem(b"\x00")
            ListItem(b"\x00")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A

    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange (
                    SBChunk ( #empty ( 5 ) )
                    , 1 , 1
                )
            )
            // TODO: make the symbolic part of this test work.
            // ListItem(
            //     #getBytesRange (
            //         SBChunk ( #empty ( A ) )
            //         , 1 , 1
            //     )
            // )
        ) => doneSimplification(
            ListItem(b"\x00")
            // ListItem(b"\x00")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A

    // Skipping chunks
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
                    SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
                  , 24 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
                    SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x05\x00\x00\x00" +Bytes _B ) )
                  , 24 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
                    SBChunk ( #empty ( A ) )
                    SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
                  , 14 +Int A , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A

    // Lookup after the end of the memory
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                  , 8 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                  , A , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"\x04" ) )
                    SBChunk ( #empty ( 4 ) )
                  , A , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"\x04" ) )
                    SBChunk ( #empty ( B ) )
                  , A , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x00")
            ListItem(b"\x00")
            ListItem(b"\x00")
            ListItem(b"\x00")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 4 <Int A
        andBool B <=Int 4

    // decodes ints
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( Int2Bytes(4, 145, LE) ) )
                  , 0 , 4
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( Int2Bytes(4, A, LE) ) )
                  , 0 , 4
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE) ) )
                  , 0 , (log2Int(B) +Int 8) /Int 8
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x91\x00\x00\x00")
            ListItem(Int2Bytes(4, A, LE))
            ListItem(Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE))
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int (1 <<Int 32)
        andBool 0 <Int B


    // extracts data from bytes concatenation
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"a" +Bytes Int2Bytes(4, 145, LE) +Bytes b"b" ) )
                  , 1 , 4
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"a" +Bytes Int2Bytes(4, A, LE) +Bytes b"b" ) )
                  , 1 , 4
                  )
            )
            ListItem(
                #getBytesRange
                  ( SBChunk ( #bytes ( b"a" +Bytes Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE) +Bytes b"b" ) )
                  , 1 , (log2Int(B) +Int 8) /Int 8
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x91\x00\x00\x00")
            ListItem(Int2Bytes(4, A, LE))
            ListItem(Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE))
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int (1 <<Int 32)
        andBool 0 <Int B

endmodule
