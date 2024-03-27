module INT-LENGTH
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
              -1 *Int ((log2IntTotal (A:Int) +Int 8) divIntTotal 8)
              +Int (9904)
            <Int
              ( log2IntTotal( (A *Int B) divIntTotal (B +Int C) ) +Int 8 ) divIntTotal 8
        ) => doneSimplification( A )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295

endmodule
