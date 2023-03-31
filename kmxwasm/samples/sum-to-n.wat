(module
  (type (;0;) (func (param i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32)))
  (type (;2;) (func (param i32) (result i64)))
  (type (;3;) (func (result i32)))
  (type (;4;) (func (param i32 i32)))
  (type (;5;) (func))
  (type (;6;) (func (param i64)))
  (type (;7;) (func (param i32) (result i32)))
  (import "env" "mBufferAppendBytes" (func $mBufferAppendBytes (type 0)))
  (import "env" "managedSignalError" (func $managedSignalError (type 1)))
  (import "env" "smallIntGetUnsignedArgument" (func $smallIntGetUnsignedArgument (type 2)))
  (import "env" "getNumArguments" (func $getNumArguments (type 3)))
  (import "env" "signalError" (func $signalError (type 4)))
  (import "env" "mBufferSetBytes" (func $mBufferSetBytes (type 0)))
  (import "env" "checkNoPayment" (func $checkNoPayment (type 5)))
  (import "env" "smallIntFinishUnsigned" (func $smallIntFinishUnsigned (type 6)))
  (func $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h6acf14cca5221807E (type 5)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h69ad1e4e5254fa27E
    local.tee 0
    i32.const 1048641
    i32.const 5
    call $mBufferAppendBytes
    drop
    local.get 0
    i32.const 1048599
    i32.const 3
    call $mBufferAppendBytes
    drop
    local.get 0
    i32.const 1048627
    i32.const 14
    call $mBufferAppendBytes
    drop
    local.get 0
    call $managedSignalError
    unreachable)
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h69ad1e4e5254fa27E (type 3) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h547341ec92ec4ed2E
    local.tee 0
    i32.const 1048576
    i32.const 23
    call $mBufferSetBytes
    drop
    local.get 0)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h823c8a2b7d0a81e9E (type 3) (result i32)
    (local i64)
    block  ;; label = @1
      i32.const 0
      call $smallIntGetUnsignedArgument
      local.tee 0
      i64.const 4294967296
      i64.lt_u
      br_if 0 (;@1;)
      call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h6acf14cca5221807E
      unreachable
    end
    local.get 0
    i32.wrap_i64)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hf8bde28951045a70E (type 1) (param i32)
    block  ;; label = @1
      call $getNumArguments
      local.get 0
      i32.ne
      br_if 0 (;@1;)
      return
    end
    i32.const 1048602
    i32.const 25
    call $signalError
    unreachable)
  (func $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h547341ec92ec4ed2E (type 3) (result i32)
    (local i32)
    i32.const 0
    i32.const 0
    i32.load offset=1048648
    i32.const -1
    i32.add
    local.tee 0
    i32.store offset=1048648
    local.get 0)
  (func $_ZN8sum_to_n6SumToN12sum_function17he26ee326a264e179E (type 7) (param i32) (result i32)
    (local i32 i32)
    i32.const 0
    local.set 1
    i32.const 1
    local.set 2
    loop (result i32)  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 0
        i32.le_u
        br_if 0 (;@2;)
        local.get 1
        return
      end
      local.get 1
      local.get 2
      i32.add
      local.set 1
      local.get 2
      i32.const 1
      i32.add
      local.set 2
      br 0 (;@1;)
    end)
  (func $init (type 5)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hf8bde28951045a70E)
  (func $sum_endpoint (type 5)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hf8bde28951045a70E
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h823c8a2b7d0a81e9E
    call $_ZN8sum_to_n6SumToN12sum_function17he26ee326a264e179E
    i64.extend_i32_u
    call $smallIntFinishUnsigned)
  (func $callBack (type 5))
  (table (;0;) 1 1 funcref)
  (memory (;0;) 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1048652))
  (global (;2;) i32 (i32.const 1048656))
  (export "memory" (memory 0))
  (export "init" (func $init))
  (export "sum_endpoint" (func $sum_endpoint))
  (export "callBack" (func $callBack))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2))
  (data $.rodata (i32.const 1048576) "argument decode error (): wrong number of argumentsinput too longvalue")
  (data $.data (i32.const 1048648) "\9c\ff\ff\ff"))
