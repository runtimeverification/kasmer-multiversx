module GET-BYTES-RANGE-SET-RANGE
    imports MX-WASM-LEMMA-TESTS

    // getBytesRange before setRange
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, 257, 4
                      )
                  , 0 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, A, 4
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
      requires 0 <Int A



    // getBytesRange in setRange
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, 257, 4
                      )
                  , 1 , 4
                  )
            )
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, A, 4
                      )
                  , 1 , 4
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x01\x01\x00\x00")
            ListItem(Int2Bytes(4, A, LE))
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getBytesRange after setRange, same chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, 257, 4
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, A, 4
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getBytesRange after setRange, different chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 1, 257, 4
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 1, A, 4
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getBytesRange after setRange, incomplete overlap
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, 257, 4
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, A, 4
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32


    // getBytesRange after setRange, incomplete overlap, symbolic set length
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, 257, 4
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, A, B
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32 andBool 0 <Int B andBool B <Int 5

endmodule
