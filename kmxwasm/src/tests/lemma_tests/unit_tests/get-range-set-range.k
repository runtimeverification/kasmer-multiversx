module GET-RANGE-SET-RANGE
    imports MX-WASM-LEMMA-TESTS

    // getRange before setRange
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, 257, 4
                      )
                  , 0 , 1
                  )
            )
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, A, 4
                      )
                  , 0 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(4)
            ListItem(4)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A



    // getRange in setRange
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, 257, 4
                      )
                  , 1 , 4
                  )
            )
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, A, 4
                      )
                  , 1 , 4
                  )
            )
        ) => doneSimplification(
            ListItem(257)
            ListItem(A)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getRange after setRange, same chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, 257, 4
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, A, 4
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getRange after setRange, different chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 1, 257, 4
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getRange
                  ( #setRange
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 1, A, 4
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getRange after setRange, incomplete overlap
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
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
                #getRange
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
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32


    // getRange after setRange, incomplete overlap, symbolic set length
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
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
                #getRange
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
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32 andBool 0 <Int B andBool B <Int 5

endmodule
