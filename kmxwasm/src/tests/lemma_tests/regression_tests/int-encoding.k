module INT-ENCODING
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            ( ( ( ( ( ( ( (A &Int 255) <<IntTotal 56)
                      |Int ((A &Int 65280) <<IntTotal 40)
                      )
                    |Int ((A &Int 16711680) <<IntTotal 24)
                    )
                  |Int ((A &Int 4278190080) <<IntTotal 8)
                  )
                |Int ((A &Int 1095216660480) >>IntTotal 8)
                )
              |Int ((A &Int 280375465082880) >>IntTotal 24)
              )
            |Int ((A &Int 71776119061217280) >>IntTotal 40)
            )
          |Int (A >>IntTotal 56)
        ) => doneSimplification(int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( ( ( #bool ( 0 ==Int (A) >>IntTotal (56) ) )
                        &Int (#bool ( 0 ==Int ((A) &Int (71776119061217280)) >>IntTotal (48) ))
                        )
                      +Int (#bool ( 0 ==Int (A) >>IntTotal (56) ))
                      )
                    +Int
                      ( ( (#bool ( 0 ==Int ((A) &Int (280375465082880)) >>IntTotal (40) ))
                        &Int (#bool ( 0 ==Int (A) >>IntTotal (56) ))
                        )
                      &Int (#bool ( 0 ==Int ((A) &Int (71776119061217280)) >>IntTotal (48) ))
                      )
                    )
                  +Int
                    ( ( ( (#bool ( 0 ==Int ((A) &Int (1095216660480)) >>IntTotal (32) ))
                        &Int (#bool ( 0 ==Int ((A) &Int (280375465082880)) >>IntTotal (40) ))
                        )
                      &Int (#bool ( 0 ==Int (A) >>IntTotal (56) ))
                      )
                    &Int (#bool ( 0 ==Int ((A) &Int (71776119061217280)) >>IntTotal (48) ))
                    )
                  )
                +Int
                  ( ( ( ( (#bool ( 0 ==Int ((A) &Int (4294967295)) >>IntTotal (24) ))
                        &Int (#bool ( 0 ==Int ((A) &Int (1095216660480)) >>IntTotal (32) ))
                        )
                      &Int (#bool ( 0 ==Int ((A) &Int (280375465082880)) >>IntTotal (40) ))
                      )
                    &Int (#bool ( 0 ==Int (A) >>IntTotal (56) ))
                    )
                  &Int (#bool ( 0 ==Int ((A) &Int (71776119061217280)) >>IntTotal (48) ))
                  )
                )
              +Int
                ( ( ( ( ( (#bool ( 0 ==Int ((A) &Int (16711680)) >>IntTotal (16) ))
                        &Int (#bool ( 0 ==Int ((A) &Int (4294967295)) >>IntTotal (24) ))
                        )
                      &Int (#bool ( 0 ==Int ((A) &Int (1095216660480)) >>IntTotal (32) ))
                      )
                    &Int (#bool ( 0 ==Int ((A) &Int (280375465082880)) >>IntTotal (40) ))
                    )
                  &Int (#bool ( 0 ==Int (A) >>IntTotal (56) ))
                  )
                &Int (#bool ( 0 ==Int ((A) &Int (71776119061217280)) >>IntTotal (48) ))
                )
              )
            +Int
              ( ( ( ( ( ( (#bool ( 0 ==Int ((A) &Int (65280)) >>IntTotal 8 ))
                        &Int (#bool ( 0 ==Int ((A) &Int (16711680)) >>IntTotal (16) ))
                        )
                      &Int (#bool ( 0 ==Int ((A) &Int (4294967295)) >>IntTotal (24) ))
                      )
                    &Int (#bool ( 0 ==Int ((A) &Int (1095216660480)) >>IntTotal (32) ))
                    )
                  &Int (#bool ( 0 ==Int ((A) &Int (280375465082880)) >>IntTotal (40) ))
                  ) &Int (#bool ( 0 ==Int (A) >>IntTotal (56) ))
                )
              &Int (#bool ( 0 ==Int ((A) &Int (71776119061217280)) >>IntTotal (48) ))
              )
            ) modIntTotal (4294967296) ==Int 0
          )
        ) => doneSimplification( countConsecutiveZeroBytes ( A, 6 ) ==Int 0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( int64encoding
            ( A, 0, 1, 2, 3, -1, -1, -1, -1 )
          ) modIntTotal (4294967296)
        ) => doneSimplification(int64encoding ( A, 0, 1, 2, 3, -1, -1, -1, -1 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( int64BytesAre0(A >>IntTotal (48), false, false, false, false, false, false, false, true)
          )
        ) => doneSimplification(int64BytesAre0(A, false, true, false, false, false, false, false, false))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( int64BytesAre0 ( (A &Int (4294967295)) >>IntTotal (16), false, false, false, false, false, false, false, true )
          )
        ) => doneSimplification(int64BytesAre0(A, false, false, false, false, false, true, false, false))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( #bool ( 0 ==Int ( int64encoding ( A, 0, -1, -1, -1, -1, -1, -1, -1 ) ) )
          )
        ) => doneSimplification(int64BytesAre0(A, true, false, false, false, false, false, false, false))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( int64encoding ( A, -1, -1, -1, -1, -1, -1, -1, 7 )
          ) &Int (18446744073709551615)
        ) => doneSimplification(int64encoding ( A, -1, -1, -1, -1, -1, -1, -1, 7 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( 8
                      *Int
                        ( int64BytesAre0
                          ( A, true, true, false, false, false, false, false, false )
                        )
                      )
                    +Int
                      ( 8 *Int (int64BytesAre0 ( A, true, false, false, false, false, false, false, false ))
                      )
                    )
                  +Int
                    (8 *Int (int64BytesAre0 ( A, true, true, true, false, false, false, false, false )))
                  )
                +Int
                  (8 *Int (int64BytesAre0 ( A, true, true, true, true, false, false, false, false )))
                )
              +Int
                (8 *Int (int64BytesAre0 ( A, true, true, true, true, true, false, false, false )))
              )
            +Int
              (8 *Int (int64BytesAre0 ( A, true, true, true, true, true, true, false, false )))
            )
          +Int
            (8 *Int (int64BytesAre0 ( A, true, true, true, true, true, true, true, false )))
          )
        ) => doneSimplification(countConsecutiveZeroBits(A, 6))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( X
                      +Int -8 *Int ( int64BytesAre0 ( A, true, true, false, false, false, false, false, false ) )
                      )
                    +Int
                      ( -8 *Int (int64BytesAre0 ( A, true, false, false, false, false, false, false, false ))
                      )
                    )
                  +Int
                    (-8 *Int (int64BytesAre0 ( A, true, true, true, false, false, false, false, false )))
                  )
                +Int
                  (-8 *Int (int64BytesAre0 ( A, true, true, true, true, false, false, false, false )))
                )
              +Int
                (-8 *Int (int64BytesAre0 ( A, true, true, true, true, true, false, false, false )))
              )
            +Int
              (-8 *Int (int64BytesAre0 ( A, true, true, true, true, true, true, false, false )))
            )
          +Int
            (-8 *Int (int64BytesAre0 ( A, true, true, true, true, true, true, true, false )))
          )
        ) => doneSimplification(X +Int -1 *Int countConsecutiveZeroBits(A, 6))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( int64encoding ( A >>IntTotal 24, -1, -1, -1, -1, -1, 2, -1, -1 )
          )
        ) => doneSimplification(int64encoding ( A, -1, -1, 2, -1, -1, -1, -1, -1 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( ( ( ( int64encoding( A, -1, -1, -1, -1, -1, -1, -1, 7 ) ) )
                        >>IntTotal
                          countConsecutiveZeroBits(A, 6)
                        )
                      |Int
                        ( ( ( int64encoding( A, -1, -1, -1, -1, -1, -1, 6, -1 ) ) )
                        >>IntTotal
                          countConsecutiveZeroBits(A, 6)
                        )
                      )
                    |Int
                      (((int64encoding ( A, -1, -1, -1, -1, -1, 5, -1, -1 )) ) >>IntTotal countConsecutiveZeroBits(A, 6))
                    )
                  |Int (((int64encoding ( A, -1, -1, -1, -1, 4, -1, -1, -1 )) ) >>IntTotal countConsecutiveZeroBits(A, 6))
                  )
                |Int (((int64encoding ( (A) >>IntTotal (8), -1, -1, -1, -1, 3, -1, -1, -1 )) ) >>IntTotal countConsecutiveZeroBits(A, 6))
                )
              |Int (((int64encoding ( (A) >>IntTotal (24), -1, -1, -1, -1, -1, 2, -1, -1 )) ) >>IntTotal countConsecutiveZeroBits(A, 6))
              )
            |Int (((int64encoding ( (A) >>IntTotal (40), -1, -1, -1, -1, -1, -1, 1, -1 )) ) >>IntTotal countConsecutiveZeroBits(A, 6))
            )
          |Int (((int64encoding ( A, 0, -1, -1, -1, -1, -1, -1, -1 )) ) >>IntTotal countConsecutiveZeroBits(A, 6))
          )
        ) => doneSimplification(optimizedInt64Encoding ( A, true, true, true, true, true, true, true, true ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( int64encoding ( A, 0, 1, -1, -1, -1, -1, -1, -1 ) modIntTotal 18446744073709551616
          )
        ) => doneSimplification(int64encoding ( A, 0, 1, -1, -1, -1, -1, -1, -1 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( int64encoding ( A, -1, -1, -1, -1, -1, -1, -1, 7 ) )
                  |Int
                    ( (int64encoding ( A, -1, -1, -1, -1, -1, -1, 6, -1 ))
                    modIntTotal (18446744073709551616)
                    )
                  )
                |Int (int64encoding ( A, -1, -1, -1, -1, -1, 5, -1, -1 ))
                )
              |Int
                ( (int64encoding ( A, -1, -1, -1, -1, 4, -1, -1, -1 ))
                modIntTotal (18446744073709551616)
                )
              )
            |Int (int64encoding ( A, -1, -1, 2, 3, -1, -1, -1, -1 ))
            )
          |Int
            ( (int64encoding ( A, 0, 1, -1, -1, -1, -1, -1, -1 ) )
            modIntTotal (18446744073709551616)
            )
          )
        ) => doneSimplification(int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( ( int64BytesAre0
                          ( A, true, true, false, false, false, false, false, false )
                        )
                      )
                    +Int
                      ( (int64BytesAre0 ( A, true, false, false, false, false, false, false, false ))
                      )
                    )
                  +Int
                    ((int64BytesAre0 ( A, true, true, true, false, false, false, false, false )))
                  )
                +Int
                  ((int64BytesAre0 ( A, true, true, true, true, false, false, false, false )))
                )
              +Int
                ((int64BytesAre0 ( A, true, true, true, true, true, false, false, false )))
              )
            +Int
              ((int64BytesAre0 ( A, true, true, true, true, true, true, false, false )))
            )
          +Int
            ((int64BytesAre0 ( A, true, true, true, true, true, true, true, false )))
          )
        ) => doneSimplification(countConsecutiveZeroBytes(A, 6))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( X
                      +Int -1 *Int ( int64BytesAre0 ( A, true, true, false, false, false, false, false, false ) )
                      )
                    +Int
                      ( -1 *Int (int64BytesAre0 ( A, true, false, false, false, false, false, false, false ))
                      )
                    )
                  +Int
                    (-1 *Int (int64BytesAre0 ( A, true, true, true, false, false, false, false, false )))
                  )
                +Int
                  (-1 *Int (int64BytesAre0 ( A, true, true, true, true, false, false, false, false )))
                )
              +Int
                (-1 *Int (int64BytesAre0 ( A, true, true, true, true, true, false, false, false )))
              )
            +Int
              (-1 *Int (int64BytesAre0 ( A, true, true, true, true, true, true, false, false )))
            )
          +Int
            (-1 *Int (int64BytesAre0 ( A, true, true, true, true, true, true, true, false )))
          )
        ) => doneSimplification(X +Int -1 *Int countConsecutiveZeroBytes(A, 6))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    // claim
    //   <k>
    //     runSimplification(
    //       int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 )
    //       >>Int countConsecutiveZeroBits ( A, 6 )
    //     ) => doneSimplification(int64encoding ( A, 0, 1, -1, -1, -1, -1, -1, -1 ))
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          Bytes2Int
            ( Int2Bytes
              ( ((-1) *Int (countConsecutiveZeroBytes ( A, 6 ))) +Int (8)
              , (int64encoding ( A, 0, 1, 2, 3, 4, 5, 6, 7 ))
                >>IntTotal ((8) *Int (countConsecutiveZeroBytes ( A, 6 )))
              , LE
              )
            , BE
            , Unsigned
            )
        ) => doneSimplification( A )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <Int 2 ^Int 64

    claim
      <k>
        runSimplification(
          int64encoding( _, -1, -1, -1, -1, -1, -1, 2 , -1 ) <=Int 4294967295
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          int64encoding( A, -1, -1, -1, -1, -1, -1, 2 , -1 )
          &Int 4294967295
        ) => doneSimplification( int64encoding( A, -1, -1, -1, -1, -1, -1, 2 , -1 ) )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          int64encoding
          ( int64encoding ( _, -1, -1, -1, -1, -1, -1, 2 , -1)
          , -1, -1, -1, -1, -1, -1, -1, 3
          )
        ) => doneSimplification( 0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          int64encoding
          ( int64encoding ( A, -1, -1, -1, -1, -1, -1, 2 , -1)
          , -1, -1, -1, -1, -1, 0 , -1, -1
          )
        ) => doneSimplification( int64encoding ( A, -1, -1, -1, -1, -1, -1, 0 , -1) )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          int64encoding ( 0, -1, -1, -1, -1, -1, -1, -1, -1)
        ) => doneSimplification( 0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          int64encoding ( _ modInt 8, -1, -1, -1, -1, -1, -1, 1, -1)
        ) => doneSimplification( 0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          int64encoding ( A, -1, -1, -1, -1, -1, -1, 1, -1) |Int A
        ) => doneSimplification( A )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          B
          +Bytes Int2Bytes
            ( 1, int64encoding( A, 0, -1, -1, -1, -1, -1, -1, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, 0, -1, -1, -1, -1, -1, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, -1, 0, -1, -1, -1, -1, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, -1, -1, 0, -1, -1, -1, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, -1, -1, -1, 0, -1, -1, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, -1, -1, -1, -1, 0, -1, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, 0, -1 ), LE )
          +Bytes Int2Bytes
            ( 1, int64encoding( A, -1, -1, -1, -1, -1, -1, -1, 0 ), LE )
        ) => doneSimplification(
          B +Bytes Int2Bytes(8, int64encoding( A, 0, 1, 2, 3, 4, 5, 6, 7 ), LE)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
