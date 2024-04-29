module SUBSTR-SPARSE-BYTES
    imports MX-WASM-LEMMA-TESTS

    // Lookup in a concrete chunk
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes (
                    SBChunk (
                        #bytes ( b"\x04\x00\x00\x00\x00" )
                    )
                    , 0 , 1
                )
            )
            ListItem(
                substrSparseBytes (
                    SBChunk (
                        #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) )
                    )
                    , 0 , 1
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x04"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x04"))
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
                substrSparseBytes (
                    SBChunk ( #empty ( 5 ) )
                    , 0 , 1
                )
            )
            ListItem(
                substrSparseBytes (
                    SBChunk ( #empty ( A ) )
                    , 0 , 1
                )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#empty(1))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#empty(1))
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                substrSparseBytes
                  ( SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
                    SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
                  , 24 , 25
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
                    SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x05\x00\x00\x00" +Bytes _B ) )
                  , 24 , 25
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #empty ( 10 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
                    SBChunk ( #empty ( A ) )
                    SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
                  , 14 +Int A , 15 +Int A
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                  , 8 , 1
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                  , A , 1
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"\x04" ) )
                    SBChunk ( #empty ( 4 ) )
                  , A , A +Int 1
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"\x04" ) )
                    SBChunk ( #empty ( B ) )
                  , A , A +Int 1
                  )
            )
        ) => doneSimplification(
            ListItem( .SparseBytes )
            ListItem( .SparseBytes )
            ListItem( .SparseBytes )
            ListItem( .SparseBytes )
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
                substrSparseBytes
                  ( SBChunk ( #bytes ( Int2Bytes(4, 145, LE) ) )
                  , 0 , 4
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( Int2Bytes(4, A, LE) ) )
                  , 0 , 4
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE) ) )
                  , 0 , (log2Int(B) +Int 8) /Int 8
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x91\x00\x00\x00"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(Int2Bytes(4, A, LE)))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE)))
                  .SparseBytes
                ):SparseBytes:KItem
            )
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
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"a" +Bytes Int2Bytes(4, 145, LE) +Bytes b"b" ) )
                  , 1 , 5
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"a" +Bytes Int2Bytes(4, A, LE) +Bytes b"b" ) )
                  , 1 , 5
                  )
            )
            ListItem(
                substrSparseBytes
                  ( SBChunk ( #bytes ( b"a" +Bytes Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE) +Bytes b"b" ) )
                  , 1 , 1 +Int (log2Int(B) +Int 8) /Int 8
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x91\x00\x00\x00"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(Int2Bytes(4, A, LE)))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(Int2Bytes((log2Int(B) +Int 8) /Int 8, B, LE)))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int (1 <<Int 32)
        andBool 0 <Int B

endmodule
