module SUM-TO-N-SPEC
  imports ELROND-WASM

  claim
      <k>
        .K
      </k>
      <instrs>
        ( #loop
          ( [ i32  .ValTypes ]
          , #block
            ( [ .ValTypes ]
            , #local.get ( 2 )
              #local.get ( 0 )
              i32 . le_u
              #br_if ( 0 )
                #local.get ( 1 )
                return
                .EmptyStmts
            , .Int
            )
            #local.get ( 1 )
            #local.get ( 2 )
            i32 . add
            #local.set ( 1 )
            #local.get ( 2 )
            i32 . const 1
            i32 . add
            #local.set ( 2 )
            #br ( 0 )
            .EmptyStmts
          , .Int
          )
          => return
        )
        ~> _MyOtherInstructions:K
      </instrs>
      <valstack>
        _Stack:ValStack => <i32> Sum : .ValStack
      </valstack>
      <locals>
        0 |-> <i32> LoopLimit:Int
        1 |-> <i32> Sum:Int
        2 |-> <i32> N:Int
        _MyLocals:Map
      </locals>
      <commands>
        .K
      </commands>
  requires LoopLimit <Int N

  claim
      <k>
        .K
      </k>
      <instrs>
        ( #loop
          ( [ i32  .ValTypes ]
          , #block
            ( [ .ValTypes ]
            , #local.get ( 2 )
              #local.get ( 0 )
              i32 . le_u
              #br_if ( 0 )
                #local.get ( 1 )
                return
                .EmptyStmts
            , .Int
            )
            #local.get ( 1 )
            #local.get ( 2 )
            i32 . add
            #local.set ( 1 )
            #local.get ( 2 )
            i32 . const 1
            i32 . add
            #local.set ( 2 )
            #br ( 0 )
            .EmptyStmts
          , .Int
          )
          => return
        )
        ~> _MyOtherInstructions:K
      </instrs>
      <valstack>
        _Stack:ValStack => <i32> ?Sum : .ValStack
      </valstack>
      <locals>
        0 |-> <i32> LoopLimit:Int
        1 |-> <i32> (Sum:Int => ?Sum)
        2 |-> <i32> (N:Int => (LoopLimit +Int 1))
        _MyLocals:Map
      </locals>
      <commands>
        .K
      </commands>
  requires true
      andBool 0 <=Int N
      andBool N <=Int LoopLimit
      andBool LoopLimit <Int #pow(i32) -Int 1
  ensures true
      andBool ?Sum ==Int (Sum +Int LoopLimit *Int (LoopLimit +Int 1) /Int 2 -Int N *Int (N -Int 1) /Int 2) modInt #pow(i32)

  claim
      <k>
        .K
      </k>
      <instrs>
        ( #loop
          ( [ i32  .ValTypes ]
          , #block
            ( [ .ValTypes ]
            , #local.get ( 2 )
              #local.get ( 0 )
              i32 . le_u
              #br_if ( 0 )
                #local.get ( 1 )
                return
                .EmptyStmts
            , .Int
            )
            #local.get ( 1 )
            #local.get ( 2 )
            i32 . add
            #local.set ( 1 )
            #local.get ( 2 )
            i32 . const 1
            i32 . add
            #local.set ( 2 )
            #br ( 0 )
            .EmptyStmts
          , .Int
          )
          => infiniteLoop
        )
        ~> _MyOtherInstructions:K
      </instrs>
      <valstack>
        _Stack:ValStack => .ValStack
      </valstack>
      <locals>
        0 |-> <i32> LoopLimit:Int
        1 |-> <i32> (_Sum:Int => ?_Sum:Int)
        2 |-> <i32> (N:Int => ?_N:Int)
        _MyLocals:Map
      </locals>
      <commands>
        .K
      </commands>
  requires true
      andBool 0 <=Int N
      andBool N <=Int LoopLimit
      andBool LoopLimit ==Int #pow(i32) -Int 1
endmodule
