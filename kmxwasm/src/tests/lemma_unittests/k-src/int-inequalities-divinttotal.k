module INT-INEQUALITIES-DIVINTTOTAL
    imports MX-WASM-LEMMA-TESTS

    // rule A <=Int C divIntTotal B => A *Int B <=Int C
    //     requires 0 <Int B andBool 0 <=Int C
    //     [simplification, concrete(A)]
    claim
      <k>
        runSimplification(
          ListItem(2 <=Int 5 divIntTotal 3)
          ListItem(2 <=Int 6 divIntTotal 3)

          ListItem(0 <=Int 0 divIntTotal 3)
          ListItem(1 <=Int 0 divIntTotal 3)

          ListItem(2 <=Int X divIntTotal 3)
          ListItem(2 <=Int Y divIntTotal 3)
        ) => doneSimplification(
          ListItem(false)
          ListItem(true)

          ListItem(true)
          ListItem(false)

          ListItem(false)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int X andBool X <Int 6 andBool 6 <=Int Y

    // rule A <Int C divIntTotal B => (A +Int 1) *Int B <=Int C
    //     requires 0 <Int B andBool 0 <=Int C
    //     [simplification, concrete(A)]
    claim
      <k>
        runSimplification(
          ListItem(2 <Int 8 divIntTotal 3)
          ListItem(2 <Int 9 divIntTotal 3)

          ListItem(-1 <Int 0 divIntTotal 3)
          ListItem(0 <Int 0 divIntTotal 3)

          ListItem(2 <Int X divIntTotal 3)
          ListItem(2 <Int Y divIntTotal 3)
        ) => doneSimplification(
          ListItem(false)
          ListItem(true)

          ListItem(true)
          ListItem(false)

          ListItem(false)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int X andBool X <Int 9 andBool 9 <=Int Y

    // rule A divIntTotal C <Int B => A <Int B *Int C
    //     requires 0 <Int C andBool 0 <=Int A
    //     [simplification, concrete(B)]
    claim
      <k>
        runSimplification(
          ListItem(8 divIntTotal 3 <Int 3)
          ListItem(9 divIntTotal 3 <Int 3)

          ListItem(0 divIntTotal 3 <Int 0)
          ListItem(0 divIntTotal 3 <Int 1)

          ListItem(X divIntTotal 3 <Int 3)
          ListItem(Y divIntTotal 3 <Int 3)
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)

          ListItem(false)
          ListItem(true)

          ListItem(true)
          ListItem(false)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int X andBool X <Int 9 andBool 9 <=Int Y

    // rule A divIntTotal C <=Int B => A <Int (B +Int 1) *Int C
    //     requires 0 <Int C andBool 0 <=Int A
    //     [simplification, concrete(B)]
    claim
      <k>
        runSimplification(
          ListItem(11 divIntTotal 3 <=Int 3)
          ListItem(12 divIntTotal 3 <=Int 3)

          ListItem(0 divIntTotal 3 <=Int -1)
          ListItem(0 divIntTotal 3 <=Int 0)

          ListItem(X divIntTotal 3 <=Int 3)
          ListItem(Y divIntTotal 3 <=Int 3)
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)

          ListItem(false)
          ListItem(true)

          ListItem(true)
          ListItem(false)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int X andBool X <Int 12 andBool 12 <=Int Y

    // rule 0 =/=Int A divIntTotal B => B <=Int A
    //     requires 0 <=Int A andBool 0 <Int B
    //     [simplification]
    claim
      <k>
        runSimplification(
          ListItem(0 =/=Int 9 divIntTotal 9)
          ListItem(0 =/=Int 9 divIntTotal 10)

          ListItem(0 =/=Int 0 divIntTotal 1)

          ListItem(0 =/=Int 9 divIntTotal X)
          ListItem(0 =/=Int 9 divIntTotal Y)
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)

          ListItem(false)

          ListItem(true)
          ListItem(false)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <=Int 9 andBool 9 <Int Y

    // rule 0 ==Int A divIntTotal B => A <Int B
    //     requires 0 <=Int A andBool 0 <Int B
    //     [simplification]
    claim
      <k>
        runSimplification(
          ListItem(0 ==Int 9 divIntTotal 9)
          ListItem(0 ==Int 9 divIntTotal 10)

          ListItem(0 ==Int 0 divIntTotal 1)

          ListItem(0 ==Int 9 divIntTotal X)
          ListItem(0 ==Int 9 divIntTotal Y)
        ) => doneSimplification(
          ListItem(false)
          ListItem(true)

          ListItem(true)

          ListItem(false)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <=Int 9 andBool 9 <Int Y

    claim
      <k>
        runSimplification(
          (A *Int B) divIntTotal (B +Int C) ==Int 0
        ) => doneSimplification(
          false
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <Int C

endmodule
