module INT-LENGTH
    imports MX-WASM-LEMMA-TESTS
    imports INT-LENGTH-LEMMAS-BASIC

    claim
      <k>
        runSimplification(
          (A *Int B) divIntTotal (B +Int C) <=Int maxForLength(101)
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
              -1 *Int ((log2IntTotal (A:Int) +Int 8) divIntTotal 8)
              +Int (9904)
            <Int
              ( log2IntTotal( (A *Int B) divIntTotal (B +Int C) ) +Int 8 ) divIntTotal 8
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
              ( log2IntTotal( (A *Int B) divIntTotal (B +Int C) ) +Int 8 ) divIntTotal 8
            <=Int
              -1 *Int ((log2IntTotal (A:Int) +Int 8) divIntTotal 8)
              +Int (9904)
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
            101 <Int 4294967200 -Int ((log2IntTotal(A) +Int 8) divIntTotal 8)
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376

    claim
      <k>
        runSimplification(
            ((log2IntTotal((A *Int B) divIntTotal (B +Int C)) +Int 8) divIntTotal 8) <Int 2 ^Int 101
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
            ( ( ((log2IntTotal(A) +Int 8) divIntTotal 8)
                +Int
                ((log2IntTotal((A *Int B) divIntTotal (B +Int C)) +Int 8) divIntTotal 8)
              )
              +Int 96
            )
          <Int
            4294967296
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
            4294967296
          <=Int 
            ( ( ((log2IntTotal(A) +Int 8) divIntTotal 8)
                +Int
                ((log2IntTotal((A *Int B) divIntTotal (B +Int C)) +Int 8) divIntTotal 8)
              )
              +Int 96
            )
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
            ((log2IntTotal(A) +Int 8) divIntTotal 8)
          +Int
            ((log2IntTotal( (A *Int B) divIntTotal (B +Int C) ) +Int 8) divIntTotal 8)
          <=Int
            9904
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
            9904
          <Int
            ((log2IntTotal(A) +Int 8) divIntTotal 8)
          +Int
            ((log2IntTotal((A *Int B) divIntTotal (B +Int C)) +Int 8) divIntTotal 8)
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

    claim
      <k>
        runSimplification(
          (
            (-1)
            *Int
              ( ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
              +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
              +Int 96
              )
            +Int 10000
          ) <Int (4294967296)
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

    claim
      <k>
        runSimplification(
          0 <=Int
          (
            (-1)
            *Int
              ( ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
              +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
              +Int 96
              )
            +Int 10000
          )
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

    claim
      <k>
        runSimplification(
          (
            (-1)
            *Int
              ( ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
              +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
              +Int 96
              )
            +Int 10000
          ) modIntTotal (4294967296)
        ) => doneSimplification(
          -1 *Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
          +Int -1 *Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
          +Int 9904
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

    claim
      <k>
        runSimplification(
          9903
          <Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
            +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

    claim
      <k>
        runSimplification(
          ( -1 *Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
            +Int -1 *Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
          ) <Int -9903
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

    claim
      <k>
        runSimplification(
          (
            (-1)
            *Int
              ( ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
              +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
              +Int 96
              )
            +Int 10000
          ) modIntTotal (4294967296) <Int 1
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

endmodule
