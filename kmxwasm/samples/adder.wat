(module
  (type (;0;) (func (param i32 i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32 i32 i32)))
  (type (;7;) (func (param i32) (result i32)))
  (import "env" "bigIntGetUnsignedArgument" (func $bigIntGetUnsignedArgument (type 0)))
  (import "env" "getNumArguments" (func $getNumArguments (type 1)))
  (import "env" "signalError" (func $signalError (type 0)))
  (import "env" "mBufferStorageLoad" (func $mBufferStorageLoad (type 2)))
  (import "env" "mBufferToBigIntUnsigned" (func $mBufferToBigIntUnsigned (type 2)))
  (import "env" "mBufferFromBigIntUnsigned" (func $mBufferFromBigIntUnsigned (type 2)))
  (import "env" "mBufferStorageStore" (func $mBufferStorageStore (type 2)))
  (import "env" "mBufferSetBytes" (func $mBufferSetBytes (type 3)))
  (import "env" "checkNoPayment" (func $checkNoPayment (type 4)))
  (import "env" "bigIntFinishUnsigned" (func $bigIntFinishUnsigned (type 5)))
  (import "env" "bigIntAdd" (func $bigIntAdd (type 6)))
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h927f121208bfe992E (type 1) (result i32)
    (local i32)
    i32.const 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h6da5a5ab93b161d4E
    local.tee 0
    call $bigIntGetUnsignedArgument
    local.get 0)
  (func $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h6da5a5ab93b161d4E (type 1) (result i32)
    (local i32)
    i32.const 0
    i32.const 0
    i32.load offset=1048604
    i32.const -1
    i32.add
    local.tee 0
    i32.store offset=1048604
    local.get 0)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h54c94c2757d60471E (type 5) (param i32)
    block  ;; label = @1
      call $getNumArguments
      local.get 0
      i32.ne
      br_if 0 (;@1;)
      return
    end
    i32.const 1048576
    i32.const 25
    call $signalError
    unreachable)
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h58545b136ddc1d41E (type 7) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h6da5a5ab93b161d4E
    local.tee 1
    call $mBufferStorageLoad
    drop
    local.get 1
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h6da5a5ab93b161d4E
    local.tee 0
    call $mBufferToBigIntUnsigned
    drop
    local.get 0)
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17h566089ac9806bb4cE (type 0) (param i32 i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h6da5a5ab93b161d4E
    local.tee 2
    local.get 1
    call $mBufferFromBigIntUnsigned
    drop
    local.get 0
    local.get 2
    call $mBufferStorageStore
    drop)
  (func $_ZN34_$LT$C$u20$as$u20$adder..Adder$GT$3sum17h97e016ff19bb968eE (type 1) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h6da5a5ab93b161d4E
    local.tee 0
    i32.const 1048601
    i32.const 3
    call $mBufferSetBytes
    drop
    local.get 0)
  (func $init (type 4)
    (local i32)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h54c94c2757d60471E
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h927f121208bfe992E
    local.set 0
    call $_ZN34_$LT$C$u20$as$u20$adder..Adder$GT$3sum17h97e016ff19bb968eE
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17h566089ac9806bb4cE)
  (func $getSum (type 4)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h54c94c2757d60471E
    call $_ZN34_$LT$C$u20$as$u20$adder..Adder$GT$3sum17h97e016ff19bb968eE
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h58545b136ddc1d41E
    call $bigIntFinishUnsigned)
  (func $add (type 4)
    (local i32 i32 i32)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h54c94c2757d60471E
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h927f121208bfe992E
    local.set 0
    call $_ZN34_$LT$C$u20$as$u20$adder..Adder$GT$3sum17h97e016ff19bb968eE
    local.tee 1
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h58545b136ddc1d41E
    local.tee 2
    local.get 2
    local.get 0
    call $bigIntAdd
    local.get 1
    local.get 2
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17h566089ac9806bb4cE)
  (func $callBack (type 4))
  (table (;0;) 1 1 funcref)
  (memory (;0;) 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1048608))
  (global (;2;) i32 (i32.const 1048608))
  (export "memory" (memory 0))
  (export "init" (func $init))
  (export "getSum" (func $getSum))
  (export "add" (func $add))
  (export "callBack" (func $callBack))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2))
  (data $.rodata (i32.const 1048576) "wrong number of argumentssum")
  (data $.data (i32.const 1048604) "\9c\ff\ff\ff"))
