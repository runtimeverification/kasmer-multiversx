```k
require "ceils.k"
require "elrond-configuration.md"
require "wasm-text.md"

module ELROND-IMPL
  imports CEILS
  imports ELROND-CONFIGURATION
  imports WASM-TEXT
  imports LIST-BYTESW-EXTENSIONS
  imports LIST-ESDTTRANSFER-EXTENSIONS
  imports MAP-BYTESW-TO-BYTESW
  imports MAP-BYTESW-TO-BYTESW-CURLY-BRACE
  imports MAP-INTW-TO-BYTESW
  imports MAP-INTW-TO-BYTESW-CURLY-BRACE
  imports MAP-INTW-TO-INTW
  imports MAP-INTW-TO-INTW-CURLY-BRACE

  syntax Intw ::= wrap(Int) | wrapI(Int)
  syntax Int ::= unwrap(Intw) [function, total]
  rule unwrap(wrap(V:Int)) => V

  syntax Bytesw ::= wrap(Bytes)
  syntax Bytes ::= unwrap(Bytesw) [function, total]
  rule unwrap(wrap(V:Bytes)) => V

  syntax Instr ::= "elrond_trap" "(" String ")"  [klabel(elrond_trap), symbol]

  syntax Instr ::= "elrondError"  [klabel(elrondError), symbol]
  syntax Instr ::= "elrondReverted"  [klabel(elrondReverted), symbol]

  rule  <instrs>
          elrond_trap("\"signalError\"") => elrondError
          ...
        </instrs>

  rule  <instrs>
          elrond_trap("\"managedSignalError\"") => elrondError
          ...
        </instrs>

  rule <instrs> (elrondError ~> _:K) => elrondReverted </instrs>
        <valstack> _:ValStack => .ValStack </valstack>
        <locals> _:Map => .Map </locals>

  rule  <instrs>
          elrond_trap("\"managedAsyncCall\"") => .K
          ...
        </instrs>

  rule  <instrs>
          elrond_trap("\"managedUpgradeFromSourceContract\"") => .K
          ...
        </instrs>

  rule  <instrs>
          elrond_trap("\"managedDeployFromSourceContract\"") => .K
          ...
        </instrs>

  rule  <instrs>
          elrond_trap("\"managedTransferValueExecute\"") => i32.const 0
          ...
        </instrs>

  rule  <instrs>
          elrond_trap("\"managedTransferValueExecute\"") => i32.const 1
          ...
        </instrs>

  rule  <instrs>
          elrond_trap("\"managedWriteLog\"") => .K
          ...
        </instrs>

  // rule  <instrs>
  //         elrond_trap("\"smallIntGetUnsignedArgument\"") => i64.const ?Argument:Int
  //         ...
  //       </instrs>
  //   ensures 0 <=Int ?Argument andBool ?Argument <Int (1 <<Int 64)

  // rule  <instrs>
  //         elrond_trap("\"smallIntGetUnsignedArgument\"") => elrondError
  //         ...
  //       </instrs>

  rule  <instrs>
          elrond_trap("\"checkNoPayment\"") => .K
          ...
        </instrs>
        <payments>
            L:ListESDTTransfer
        </payments>
      requires size(L) ==Int 0

  rule  <instrs>
          elrond_trap("\"getNumESDTTransfers\"") => i32.const size(L)
          ...
        </instrs>
        <payments>
            L:ListESDTTransfer
        </payments>

  rule  <instrs>
          elrond_trap("\"checkNoPayment\"") => elrondError
          ...
        </instrs>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferSetBytes\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
                (1 |-> <i32> Ptr:Int)
                (2 |-> <i32> Len:Int)
            </locals>
            <mdata> Mem:Bytes </mdata>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[wrap(Handle) <- wrap(substrBytes(Mem, Ptr, Ptr +Int Len))]
            </buffers>
            ...
        </elrond>
    requires true
        #And #Ceil(substrBytes(Mem, Ptr, Ptr +Int Len))

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferSetBytes\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
                (1 |-> <i32> Ptr:Int)
                (2 |-> <i32> Len:Int)
            </locals>
            <mdata> Mem:Bytes </mdata>
            ...
        </wasm>
    requires true
        #And (#Not (#Ceil(substrBytes(Mem, Ptr, Ptr +Int Len))))

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferGetByteSlice\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> SourceHandle:Int)
                (1 |-> <i32> StartingPosition:Int)
                (2 |-> <i32> SliceLength:Int)
                (3 |-> <i32> ResultOffset:Int)
            </locals>
            <mdata>
              Mem:Bytes
              => #setBytesRange
                ( Mem, ResultOffset
                , substrBytes
                  ( unwrap(M[wrap(SourceHandle)] orDefault wrap(.Bytes))
                  , StartingPosition, SliceLength
                  )
                )
            </mdata>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
            </buffers>
            ...
        </elrond>
      requires wrap(SourceHandle) in_keys(M)
        #And #Ceil(#setBytesRange
                ( Mem, ResultOffset
                , substrBytes
                  ( unwrap(M[wrap(SourceHandle)] orDefault wrap(.Bytes))
                  , StartingPosition, SliceLength
                  )
                )
            )
  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferGetByteSlice\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _SourceHandle:Int)
                (1 |-> <i32> _StartingPosition:Int)
                (2 |-> <i32> _SliceLength:Int)
                (3 |-> <i32> _ResultOffset:Int)
            </locals>
            ...
        </wasm>
        [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferCopyByteSlice\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> SourceHandle:Int)
                (1 |-> <i32> StartingPosition:Int)
                (2 |-> <i32> SliceLength:Int)
                (3 |-> <i32> DestinationHandle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M
                  [ wrap(DestinationHandle)
                  <- wrap
                    ( substrBytes
                      ( unwrap(M[wrap(SourceHandle)] orDefault wrap(.Bytes))
                      , StartingPosition, SliceLength
                      )
                    )
                  ]
            </buffers>
            ...
        </elrond>
      requires wrap(SourceHandle) in_keys(M)
          #And #Ceil(
                  M [ wrap(DestinationHandle)
                    <- wrap
                      ( substrBytes
                        ( unwrap(M[wrap(SourceHandle)] orDefault wrap(.Bytes))
                        , StartingPosition, SliceLength
                        )
                      )
                    ]
              )
  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferCopyByteSlice\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _SourceHandle:Int)
                (1 |-> <i32> _StartingPosition:Int)
                (2 |-> <i32> _SliceLength:Int)
                (3 |-> <i32> _DestinationHandle:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferAppendBytes\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
                (1 |-> <i32> Ptr:Int)
                (2 |-> <i32> Len:Int)
            </locals>
            <mdata> Mem:Bytes </mdata>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[ wrap(Handle)
                    <-  wrap
                        ( unwrap(M [ wrap(Handle) ] orDefault wrap(.Bytes))
                          +Bytes substrBytes(Mem, Ptr, Ptr +Int Len)
                        )
                    ]
            </buffers>
            ...
        </elrond>
    requires true
        #And #Ceil(substrBytes(Mem, Ptr, Ptr +Int Len))
        #And {true #Equals wrap(Handle) in_keys(M)}

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferAppendBytes\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
                (1 |-> <i32> _Ptr:Int)
                (2 |-> <i32> _Len:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferAppend\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> HandleAccumulator:Int)
                (1 |-> <i32> HandleData:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[ wrap(HandleAccumulator)
                    <-  wrap
                        ( unwrap(M [ wrap(HandleAccumulator) ] orDefault wrap(.Bytes))
                          +Bytes unwrap(M [ wrap(HandleData) ] orDefault wrap(.Bytes))
                        )
                    ]
            </buffers>
            ...
        </elrond>
      requires wrap(HandleAccumulator) in_keys(M) andBool wrap(HandleData) in_keys(M)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferAppend\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _HandleAccumulator:Int)
                (1 |-> <i32> _HandleData:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                _M:MapIntwToBytesw
            </buffers>
            ...
        </elrond>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferEq\"")
              => i32.const
                #bool
                  (   unwrap(M [ wrap(Handle1) ] orDefault wrap(.Bytes))
                  ==K unwrap(M [ wrap(Handle2) ] orDefault wrap(.Bytes))
                  )
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle1:Int)
                (1 |-> <i32> Handle2:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
            </buffers>
            ...
        </elrond>
      requires wrap(Handle1) in_keys(M) andBool wrap(Handle2) in_keys(M)
  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferEq\"") => i32.const -1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle1:Int)
                (1 |-> <i32> _Handle2:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferStorageLoad\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> KeyHandle:Int)
                (1 |-> <i32> DestinationHandle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[ wrap(DestinationHandle)
                    <-  S[M[wrap(KeyHandle)] orDefault wrap(.Bytes)]
                        orDefault wrap(.Bytes)
                    ]
            </buffers>
            <storage>
                S:MapByteswToBytesw
            </storage>
            ...
        </elrond>
      requires wrap(KeyHandle) in_keys(M)
  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferStorageLoad\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _KeyHandle:Int)
                (1 |-> <i32> _DestinationHandle:Int)
            </locals>
            ...
        </wasm>
      [owise]
  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferStorageStore\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> KeyHandle:Int)
                (1 |-> <i32> SourceHandle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
            </buffers>
            <storage>
                S:MapByteswToBytesw
                => S[  M[wrap(KeyHandle)] orDefault wrap(.Bytes)
                    <- M[wrap(SourceHandle)] orDefault wrap(.Bytes)
                    ]
            </storage>
            ...
        </elrond>
      requires (wrap(KeyHandle) in_keys(M)) andBool (wrap(SourceHandle) in_keys(M))
      // TODO: SetStorage is fairly complex, this is not a proper implementation.
  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferStorageStore\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _KeyHandle:Int)
                (1 |-> <i32> _SourceHandle:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferNew\"") => i32.const ?NewHandle:Int
              ...
            </instrs>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[ wrap(?NewHandle) <- wrap(.Bytes)]
            </buffers>
            ...
        </elrond>
      ensures true
          andBool notBool wrap(?NewHandle) in_keys(M)
          andBool 0 <Int ?NewHandle
          andBool ?NewHandle <Int #pow(i32)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferNewFromBytes\"") => i32.const ?NewHandle:Int
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Ptr:Int)
                (1 |-> <i32> Len:Int)
            </locals>
            <mdata> Mem:Bytes </mdata>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[wrap(?NewHandle) <- wrap(substrBytes(Mem, Ptr, Ptr +Int Len))]
            </buffers>
            ...
        </elrond>
    requires true
        #And #Ceil(substrBytes(Mem, Ptr, Ptr +Int Len))
    ensures true
        andBool notBool wrap(?NewHandle) in_keys(M)
        andBool ?NewHandle >Int 0
        andBool ?NewHandle <Int #pow(i32)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferNewFromBytes\"") => i32.const -1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Ptr:Int)
                (1 |-> <i32> _Len:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferFromBigIntUnsigned\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> HandleBuffer:Int)
                (1 |-> <i32> HandleInt:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[ wrap(HandleBuffer)
                    <- wrap(Int2Bytes(unwrap(N [ wrap(HandleInt) ] orDefault wrap(0)), LE, Signed))
                    ]
            </buffers>
            <ints>
                N:MapIntwToIntw
            </ints>
            ...
        </elrond>
        requires wrap(HandleInt) in_keys(N)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferFromBigIntUnsigned\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _HandleBuffer:Int)
                (1 |-> <i32> _HandleInt:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferToBigIntUnsigned\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> HandleBuffer:Int)
                (1 |-> <i32> HandleInt:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
            </buffers>
            <ints>
                N:MapIntwToIntw
                => N[ wrap(HandleInt)
                    <- wrap
                      ( Bytes2Int
                        ( unwrap(M [ wrap(HandleBuffer) ] orDefault wrap(.Bytes))
                        , LE, Signed  // TODO: Is this the right thing to do? The function name says otherwise
                        )
                      )
                    ]
            </ints>
            ...
        </elrond>
        requires wrap(HandleBuffer) in_keys(M)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferToBigIntUnsigned\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _HandleBuffer:Int)
                (1 |-> <i32> _HandleInt:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              // TODO: Should append to the returned result, or something like that.
              elrond_trap("\"mBufferFinish\"") => i32.const ?MBufferFinishResult:Int
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>
      ensures true
          andBool 0 <Int ?MBufferFinishResult
          andBool ?MBufferFinishResult <Int #pow(i32)

  rule  <wasm>
            <instrs>
              // TODO: Should append to the returned result, or something like that.
              elrond_trap("\"bigIntFinishUnsigned\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>

  rule  <wasm>
            <instrs>
              // TODO: Should append to the returned result, or something like that.
              elrond_trap("\"smallIntFinishUnsigned\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i64> _Value:Int)
            </locals>
            ...
        </wasm>

  rule  <wasm>
            <instrs>
              // TODO: Should append to the returned result, or something like that.
              elrond_trap("\"smallIntFinishSigned\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i64> _Value:Int)
            </locals>
            ...
        </wasm>

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferGetArgument\"") => i32.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> ArgId:Int)
                (1 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[wrap(Handle) <- L[ArgId] orDefault wrap(.Bytes)]
            </buffers>
            <arguments>
                L:ListBytesw
            </arguments>
            ...
        </elrond>
    requires 0 <=Int ArgId andBool ArgId <Int size(L)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferGetArgument\"") => i32.const 1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> ArgId:Int)
                (1 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <arguments>
                L:ListBytesw
            </arguments>
            ...
        </elrond>
    requires notBool (0 <=Int ArgId andBool ArgId <Int size(L))

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferGetLength\"") => i32.const lengthBytes(unwrap(M[wrap(Handle)] orDefault wrap(.Bytes)))
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
            </buffers>
            ...
        </elrond>
    requires wrap(Handle) in_keys(M)

  rule  <wasm>
            <instrs>
              elrond_trap("\"mBufferGetLength\"") => i32.const -1
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>
    [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntGetUnsignedArgument\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> ArgId:Int)
                (1 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw => M[wrap(Handle) <- L[ArgId] orDefault wrap(.Bytes)]
            </buffers>
            <arguments>
                L:ListBytesw
            </arguments>
            ...
        </elrond>
    requires true
        andBool 0 <=Int ArgId
        andBool ArgId <Int size(L)

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntGetUnsignedArgument\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> ArgId:Int)
                (1 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <arguments>
                L:ListBytesw
            </arguments>
            ...
        </elrond>
    requires notBool(
        0 <=Int ArgId
        andBool ArgId <Int size(L)
    )

  rule  <wasm>
            <instrs>
              elrond_trap("\"managedCaller\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw => M[wrap(Handle) <- wrap(Caller)]
            </buffers>
            <caller>
                Caller:Bytes
            </caller>
            ...
        </elrond>

  rule  <wasm>
            <instrs>
              elrond_trap("\"managedOwnerAddress\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw => M[wrap(Handle) <- wrap(Owner)]
            </buffers>
            <owner>
                Owner:Bytes
            </owner>
            ...
        </elrond>
      requires Owner =/=K .Bytes

  rule  <wasm>
            <instrs>
              elrond_trap("\"managedOwnerAddress\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>
      [owise]

  rule  <wasm>
            <instrs>
              elrond_trap("\"managedGetOriginalTxHash\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw => M[wrap(Handle) <- wrap(Data)]
            </buffers>
            <original-tx-hash>
                Data:Bytes
            </original-tx-hash>
            ...
        </elrond>

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntGetCallValue\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <ints>
                M:MapIntwToIntw => M[wrap(Handle) <- wrap(CallValue)]
            </ints>
            <call-value>
                CallValue:Int
            </call-value>
            ...
        </elrond>

  rule  <wasm>
            <instrs>
              elrond_trap("\"smallIntGetUnsignedArgument\"")
              => i64.const Bytes2Int(unwrap(L[ArgId] orDefault wrap(.Bytes)), LE, Signed)
              ...
            </instrs>
            <locals>
                (0 |-> <i32> ArgId:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <arguments>
                L:ListBytesw
            </arguments>
            ...
        </elrond>
    requires true
        andBool 0 <=Int ArgId
        andBool ArgId <Int size(L)
        // TODO: use a total function for list access.
        andBool 0 <=Int Bytes2Int(unwrap(L[ArgId] orDefault wrap(.Bytes)), LE, Signed)
        andBool Bytes2Int(unwrap(L[ArgId] orDefault wrap(.Bytes)), LE, Signed) <Int 2 ^Int 64

  rule  <wasm>
            <instrs>
              elrond_trap("\"smallIntGetUnsignedArgument\"")
              => i64.const 0
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _ArgId:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <arguments>
                _L:ListBytesw
            </arguments>
            ...
        </elrond>
      [owise]
    // requires notBool(
    //     0 <=Int ArgId
    //     andBool ArgId <Int size(L)
    //     // TODO: use a total function for list access.
    //     andBool 0 <=Int Bytes2Int(unwrap(L[ArgId] orDefault wrap(.Bytes)), LE, Signed)
    //     andBool Bytes2Int(unwrap(L[ArgId] orDefault wrap(.Bytes)), LE, Signed) <Int 2 ^Int 64
    // )

  rule  <wasm>
            <instrs>
              elrond_trap("\"getNumArguments\"") => i32.const size(L)
              ...
            </instrs>
            <locals> .Map </locals>
            ...
        </wasm>
        <elrond>
            <arguments>
                L:ListBytesw
            </arguments>
            ...
        </elrond>

  rule  <wasm>
            <instrs>
              // TODO: Should append to the returned result, or something like that.
              elrond_trap("\"getGasLeft\"") => i64.const ?NewGasLeft
              ...
            </instrs>
            ...
        </wasm>
        <elrond>
            <gas>
                PreviousGasLeft:Int => ?NewGasLeft
            </gas>
            ...
        </elrond>
      ensures true
          andBool ?NewGasLeft <Int PreviousGasLeft
          andBool 0 <=Int ?NewGasLeft

  rule <instrs>
          #import(MOD, Name, #funcDesc(... id: OID, type: TIDX))
        => #func(... type: TIDX, locals: [ .ValTypes ],
                body: elrond_trap(#parseWasmString(Name)) return .Instrs,
                metadata: #meta(... id: OID, localIds: .Map))
              ...
        </instrs>
    requires MOD ==K #token("\"env\"", "WasmStringToken")

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntSetInt64\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
                (1 |-> <i64> Value:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <buffers>
                M:MapIntwToBytesw
                => M[ wrap(Handle)
                    <-  wrap(Int2Bytes(Value, LE, Signed))
                    ]
            </buffers>
            ...
        </elrond>

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntAdd\"") => .K
              ...
            </instrs>
            <locals>
                (0 |-> <i32> HandleDest:Int)
                (1 |-> <i32> Handle1:Int)
                (2 |-> <i32> Handle2:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <ints>
                M:MapIntwToIntw
                => M[ wrap(HandleDest)
                    <-  wrap
                        ( unwrap(M[wrap(Handle1)] orDefault wrap(0))
                        +Int unwrap(M[wrap(Handle2)] orDefault wrap(0))
                        )
                    ]
            </ints>
            ...
        </elrond>

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntSign\"")
              => i32.const
                #if unwrap(M[wrap(Handle)] orDefault wrap(0)) <Int 0
                #then -1
                #else #if unwrap(M[wrap(Handle)] orDefault wrap(0)) >Int 0
                #then 1
                #else 0
                #fi #fi
              ...
            </instrs>
            <locals>
                (0 |-> <i32> Handle:Int)
            </locals>
            ...
        </wasm>
        <elrond>
            <ints>
                M:MapIntwToIntw
            </ints>
            ...
        </elrond>
      requires wrap(Handle) in_keys(M)

  rule  <wasm>
            <instrs>
              elrond_trap("\"bigIntSign\"")
              => i32.const -2
              ...
            </instrs>
            <locals>
                (0 |-> <i32> _Handle:Int)
            </locals>
            ...
        </wasm>
      [owise]

  // syntax IdentifierToken ::= r"\\$[0-9a-zA-Z!$%&'*+/<>?_`|~=:\\@^.-]+" [token]
  // syntax  ::= "$__stack_pointer" [token]
endmodule
```