module SUBSTR-SPARSE-BYTES-SET-RANGE
    imports MX-WASM-LEMMA-TESTS

    // substrSparseBytes before setRange
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, 257, 4
                      )
                  , 0 , 1
                  )
            )
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, A, 4
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
      requires 0 <Int A



    // substrSparseBytes in setRange
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, 257, 4
                      )
                  , 1 , 5
                  )
            )
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, A, 4
                      )
                  , 1 , 5
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x01\x01\x00\x00"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(Int2Bytes(4, A, LE)))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // substrSparseBytes after setRange, same chunk
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, 257, 4
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, A, 4
                      )
                  , 5 , 6
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
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // substrSparseBytes after setRange, different chunk
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 1, 257, 4
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 1, A, 4
                      )
                  , 5 , 6
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
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // substrSparseBytes after setRange, incomplete overlap
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, 257, 4
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, A, 4
                      )
                  , 5 , 6
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
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32


    // substrSparseBytes after setRange, incomplete overlap, symbolic set length
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, 257, 4
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, A, B
                      )
                  , 5 , 6
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
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32 andBool 0 <Int B andBool B <Int 5

endmodule
