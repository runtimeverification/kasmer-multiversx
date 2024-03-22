module INT-INEQUALITIES-LOG2INT
    imports MX-WASM-LEMMA-TESTS

    // rule 0 <=Int log2IntTotal(_:Int) => true
    //   [simplification, smt-lemma]
    claim
      <k>
        runSimplification(
          ListItem(0 <=Int log2IntTotal(-1))
          ListItem(0 <=Int log2IntTotal(0))
          ListItem(0 <=Int log2IntTotal(1))
          ListItem(0 <=Int log2IntTotal(_))
        ) => doneSimplification(
          ListItem(true)
          ListItem(true)
          ListItem(true)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    // rule log2IntTotal(A) <Int B => A <Int 2 ^Int B
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
    //     [simplification, concrete(B)]
    //
    // rule log2IntTotal(A) <Int B => true
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool 1000 <Int B
    //         andBool A <Int 2 ^Int 1000
    //     [simplification, concrete(B)]
    claim
      <k>
        runSimplification(
          ListItem(log2IntTotal(3) <Int 2)
          ListItem(log2IntTotal(4) <Int 2)
          ListItem(log2IntTotal((2 ^Int 1000) -Int 1) <Int 1000)
          ListItem(log2IntTotal(2 ^Int 1000) <Int 1000)
          ListItem(log2IntTotal((2 ^Int 1001) -Int 1) <Int 1001)
          ListItem(log2IntTotal(2 ^Int 1001) <Int 1001)

          ListItem(log2IntTotal(X) <Int 2)
          ListItem(log2IntTotal(Y) <Int 2)
          ListItem(log2IntTotal(Z) <Int 1000)
          ListItem(log2IntTotal(Z) <Int 100000)
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)

          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <Int 4
        andBool 4 <=Int Y
        andBool 0 <Int Z andBool Z <Int 2 ^Int 1000

    // rule log2IntTotal(A) <=Int B => A <Int 2 ^Int (B +Int 1)
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
    //     [simplification, concrete(B)]
    //
    // rule log2IntTotal(A) <=Int B => true
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool 1000 <Int B
    //         andBool A <Int 2 ^Int 1001
    //     [simplification, concrete(B)]
    claim
      <k>
        runSimplification(
          ListItem(log2IntTotal(7) <=Int 2)
          ListItem(log2IntTotal(8) <=Int 2)
          ListItem(log2IntTotal((2 ^Int 1001) -Int 1) <=Int 1000)
          ListItem(log2IntTotal(2 ^Int 1001) <=Int 1000)
          ListItem(log2IntTotal((2 ^Int 1002) -Int 1) <=Int 1001)
          ListItem(log2IntTotal(2 ^Int 1002) <=Int 1001)

          ListItem(log2IntTotal(X) <=Int 2)
          ListItem(log2IntTotal(Y) <=Int 2)
          ListItem(log2IntTotal(Z) <=Int 1001)
          ListItem(log2IntTotal(Z) <=Int 100000)
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)

          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <=Int 7
        andBool 7 <Int Y
        andBool 0 <Int Z andBool Z <Int 2 ^Int 1001

    // rule B <=Int log2IntTotal(A) => 2 ^Int B <=Int A
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
    //     [simplification, concrete(B)]
    //
    // rule B <=Int log2IntTotal(A) => false
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool 1000 <Int B
    //         andBool A <Int 2 ^Int 1000
    //     [simplification, concrete(B)]
    claim
      <k>
        runSimplification(
          ListItem(2 <=Int log2IntTotal(4))
          ListItem(2 <=Int log2IntTotal(3))
          ListItem(1000 <=Int log2IntTotal(2 ^Int 1000))
          ListItem(1000 <=Int log2IntTotal((2 ^Int 1000) -Int 1))
          ListItem(1001 <=Int log2IntTotal(2 ^Int 1001))
          ListItem(1001 <=Int log2IntTotal((2 ^Int 1001) -Int 1))

          ListItem(2 <=Int log2IntTotal(X))
          ListItem(2 <=Int log2IntTotal(Y))
          ListItem(1000 <=Int log2IntTotal(Z))
          ListItem(100000 <=Int log2IntTotal(T))
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)

          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 4 <=Int X
        andBool 0 <Int Y andBool Y <Int 4
        andBool 2 ^Int 1000 <=Int Z
        andBool 0 <Int T andBool T <Int 2 ^Int 1000

    // rule B <Int log2IntTotal(A) => 2 ^Int (B +Int 1) <=Int A
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool B <=Int 1000 // Making sure there is no OOM when computing 2^B
    //     [simplification, concrete(B)]
    //
    // rule B <Int log2IntTotal(A) => false
    //     requires 0 <Int A andBool 0 <=Int B
    //         andBool 1000 <Int B
    //         andBool A <Int 2 ^Int 1002
    //     [simplification, concrete(B)]
    claim
      <k>
        runSimplification(
          ListItem(2 <Int log2IntTotal(8))
          ListItem(2 <Int log2IntTotal(7))
          ListItem(1000 <Int log2IntTotal(2 ^Int 1001))
          ListItem(1000 <Int log2IntTotal((2 ^Int 1001) -Int 1))
          ListItem(1001 <Int log2IntTotal(2 ^Int 1002))
          ListItem(1001 <Int log2IntTotal((2 ^Int 1002) -Int 1))

          ListItem(2 <Int log2IntTotal(X))
          ListItem(2 <Int log2IntTotal(Y))
          ListItem(1000 <Int log2IntTotal(Z))
          ListItem(100000 <Int log2IntTotal(T))
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)

          ListItem(true)
          ListItem(false)
          ListItem(true)
          ListItem(false)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 8 <=Int X
        andBool 0 <Int Y andBool Y <Int 8
        andBool 2 ^Int 1001 <=Int Z
        andBool 0 <Int T andBool T <Int 2 ^Int 1002

    // rule A <=Int log2IntTotal(_) => true
    //     requires A <=Int 0
    //     [simplification]
    claim
      <k>
        runSimplification(
          ListItem(0 <=Int log2IntTotal(-1))
          ListItem(0 <=Int log2IntTotal(0))
          ListItem(0 <=Int log2IntTotal(1))

          ListItem(X <=Int log2IntTotal(_))
        ) => doneSimplification(
          ListItem(true)
          ListItem(true)
          ListItem(true)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires X <=Int 0

    // rule A <Int log2IntTotal(_) => true
    //     requires A <Int 0
    //     [simplification]
    claim
      <k>
        runSimplification(
          ListItem(-1 <Int log2IntTotal(-1))
          ListItem(-1 <Int log2IntTotal(0))
          ListItem(-1 <Int log2IntTotal(1))

          ListItem(X <Int log2IntTotal(_))
        ) => doneSimplification(
          ListItem(true)
          ListItem(true)
          ListItem(true)
          ListItem(true)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires X <Int 0

    claim
      <k>
        runSimplification(
          log2IntTotal ( X ) <Int 34359738360
        ) => doneSimplification(
          true
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <Int 2 ^Int 800

endmodule
