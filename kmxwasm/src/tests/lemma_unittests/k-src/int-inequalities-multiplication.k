module INT-INEQUALITIES-MULTIPLICATION
    imports MX-WASM-LEMMA-TESTS

    // // rule A <=Int B *Int X => A /Int B <=Int X
    // //     requires 0 <Int B andBool A %Int B ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(9 <=Int 3 *Int 2)
    //       ListItem(9 <=Int 3 *Int 3)

    //       ListItem(-9 <=Int 3 *Int -3)
    //       ListItem(-9 <=Int 3 *Int -4)

    //       ListItem(9 <=Int 3 *Int X)
    //       ListItem(9 <=Int 3 *Int Y)
    //     ) => doneSimplification(
    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 3 andBool 3 <=Int Y

    // // rule A <=Int B *Int X => X <=Int A /Int B
    // //     requires B <Int 0 andBool A %Int B ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(-9 <=Int -3 *Int 3)
    //       ListItem(-9 <=Int -3 *Int 4)

    //       ListItem(9 <=Int -3 *Int -2)
    //       ListItem(9 <=Int -3 *Int -3)

    //       ListItem(-9 <=Int -3 *Int X)
    //       ListItem(-9 <=Int -3 *Int Y)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 4 andBool 4 <=Int Y

    // // rule A *Int X <=Int B => X <=Int B /Int A
    // //     requires 0 <Int A andBool B %Int A ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(3 *Int 2 <=Int 6)
    //       ListItem(3 *Int 3 <=Int 6)

    //       ListItem(3 *Int -2 <=Int -9)
    //       ListItem(3 *Int -3 <=Int -9)

    //       ListItem(3 *Int X <=Int 6)
    //       ListItem(3 *Int Y <=Int 6)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 3 andBool 3 <=Int Y

    // // rule A *Int X <=Int B => B /Int A <=Int X
    // //     requires A <Int 0 andBool B %Int A ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(-3 *Int 2 <=Int -9)
    //       ListItem(-3 *Int 3 <=Int -9)

    //       ListItem(-3 *Int -2 <=Int 6)
    //       ListItem(-3 *Int -3 <=Int 6)

    //       ListItem(-3 *Int X <=Int -9)
    //       ListItem(-3 *Int Y <=Int -9)
    //     ) => doneSimplification(
    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 3 andBool 3 <=Int Y

    // // rule A <Int B *Int X => A /Int B <Int X
    // //     requires 0 <Int B andBool A %Int B ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(9 <Int 3 *Int 3)
    //       ListItem(9 <Int 3 *Int 4)

    //       ListItem(-9 <Int 3 *Int -2)
    //       ListItem(-9 <Int 3 *Int -3)

    //       ListItem(9 <Int 3 *Int X)
    //       ListItem(9 <Int 3 *Int Y)
    //     ) => doneSimplification(
    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 4 andBool 4 <=Int Y

    // // rule A <Int B *Int X => X <Int A /Int B 
    // //     requires B <Int 0 andBool A %Int B ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(-9 <Int -3 *Int 2)
    //       ListItem(-9 <Int -3 *Int 3)

    //       ListItem(9 <Int -3 *Int -3)
    //       ListItem(9 <Int -3 *Int -4)

    //       ListItem(-9 <Int -3 *Int X)
    //       ListItem(-9 <Int -3 *Int Y)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 3 andBool 3 <=Int Y

    // // rule A *Int X <Int B => X <Int B /Int A
    // //     requires 0 <Int A andBool B %Int A ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(3 *Int 2 <Int 9)
    //       ListItem(3 *Int 3 <Int 9)

    //       ListItem(3 *Int -2 <Int -6)
    //       ListItem(3 *Int -3 <Int -6)

    //       ListItem(3 *Int X <Int 9)
    //       ListItem(3 *Int Y <Int 9)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 3 andBool 3 <=Int Y

    // // rule A *Int X <Int B => B /Int A <Int X
    // //     requires A <Int 0 andBool B %Int A ==Int 0
    // //     [simplification, concrete(A, B)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(-3 *Int 2 <Int -6)
    //       ListItem(-3 *Int 3 <Int -6)

    //       ListItem(-3 *Int -2 <Int 9)
    //       ListItem(-3 *Int -3 <Int 9)

    //       ListItem(-3 *Int X <Int -6)
    //       ListItem(-3 *Int Y <Int -6)
    //     ) => doneSimplification(
    //       ListItem(false)
    //       ListItem(true)

    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(false)
    //       ListItem(true)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <Int 3 andBool 3 <=Int Y


    // // rule B *Int A <=Int C => A <=Int C /Int B
    // //     requires 0 <Int B andBool 0 <=Int C
    // //     [simplification, concrete(B, C)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(3 *Int 4 <=Int 12)
    //       ListItem(3 *Int 4 <=Int 11)

    //       ListItem(3 *Int X <=Int 12)
    //       ListItem(3 *Int Y <=Int 11)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(true)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires X <=Int 4 andBool 4 <=Int Y

    // // rule B *Int A <Int C
    // //     =>  #if C modInt B ==Int 0
    // //         #then
    // //           A <Int C /Int B
    // //         #else
    // //           A <=Int C /Int B
    // //         #fi
    // //     requires 0 <Int B
    // //       andBool 0 <=Int C
    // //     [simplification, concrete(B, C)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(3 *Int 4 <Int 11)
    //       ListItem(3 *Int 4 <Int 12)
    //       ListItem(3 *Int 4 <Int 13)
    //       ListItem(3 *Int 4 <Int 15)

    //       ListItem(3 *Int X <Int 11)
    //       ListItem(3 *Int X <Int 12)
    //       ListItem(3 *Int Y <Int 13)
    //       ListItem(3 *Int Y <Int 15)
    //     ) => doneSimplification(
    //       ListItem(false)
    //       ListItem(false)
    //       ListItem(true)
    //       ListItem(true)

    //       ListItem(false)
    //       ListItem(false)
    //       ListItem(true)
    //       ListItem(true)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires Y <=Int 4 andBool 4 <=Int X

    // // rule A <=Int C *Int B
    // //       =>  #if A modInt C ==Int 0
    // //           #then
    // //             A /Int C <=Int B
    // //           #else
    // //             A /Int C <Int B
    // //           #fi
    // //     requires 0 <Int C
    // //       andBool 0 <=Int A
    // //     [simplification, concrete(A, C)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(11 <=Int 3 *Int 4)
    //       ListItem(12 <=Int 3 *Int 4)
    //       ListItem(13 <=Int 3 *Int 4)
    //       ListItem(15 <=Int 3 *Int 4)

    //       ListItem(11 <=Int 3 *Int X)
    //       ListItem(12 <=Int 3 *Int X)
    //       ListItem(13 <=Int 3 *Int Y)
    //       ListItem(15 <=Int 3 *Int Y)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(true)
    //       ListItem(false)
    //       ListItem(false)

    //       ListItem(true)
    //       ListItem(true)
    //       ListItem(false)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires Y <=Int 4 andBool 4 <=Int X

    // // rule A <Int C *Int B => A /Int C <Int B
    // //     requires 0 <Int C andBool 0 <=Int B
    // //     [simplification, concrete(A, C)]
    // claim
    //   <k>
    //     runSimplification(
    //       ListItem(11 <Int 3 *Int 4)
    //       ListItem(12 <Int 3 *Int 4)

    //       ListItem(11 <Int 3 *Int X)
    //       ListItem(12 <Int 3 *Int Y)
    //     ) => doneSimplification(
    //       ListItem(true)
    //       ListItem(false)

    //       ListItem(true)
    //       ListItem(false)
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>
    //   requires Y <=Int 4 andBool 4 <=Int X

    claim
      <k>
        runSimplification(
          ListItem(11 <Int 3 *Int 4)
          ListItem(12 <Int 3 *Int 4)

          ListItem(11 <Int 3 *Int X)
          ListItem(12 <Int 3 *Int Y)
        ) => doneSimplification(
          ListItem(true)
          ListItem(false)

          ListItem(true)
          ListItem(false)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires Y <=Int 4 andBool 4 <=Int X

endmodule
