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
        ) => doneSimplification(int64encoding ( A , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ))
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
              ( ( ( ( ( ( (#bool ( 0 ==Int ((A) &Int (65280)) >>IntTotal (8) ))
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
        ) => doneSimplification(int64encoding ( A , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ))
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires A <Int 2 ^Int 64
endmodule
