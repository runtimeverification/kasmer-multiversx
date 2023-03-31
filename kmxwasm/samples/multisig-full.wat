(module
  (type (;0;) (func (param i32 i64)))
  (type (;1;) (func (param i32 i32 i32)))
  (type (;2;) (func (param i32 i32)))
  (type (;3;) (func (param i32 i32) (result i32)))
  (type (;4;) (func (result i32)))
  (type (;5;) (func (param i32) (result i32)))
  (type (;6;) (func (param i32)))
  (type (;7;) (func (result i64)))
  (type (;8;) (func (param i32 i32 i32) (result i32)))
  (type (;9;) (func (param i32) (result i64)))
  (type (;10;) (func (param i64)))
  (type (;11;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;12;) (func (param i32 i32 i32 i32)))
  (type (;13;) (func))
  (type (;14;) (func (param i32 i32 i64 i32 i32) (result i32)))
  (type (;15;) (func (param i32 i64 i32 i32 i32 i32 i32)))
  (type (;16;) (func (param i64 i32 i32 i32 i32 i32 i32) (result i32)))
  (type (;17;) (func (param i32 i32 i32 i32 i32)))
  (type (;18;) (func (param i32 i32) (result i64)))
  (type (;19;) (func (param i32 i64 i32)))
  (type (;20;) (func (param i32 i32 i32 i64 i32 i32)))
  (type (;21;) (func (param i32 i32 i32 i32 i32 i32)))
  (import "env" "bigIntSetInt64" (func $bigIntSetInt64 (type 0)))
  (import "env" "bigIntAdd" (func $bigIntAdd (type 1)))
  (import "env" "signalError" (func $signalError (type 2)))
  (import "env" "mBufferAppend" (func $mBufferAppend (type 3)))
  (import "env" "mBufferNew" (func $mBufferNew (type 4)))
  (import "env" "mBufferFinish" (func $mBufferFinish (type 5)))
  (import "env" "managedCaller" (func $managedCaller (type 6)))
  (import "env" "getGasLeft" (func $getGasLeft (type 7)))
  (import "env" "bigIntGetCallValue" (func $bigIntGetCallValue (type 6)))
  (import "env" "mBufferGetArgument" (func $mBufferGetArgument (type 3)))
  (import "env" "mBufferAppendBytes" (func $mBufferAppendBytes (type 8)))
  (import "env" "managedSignalError" (func $managedSignalError (type 6)))
  (import "env" "smallIntGetUnsignedArgument" (func $smallIntGetUnsignedArgument (type 9)))
  (import "env" "mBufferGetLength" (func $mBufferGetLength (type 5)))
  (import "env" "bigIntGetUnsignedArgument" (func $bigIntGetUnsignedArgument (type 2)))
  (import "env" "getNumArguments" (func $getNumArguments (type 4)))
  (import "env" "smallIntFinishUnsigned" (func $smallIntFinishUnsigned (type 10)))
  (import "env" "managedGetOriginalTxHash" (func $managedGetOriginalTxHash (type 6)))
  (import "env" "mBufferToBigIntUnsigned" (func $mBufferToBigIntUnsigned (type 3)))
  (import "env" "mBufferGetByteSlice" (func $mBufferGetByteSlice (type 11)))
  (import "env" "mBufferSetBytes" (func $mBufferSetBytes (type 8)))
  (import "env" "mBufferFromBigIntUnsigned" (func $mBufferFromBigIntUnsigned (type 3)))
  (import "env" "mBufferCopyByteSlice" (func $mBufferCopyByteSlice (type 11)))
  (import "env" "mBufferStorageLoad" (func $mBufferStorageLoad (type 3)))
  (import "env" "mBufferStorageStore" (func $mBufferStorageStore (type 3)))
  (import "env" "managedAsyncCall" (func $managedAsyncCall (type 12)))
  (import "env" "managedWriteLog" (func $managedWriteLog (type 2)))
  (import "env" "bigIntSign" (func $bigIntSign (type 5)))
  (import "env" "checkNoPayment" (func $checkNoPayment (type 13)))
  (import "env" "smallIntFinishSigned" (func $smallIntFinishSigned (type 10)))
  (import "env" "managedTransferValueExecute" (func $managedTransferValueExecute (type 14)))
  (import "env" "managedUpgradeFromSourceContract" (func $managedUpgradeFromSourceContract (type 15)))
  (import "env" "managedDeployFromSourceContract" (func $managedDeployFromSourceContract (type 16)))
  (import "env" "getNumESDTTransfers" (func $getNumESDTTransfers (type 4)))
  (import "env" "managedOwnerAddress" (func $managedOwnerAddress (type 6)))
  (import "env" "mBufferEq" (func $mBufferEq (type 3)))
  (import "env" "mBufferNewFromBytes" (func $mBufferNewFromBytes (type 3)))
  (func $_ZN103_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h47cb92ae47e84177E (type 5) (param i32) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 1
    i64.const 0
    call $bigIntSetInt64
    local.get 1
    local.get 1
    local.get 0
    call $bigIntAdd
    local.get 1)
  (func $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE (type 4) (result i32)
    (local i32)
    i32.const 0
    i32.const 0
    i32.load offset=1049996
    i32.const -1
    i32.add
    local.tee 0
    i32.store offset=1049996
    local.get 0)
  (func $_ZN106_$LT$$RF$str$u20$as$u20$multiversx_sc..contract_base..wrappers..error_helper..IntoSignalError$LT$M$GT$$GT$25signal_error_with_message17h4e380089a85be3dbE (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $signalError
    unreachable)
  (func $_ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h7c0a7b136baa41e0E (type 17) (param i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 1
        i32.lt_u
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        i32.le_u
        br_if 1 (;@1;)
        local.get 2
        local.get 4
        call $_ZN4core5slice5index22slice_index_order_fail17h2ea00a67370b9381E
        unreachable
      end
      local.get 1
      local.get 2
      call $_ZN4core5slice5index22slice_index_order_fail17h2ea00a67370b9381E
      unreachable
    end
    local.get 0
    local.get 2
    local.get 1
    i32.sub
    i32.store offset=4
    local.get 0
    local.get 3
    local.get 1
    i32.add
    i32.store)
  (func $_ZN4core5slice5index22slice_index_order_fail17h2ea00a67370b9381E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $_ZN4core5slice5index25slice_index_order_fail_rt17h9bf230a0cb7458abE
    unreachable)
  (func $_ZN108_$LT$multisig..action..ActionFullInfo$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_en..TopEncode$GT$24top_encode_or_handle_err17hc8c6ffa8e90456deE (type 2) (param i32 i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 1
    i32.load
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.set 3
    local.get 0
    i32.load
    local.get 3
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 0
                        i32.load16_u offset=8
                        br_table 0 (;@10;) 1 (;@9;) 2 (;@8;) 3 (;@7;) 4 (;@6;) 5 (;@5;) 6 (;@4;) 7 (;@3;) 8 (;@2;) 0 (;@10;)
                      end
                      i32.const 0
                      local.get 3
                      call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
                      br 8 (;@1;)
                    end
                    i32.const 1
                    local.get 3
                    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
                    local.get 3
                    local.get 0
                    i32.const 12
                    i32.add
                    i32.load
                    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
                    br 7 (;@1;)
                  end
                  i32.const 2
                  local.get 3
                  call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
                  local.get 3
                  local.get 0
                  i32.const 12
                  i32.add
                  i32.load
                  call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
                  br 6 (;@1;)
                end
                i32.const 3
                local.get 3
                call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
                local.get 3
                local.get 0
                i32.const 12
                i32.add
                i32.load
                call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
                br 5 (;@1;)
              end
              i32.const 4
              local.get 3
              call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
              local.get 0
              i32.const 12
              i32.add
              i32.load
              local.get 3
              call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
              br 4 (;@1;)
            end
            i32.const 5
            local.get 3
            call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
            local.get 0
            i32.const 12
            i32.add
            local.get 3
            call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h8c353c80baefa2c7E
            br 3 (;@1;)
          end
          i32.const 6
          local.get 3
          call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
          local.get 0
          i32.const 12
          i32.add
          local.get 3
          call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h8c353c80baefa2c7E
          br 2 (;@1;)
        end
        i32.const 7
        local.get 3
        call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
        local.get 0
        i32.const 12
        i32.add
        i32.load
        local.get 3
        call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hfff2ed967855fa09E
        local.get 3
        local.get 0
        i32.const 16
        i32.add
        i32.load
        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
        local.get 0
        i32.const 10
        i32.add
        i32.load16_u
        local.get 3
        call $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h281be725b09a0aafE
        local.get 0
        i32.const 20
        i32.add
        local.get 3
        call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hadc85f0f6ac98a41E
        br 1 (;@1;)
      end
      i32.const 8
      local.get 3
      call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E
      local.get 3
      local.get 0
      i32.const 12
      i32.add
      i32.load
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
      local.get 0
      i32.const 16
      i32.add
      i32.load
      local.get 3
      call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hfff2ed967855fa09E
      local.get 3
      local.get 0
      i32.const 20
      i32.add
      i32.load
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
      local.get 0
      i32.const 10
      i32.add
      i32.load16_u
      local.get 3
      call $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h281be725b09a0aafE
      local.get 0
      i32.const 24
      i32.add
      local.get 3
      call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hadc85f0f6ac98a41E
    end
    local.get 0
    i32.load offset=4
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$3len17h326da4425d923b01E
    local.get 3
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 0
    i32.load offset=4
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.set 4
    local.get 2
    local.get 0
    i32.const 4
    i32.add
    i32.store offset=24
    local.get 2
    local.get 4
    i32.store offset=20
    local.get 2
    i32.const 0
    i32.store offset=16
    block  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.const 8
        i32.add
        local.get 2
        i32.const 16
        i32.add
        call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
        local.get 2
        i32.load offset=8
        i32.eqz
        br_if 1 (;@1;)
        local.get 3
        local.get 2
        i32.load offset=12
        call $mBufferAppend
        drop
        br 0 (;@2;)
      end
    end
    local.get 1
    local.get 3
    i32.store
    local.get 2
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E (type 5) (param i32) (result i32)
    (local i32)
    call $mBufferNew
    local.tee 1
    local.get 0
    call $mBufferAppend
    drop
    local.get 1)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i32.const 24
    i32.shl
    local.get 0
    i32.const 8
    i32.shl
    i32.const 16711680
    i32.and
    i32.or
    local.get 0
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 0
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 1
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN13multiversx_sc5types7managed10codec_util31managed_buffer_nested_en_output172_$LT$impl$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$u20$for$u20$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$5write17hd217e87213a3c580E
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17h03f6723b4aca0fc0E (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i32.store8 offset=15
    local.get 1
    local.get 2
    i32.const 15
    i32.add
    i32.const 1
    call $_ZN13multiversx_sc5types7managed10codec_util31managed_buffer_nested_en_output172_$LT$impl$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$u20$for$u20$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$5write17hd217e87213a3c580E
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $mBufferAppend
    drop)
  (func $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h8c353c80baefa2c7E (type 2) (param i32 i32)
    local.get 1
    local.get 0
    i32.load
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
    local.get 0
    i32.load offset=4
    local.get 1
    call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hfff2ed967855fa09E
    local.get 0
    i32.load offset=8
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h22993edac1794701E
    local.get 0
    i32.const 12
    i32.add
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hadc85f0f6ac98a41E)
  (func $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hfff2ed967855fa09E (type 2) (param i32 i32)
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17h89a6c34ce225ef7cE
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h22993edac1794701E)
  (func $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h281be725b09a0aafE (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i32.const 8
    i32.shl
    local.get 0
    i32.const 65280
    i32.and
    i32.const 8
    i32.shr_u
    i32.or
    i32.store16 offset=14
    local.get 1
    local.get 2
    i32.const 14
    i32.add
    i32.const 2
    call $_ZN13multiversx_sc5types7managed10codec_util31managed_buffer_nested_en_output172_$LT$impl$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$u20$for$u20$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$5write17hd217e87213a3c580E
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hadc85f0f6ac98a41E (type 2) (param i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 0
    i32.load
    local.tee 3
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$3len17h326da4425d923b01E
    local.get 1
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 3
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.set 3
    local.get 2
    local.get 0
    i32.store offset=24
    local.get 2
    local.get 3
    i32.store offset=20
    local.get 2
    i32.const 0
    i32.store offset=16
    loop  ;; label = @1
      local.get 2
      i32.const 8
      i32.add
      local.get 2
      i32.const 16
      i32.add
      call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
      block  ;; label = @2
        local.get 2
        i32.load offset=8
        br_if 0 (;@2;)
        local.get 2
        i32.const 32
        i32.add
        global.set $__stack_pointer
        return
      end
      local.get 2
      i32.load offset=12
      local.get 1
      call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h22993edac1794701E
      br 0 (;@1;)
    end)
  (func $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$3len17h326da4425d923b01E (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    i32.const 2
    i32.shr_u)
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E (type 5) (param i32) (result i32)
    local.get 0
    call $mBufferGetLength)
  (func $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E (type 2) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load
        local.tee 3
        i32.const 4
        i32.add
        local.tee 4
        local.get 1
        i32.load offset=4
        i32.le_u
        br_if 0 (;@2;)
        i32.const 0
        local.set 1
        br 1 (;@1;)
      end
      local.get 1
      i32.load offset=8
      local.set 5
      local.get 2
      i32.const 0
      i32.store offset=12
      local.get 5
      i32.load
      local.get 3
      local.get 2
      i32.const 12
      i32.add
      i32.const 4
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE
      drop
      local.get 2
      i32.load offset=12
      local.set 3
      local.get 1
      local.get 4
      i32.store
      local.get 3
      i32.const 24
      i32.shl
      local.get 3
      i32.const 8
      i32.shl
      i32.const 16711680
      i32.and
      i32.or
      local.get 3
      i32.const 8
      i32.shr_u
      i32.const 65280
      i32.and
      local.get 3
      i32.const 24
      i32.shr_u
      i32.or
      i32.or
      local.set 3
      i32.const 1
      local.set 1
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN114_$LT$multisig..action..CallActionData$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17hb2e862b8d35fb96fE (type 2) (param i32 i32)
    (local i32 i32 i32)
    local.get 1
    call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
    local.set 2
    local.get 1
    call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$13read_big_uint17hc121fb850d163deaE
    local.set 3
    local.get 1
    call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$19read_managed_buffer17hd6a593392b36de8fE
    local.set 4
    local.get 0
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h6c68f2c57efc314aE
    i32.store offset=12
    local.get 0
    local.get 4
    i32.store offset=8
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE (type 5) (param i32) (result i32)
    local.get 0
    i32.const 32
    call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$27read_managed_buffer_of_size17h712fbec01e5437caE)
  (func $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$13read_big_uint17hc121fb850d163deaE (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$19read_managed_buffer17hd6a593392b36de8fE
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 0
    call $mBufferToBigIntUnsigned
    drop
    local.get 0)
  (func $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$19read_managed_buffer17hd6a593392b36de8fE (type 5) (param i32) (result i32)
    local.get 0
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17h2a0d7f7707de45aeE
    call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$27read_managed_buffer_of_size17h712fbec01e5437caE)
  (func $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h6c68f2c57efc314aE (type 5) (param i32) (result i32)
    (local i32 i32)
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17h2a0d7f7707de45aeE
    local.set 1
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 2
    loop (result i32)  ;; label = @1
      block  ;; label = @2
        local.get 1
        br_if 0 (;@2;)
        local.get 2
        return
      end
      local.get 2
      local.get 0
      call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$19read_managed_buffer17hd6a593392b36de8fE
      call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
      local.get 1
      i32.const -1
      i32.add
      local.set 1
      br 0 (;@1;)
    end)
  (func $_ZN115_$LT$$RF$$u5b$u8$u5d$$u20$as$u20$multiversx_sc..contract_base..wrappers..error_helper..IntoSignalError$LT$M$GT$$GT$25signal_error_with_message17he3343e71f734366bE (type 13)
    i32.const 1048910
    i32.const 27
    call $signalError
    unreachable)
  (func $_ZN115_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h3ddfd7b7e279dbcfE (type 5) (param i32) (result i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 2
    local.get 0
    i32.load
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.set 3
    local.get 1
    local.get 0
    i32.store offset=24
    local.get 1
    local.get 3
    i32.store offset=20
    local.get 1
    i32.const 0
    i32.store offset=16
    loop (result i32)  ;; label = @1
      local.get 1
      i32.const 8
      i32.add
      local.get 1
      i32.const 16
      i32.add
      call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
      block  ;; label = @2
        local.get 1
        i32.load offset=8
        br_if 0 (;@2;)
        local.get 1
        i32.const 32
        i32.add
        global.set $__stack_pointer
        local.get 2
        return
      end
      local.get 2
      local.get 1
      i32.load offset=12
      call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
      call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
      br 0 (;@1;)
    end)
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE (type 4) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 0
    i32.const 1049980
    i32.const 0
    call $mBufferSetBytes
    drop
    local.get 0)
  (func $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.const 24
    i32.shl
    local.get 1
    i32.const 8
    i32.shl
    i32.const 16711680
    i32.and
    i32.or
    local.get 1
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 1
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 0
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN122_$LT$multiversx_sc..storage..mappers..vec_mapper..Iter$LT$SA$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc8a4d288cd840622E (type 2) (param i32 i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load
        local.tee 2
        local.get 1
        i32.load offset=4
        i32.le_u
        br_if 0 (;@2;)
        i32.const 0
        local.set 3
        br 1 (;@1;)
      end
      i32.const 1
      local.set 3
      local.get 1
      local.get 2
      i32.const 1
      i32.add
      i32.store
      local.get 1
      i32.load offset=8
      i32.load
      local.get 2
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$13get_unchecked17h113f998e41294299E
      local.set 1
    end
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 3
    i32.store)
  (func $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$13get_unchecked17h113f998e41294299E (type 3) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E)
  (func $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17hb387eb5233ef3459E (type 5) (param i32) (result i32)
    (local i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 0
    i32.store16 offset=14
    local.get 0
    local.get 1
    i32.const 14
    i32.add
    i32.const 2
    call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h98c72a94d7838cc8E
    local.get 1
    i32.const 14
    i32.add
    i32.const 2
    call $_ZN19multiversx_sc_codec8num_conv23universal_decode_number17h3c05f972cc915e48E
    local.set 2
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 2
    i32.wrap_i64
    i32.const 1286
    i32.and)
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h98c72a94d7838cc8E (type 1) (param i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 8
      i32.add
      local.get 0
      i32.load
      local.get 1
      local.get 2
      call $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10load_slice17h06f227c05f23ac07E
      i32.eqz
      br_if 0 (;@1;)
      call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17h87156cd76d16ced9E
      unreachable
    end
    local.get 0
    local.get 0
    i32.load
    local.get 2
    i32.add
    i32.store)
  (func $_ZN19multiversx_sc_codec8num_conv23universal_decode_number17h3c05f972cc915e48E (type 18) (param i32 i32) (result i64)
    (local i64)
    i64.const 0
    local.set 2
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        i32.const -1
        i32.add
        local.set 1
        local.get 2
        i64.const 8
        i64.shl
        local.get 0
        i64.load8_u
        i64.or
        local.set 2
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        br 0 (;@2;)
      end
    end
    local.get 2)
  (func $_ZN13multiversx_sc5types7managed10codec_util31managed_buffer_nested_en_output172_$LT$impl$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$u20$for$u20$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$5write17hd217e87213a3c580E (type 1) (param i32 i32 i32)
    local.get 0
    local.get 1
    local.get 2
    call $mBufferAppendBytes
    drop)
  (func $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E (type 6) (param i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load8_u offset=1060004
        local.tee 2
        br_if 0 (;@2;)
        i32.const 0
        i32.const 1
        i32.store8 offset=1060004
        i32.const 0
        i32.const 0
        i32.store offset=1060000
        local.get 1
        i32.const 8
        i32.add
        i32.const 0
        call $_ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17hf722aa7772ee94dfE
        local.get 1
        i32.load offset=8
        local.get 1
        i32.load offset=12
        i32.const 1049980
        i32.const 0
        call $_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17hae135acb574359f2E
        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
        local.set 3
        br 1 (;@1;)
      end
      i32.const 1049980
      i32.const 0
      call $_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17hf1b34842d88e952aE
      local.set 3
    end
    local.get 0
    local.get 3
    i32.store
    local.get 0
    local.get 2
    i32.const 1
    i32.xor
    i32.store8 offset=4
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17hf722aa7772ee94dfE (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i32.const 8
    i32.add
    i32.const 1050000
    i32.const 10000
    local.get 1
    call $_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17h1f3c1b69343042ddE
    local.get 2
    i32.load offset=12
    local.set 1
    local.get 0
    local.get 2
    i32.load offset=8
    i32.store
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17hae135acb574359f2E (type 12) (param i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      local.get 3
      i32.ne
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      local.get 1
      call $memcpy
      drop
      return
    end
    local.get 1
    local.get 3
    call $_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17len_mismatch_fail17h65f99ae80ba3658aE
    unreachable)
  (func $_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17hf1b34842d88e952aE (type 3) (param i32 i32) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 2
    local.get 0
    local.get 1
    call $mBufferSetBytes
    drop
    local.get 2)
  (func $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$19into_managed_buffer17h28779c5acb692ec4E
    call $mBufferFinish
    drop)
  (func $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$19into_managed_buffer17h28779c5acb692ec4E (type 3) (param i32 i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.store8 offset=12
    local.get 2
    local.get 0
    i32.store offset=8
    local.get 2
    i32.const 8
    i32.add
    call $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$23flush_to_managed_buffer17hc1d7393cf7a6f3f6E
    local.get 2
    i32.load offset=8
    local.set 1
    block  ;; label = @1
      local.get 2
      i32.load8_u offset=12
      i32.eqz
      br_if 0 (;@1;)
      i32.const 0
      i32.const 0
      i32.store offset=1060000
      i32.const 0
      i32.const 0
      i32.store8 offset=1060004
    end
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 1)
  (func $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h9acead432087e203E (type 2) (param i32 i32)
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17h89a6c34ce225ef7cE
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hb4a53d74daad638bE)
  (func $_ZN13multiversx_sc5types7managed5basic8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17h89a6c34ce225ef7cE (type 5) (param i32) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 1
    local.get 0
    call $mBufferFromBigIntUnsigned
    drop
    local.get 1)
  (func $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hb4a53d74daad638bE (type 2) (param i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.tee 3
    i32.const 24
    i32.shl
    local.get 3
    i32.const 8
    i32.shl
    i32.const 16711680
    i32.and
    i32.or
    local.get 3
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 3
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 1
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$5write17h226448ae2ba0ffbbE
    local.get 1
    local.get 0
    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h22993edac1794701E (type 2) (param i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.tee 3
    i32.const 24
    i32.shl
    local.get 3
    i32.const 8
    i32.shl
    i32.const 16711680
    i32.and
    i32.or
    local.get 3
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 3
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 1
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN13multiversx_sc5types7managed10codec_util31managed_buffer_nested_en_output172_$LT$impl$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$u20$for$u20$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$5write17hd217e87213a3c580E
    local.get 1
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17h43dc5d04504fd327E (type 13)
    call $_ZN115_$LT$$RF$$u5b$u8$u5d$$u20$as$u20$multiversx_sc..contract_base..wrappers..error_helper..IntoSignalError$LT$M$GT$$GT$25signal_error_with_message17he3343e71f734366bE
    unreachable)
  (func $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $_ZN106_$LT$$RF$str$u20$as$u20$multiversx_sc..contract_base..wrappers..error_helper..IntoSignalError$LT$M$GT$$GT$25signal_error_with_message17h4e380089a85be3dbE
    unreachable)
  (func $_ZN13multiversx_sc13contract_base8wrappers16send_raw_wrapper23SendRawWrapper$LT$A$GT$14async_call_raw17h6cea37911a142161E (type 12) (param i32 i32 i32 i32)
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    call $_ZN26multiversx_sc_wasm_adapter3api13send_api_node127_$LT$impl$u20$multiversx_sc..api..send_api..SendApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$14async_call_raw17hd3e96e05a62a8857E
    unreachable)
  (func $_ZN26multiversx_sc_wasm_adapter3api13send_api_node127_$LT$impl$u20$multiversx_sc..api..send_api..SendApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$14async_call_raw17hd3e96e05a62a8857E (type 12) (param i32 i32 i32 i32)
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    call $managedAsyncCall
    unreachable)
  (func $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$10get_caller17h4351fc9dfbe955ceE (type 4) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 0
    call $managedCaller
    local.get 0)
  (func $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$12get_gas_left17h92f14e8828e57febE (type 7) (result i64)
    call $getGasLeft)
  (func $_ZN13multiversx_sc13contract_base8wrappers18call_value_wrapper25CallValueWrapper$LT$A$GT$10egld_value17h702a752be0274997E (type 4) (result i32)
    (local i32)
    block  ;; label = @1
      i32.const 0
      i32.load8_u offset=1060012
      local.tee 0
      i32.eqz
      br_if 0 (;@1;)
      i32.const -11
      i32.const 2147483647
      local.get 0
      select
      return
    end
    i32.const 0
    i32.const 1
    i32.store8 offset=1060012
    i32.const -11
    call $bigIntGetCallValue
    i32.const -11)
  (func $_ZN13multiversx_sc2io12arg_de_input24ArgDecodeInput$LT$AA$GT$17to_managed_buffer17h402ae2459a26bda6E (type 5) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 1
    call $mBufferGetArgument
    drop
    local.get 1)
  (func $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE (type 12) (param i32 i32 i32 i32)
    (local i32)
    i32.const 1048656
    i32.const 23
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 4
    local.get 0
    local.get 1
    call $mBufferAppendBytes
    drop
    local.get 4
    i32.const 1048679
    i32.const 3
    call $mBufferAppendBytes
    drop
    local.get 4
    local.get 2
    local.get 3
    call $mBufferAppendBytes
    drop
    local.get 4
    call $managedSignalError
    unreachable)
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E (type 3) (param i32 i32) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 2
    local.get 0
    local.get 1
    call $mBufferSetBytes
    drop
    local.get 2)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h161ad9414a385821E (type 5) (param i32) (result i32)
    local.get 0
    i32.const 1049491
    i32.const 9
    call $_ZN172_$LT$multiversx_sc..types..managed..multi_value..multi_value_encoded..MultiValueEncoded$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..multi..top_de_multi..TopDecodeMulti$GT$26multi_decode_or_handle_err17h0748d00bacadb313E)
  (func $_ZN172_$LT$multiversx_sc..types..managed..multi_value..multi_value_encoded..MultiValueEncoded$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..multi..top_de_multi..TopDecodeMulti$GT$26multi_decode_or_handle_err17h0748d00bacadb313E (type 8) (param i32 i32 i32) (result i32)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 3
    loop (result i32)  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        i32.const 0
        i32.load offset=1060008
        i32.lt_s
        br_if 0 (;@2;)
        local.get 3
        return
      end
      local.get 3
      local.get 0
      local.get 1
      local.get 2
      call $_ZN19multiversx_sc_codec5multi18top_de_multi_input19TopDecodeMultiInput10next_value17h818cdbeeec9b4e76E
      call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
      br 0 (;@1;)
    end)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h9c6df3612827bc63E (type 5) (param i32) (result i32)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 1
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.load
        i32.const 0
        i32.load offset=1060008
        i32.ge_s
        br_if 1 (;@1;)
        local.get 1
        local.get 0
        i32.const 1049268
        i32.const 5
        call $_ZN19multiversx_sc_codec5multi18top_de_multi_input19TopDecodeMultiInput10next_value17h818cdbeeec9b4e76E
        call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
        br 0 (;@2;)
      end
    end
    local.get 1)
  (func $_ZN19multiversx_sc_codec5multi18top_de_multi_input19TopDecodeMultiInput10next_value17h818cdbeeec9b4e76E (type 8) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $_ZN155_$LT$multiversx_sc..io..arg_loader_multi..EndpointDynArgLoader$LT$AA$GT$$u20$as$u20$multiversx_sc_codec..multi..top_de_multi_input..TopDecodeMultiInput$GT$16next_value_input17h53c0bf7ed79b13b3E
    call $_ZN13multiversx_sc2io12arg_de_input24ArgDecodeInput$LT$AA$GT$17to_managed_buffer17h402ae2459a26bda6E)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17hbfd9dd5c7f018d09E (type 2) (param i32 i32)
    (local i32 i64 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.const 1049300
          i32.const 11
          call $_ZN155_$LT$multiversx_sc..io..arg_loader_multi..EndpointDynArgLoader$LT$AA$GT$$u20$as$u20$multiversx_sc_codec..multi..top_de_multi_input..TopDecodeMultiInput$GT$16next_value_input17h53c0bf7ed79b13b3E
          call $smallIntGetUnsignedArgument
          local.tee 3
          i64.const 4294967296
          i64.ge_u
          br_if 0 (;@3;)
          local.get 3
          i32.wrap_i64
          local.tee 4
          i32.eqz
          br_if 1 (;@2;)
          local.get 4
          i32.const 28523
          i32.eq
          br_if 1 (;@2;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.load
              i32.const 0
              i32.load offset=1060008
              i32.lt_s
              br_if 0 (;@5;)
              call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
              local.set 5
              br 1 (;@4;)
            end
            local.get 1
            i32.const 1049300
            i32.const 11
            call $_ZN19multiversx_sc_codec5multi18top_de_multi_input19TopDecodeMultiInput10next_value17h818cdbeeec9b4e76E
            local.set 5
          end
          local.get 2
          local.get 4
          i32.store offset=4
          local.get 2
          i32.const 1
          i32.store
          i32.const 8
          local.set 1
          br 2 (;@1;)
        end
        i32.const 1049300
        i32.const 11
        i32.const 1048589
        i32.const 14
        call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE
        unreachable
      end
      local.get 1
      i32.const 1049300
      i32.const 11
      call $_ZN172_$LT$multiversx_sc..types..managed..multi_value..multi_value_encoded..MultiValueEncoded$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..multi..top_de_multi..TopDecodeMulti$GT$26multi_decode_or_handle_err17h0748d00bacadb313E
      local.set 5
      local.get 2
      i32.const 0
      i32.store
      i32.const 4
      local.set 1
    end
    local.get 2
    local.get 1
    i32.add
    local.get 5
    i32.store
    local.get 0
    local.get 2
    i64.load
    i64.store align=4
    local.get 0
    i32.const 8
    i32.add
    local.get 2
    i32.const 8
    i32.add
    i32.load
    i32.store
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN155_$LT$multiversx_sc..io..arg_loader_multi..EndpointDynArgLoader$LT$AA$GT$$u20$as$u20$multiversx_sc_codec..multi..top_de_multi_input..TopDecodeMultiInput$GT$16next_value_input17h53c0bf7ed79b13b3E (type 8) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 3
      i32.const 0
      i32.load offset=1060008
      i32.lt_s
      br_if 0 (;@1;)
      local.get 1
      local.get 2
      i32.const 1048719
      i32.const 17
      call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE
      unreachable
    end
    local.get 0
    local.get 3
    i32.const 1
    i32.add
    i32.store
    local.get 3)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17he03d13e4046ecfb7E (type 2) (param i32 i32)
    (local i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load
        i32.const 0
        i32.load offset=1060008
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 1
        local.set 2
        br 1 (;@1;)
      end
      local.get 1
      i32.const 1049500
      i32.const 12
      call $_ZN19multiversx_sc_codec5multi18top_de_multi_input19TopDecodeMultiInput10next_value17h818cdbeeec9b4e76E
      local.set 1
    end
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h2896e88c1eba2d5eE (type 5) (param i32) (result i32)
    (local i32 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 8
    i32.add
    local.get 0
    call $_ZN13multiversx_sc2io12arg_de_input24ArgDecodeInput$LT$AA$GT$17to_managed_buffer17h402ae2459a26bda6E
    call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$3new17h0f552cb474e5f85eE
    local.get 1
    i32.const 0
    i32.store16 offset=30
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 16
        i32.add
        local.get 1
        i32.load offset=8
        local.get 1
        i32.const 30
        i32.add
        i32.const 2
        call $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10load_slice17h06f227c05f23ac07E
        br_if 0 (;@2;)
        local.get 1
        i32.const 30
        i32.add
        i32.const 2
        call $_ZN19multiversx_sc_codec8num_conv23universal_decode_number17h3c05f972cc915e48E
        local.set 2
        local.get 1
        i32.load offset=12
        local.get 1
        i32.load offset=8
        i32.const 2
        i32.add
        i32.ne
        br_if 1 (;@1;)
        block  ;; label = @3
          local.get 1
          i32.const 24
          i32.add
          i32.load8_u
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          i32.const 0
          i32.store offset=1060000
          i32.const 0
          i32.const 0
          i32.store8 offset=1060004
        end
        local.get 1
        i32.const 32
        i32.add
        global.set $__stack_pointer
        local.get 2
        i32.wrap_i64
        i32.const 1286
        i32.and
        return
      end
      i32.const 1049572
      i32.const 13
      call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17hb9317474ee41ef89E
      unreachable
    end
    i32.const 1049572
    i32.const 13
    i32.const 1048589
    i32.const 14
    call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE
    unreachable)
  (func $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$3new17h0f552cb474e5f85eE (type 2) (param i32 i32)
    (local i32)
    local.get 1
    call $mBufferGetLength
    local.set 2
    local.get 0
    i32.const 16
    i32.add
    i32.const 0
    i32.store8
    local.get 0
    i32.const 12
    i32.add
    local.get 2
    i32.store
    local.get 0
    local.get 1
    i32.store offset=8
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store)
  (func $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10load_slice17h06f227c05f23ac07E (type 11) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u offset=8
          br_if 0 (;@3;)
          local.get 0
          i32.load
          local.tee 5
          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
          local.tee 6
          i32.const 10000
          i32.gt_u
          br_if 1 (;@2;)
          i32.const 0
          i32.load8_u offset=1060004
          i32.const 255
          i32.and
          br_if 1 (;@2;)
          i32.const 0
          local.get 6
          i32.store offset=1060000
          i32.const 0
          i32.const 1
          i32.store8 offset=1060004
          local.get 4
          i32.const 8
          i32.add
          local.get 6
          call $_ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17hf722aa7772ee94dfE
          local.get 5
          i32.const 0
          local.get 4
          i32.load offset=8
          local.get 4
          i32.load offset=12
          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE
          drop
          local.get 0
          i32.const 1
          i32.store8 offset=8
        end
        i32.const 1
        local.set 0
        local.get 3
        local.get 1
        i32.add
        local.tee 5
        i32.const 0
        i32.load offset=1060000
        i32.gt_u
        br_if 1 (;@1;)
        local.get 4
        local.get 1
        local.get 5
        call $_ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h432fb33eb11a2ceeE
        local.get 2
        local.get 3
        local.get 4
        i32.load
        local.get 4
        i32.load offset=4
        call $_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17hae135acb574359f2E
        i32.const 0
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      i32.const 0
      i32.store8 offset=8
      local.get 5
      local.get 1
      local.get 2
      local.get 3
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE
      local.set 0
    end
    local.get 4
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17hb9317474ee41ef89E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    i32.const 1048789
    i32.const 15
    call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE
    unreachable)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E (type 8) (param i32 i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      call $_ZN13multiversx_sc2io12arg_de_input24ArgDecodeInput$LT$AA$GT$17to_managed_buffer17h402ae2459a26bda6E
      local.tee 0
      call $mBufferGetLength
      i32.const 32
      i32.eq
      br_if 0 (;@1;)
      local.get 1
      local.get 2
      i32.const 1048875
      i32.const 16
      call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE
      unreachable
    end
    local.get 0)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h51e24df5548903bfE (type 4) (result i32)
    i32.const 1
    call $_ZN13multiversx_sc2io12arg_de_input24ArgDecodeInput$LT$AA$GT$17to_managed_buffer17h402ae2459a26bda6E)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE (type 8) (param i32 i32 i32) (result i32)
    (local i64)
    block  ;; label = @1
      local.get 0
      call $smallIntGetUnsignedArgument
      local.tee 3
      i64.const 4294967296
      i64.lt_u
      br_if 0 (;@1;)
      local.get 1
      local.get 2
      i32.const 1048589
      i32.const 14
      call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17h21450c616a25e7efE
      unreachable
    end
    local.get 3
    i32.wrap_i64)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc854eba343585468E (type 5) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 1
    call $bigIntGetUnsignedArgument
    local.get 1)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE (type 6) (param i32)
    block  ;; label = @1
      i32.const 0
      i32.load offset=1060008
      local.get 0
      i32.gt_s
      br_if 0 (;@1;)
      return
    end
    i32.const 1048736
    i32.const 18
    call $signalError
    unreachable)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4e6e03f38a0e438bE (type 2) (param i32 i32)
    block  ;; label = @1
      local.get 1
      local.get 0
      i32.lt_u
      br_if 0 (;@1;)
      return
    end
    i32.const 1048736
    i32.const 18
    call $signalError
    unreachable)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE (type 6) (param i32)
    block  ;; label = @1
      call $getNumArguments
      local.get 0
      i32.ne
      br_if 0 (;@1;)
      return
    end
    i32.const 1048754
    i32.const 25
    call $signalError
    unreachable)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E (type 6) (param i32)
    block  ;; label = @1
      i32.const 0
      i32.load offset=1060008
      local.get 0
      i32.lt_s
      br_if 0 (;@1;)
      return
    end
    i32.const 1048719
    i32.const 17
    call $signalError
    unreachable)
  (func $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE (type 13)
    i32.const 0
    call $getNumArguments
    i32.store offset=1060008)
  (func $_ZN13multiversx_sc2io6finish12finish_multi17h03e27614146b8951E (type 6) (param i32)
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3len17h49d4212332c00331E
    i64.extend_i32_u
    call $smallIntFinishUnsigned)
  (func $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3len17h49d4212332c00331E (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E)
  (func $_ZN13multiversx_sc2io6finish12finish_multi17h21b3b2efb251f986E (type 6) (param i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 0
    i32.load
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.set 2
    local.get 1
    local.get 0
    i32.store offset=24
    local.get 1
    local.get 2
    i32.store offset=20
    local.get 1
    i32.const 0
    i32.store offset=16
    block  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 8
        i32.add
        local.get 1
        i32.const 16
        i32.add
        call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
        local.get 1
        i32.load offset=8
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        i32.load offset=12
        call $mBufferFinish
        drop
        br 0 (;@2;)
      end
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc5types11interaction10async_call19AsyncCall$LT$SA$GT$13call_and_exit17h155fa10fab4fa1f5E (type 6) (param i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      local.get 0
      i32.load offset=16
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      call $_ZN13multiversx_sc5types11interaction16callback_closure22cb_closure_storage_key17hc1c8d77daac2d192E
      local.set 3
      local.get 1
      call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
      local.get 1
      local.get 1
      i32.load8_u offset=4
      i32.store8 offset=12
      local.get 1
      local.get 1
      i32.load
      i32.store offset=8
      local.get 0
      i32.const 20
      i32.add
      i32.load
      local.tee 4
      local.get 1
      i32.const 8
      i32.add
      call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h3dd180332d7387d9E
      local.get 1
      i32.const 8
      i32.add
      local.get 2
      local.get 4
      call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$5write17h226448ae2ba0ffbbE
      local.get 0
      i32.const 24
      i32.add
      local.get 1
      i32.const 8
      i32.add
      call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E
      local.get 3
      local.get 1
      i32.load offset=8
      local.get 1
      i32.load8_u offset=12
      call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
    end
    local.get 0
    call $_ZN13multiversx_sc5types11interaction10async_call19AsyncCall$LT$SA$GT$29call_and_exit_ignore_callback17hb881592f70a87b48E
    unreachable)
  (func $_ZN13multiversx_sc5types11interaction16callback_closure22cb_closure_storage_key17hc1c8d77daac2d192E (type 4) (result i32)
    (local i32 i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 0
    call $managedGetOriginalTxHash
    i32.const 1048779
    i32.const 10
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 1
    local.get 0
    call $mBufferAppend
    drop
    local.get 1)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h3dd180332d7387d9E (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i32.const 24
    i32.shl
    local.get 0
    i32.const 8
    i32.shl
    i32.const 16711680
    i32.and
    i32.or
    local.get 0
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 0
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 1
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$5write17h226448ae2ba0ffbbE
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$5write17h226448ae2ba0ffbbE (type 1) (param i32 i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u offset=4
          i32.eqz
          br_if 0 (;@3;)
          i32.const 10000
          i32.const 0
          i32.load offset=1060000
          local.tee 4
          i32.sub
          local.get 2
          i32.lt_u
          br_if 1 (;@2;)
          local.get 3
          i32.const 8
          i32.add
          local.get 4
          local.get 4
          local.get 2
          i32.add
          local.tee 0
          call $_ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h4669ceec602b3051E
          local.get 3
          i32.load offset=8
          local.get 3
          i32.load offset=12
          local.get 1
          local.get 2
          call $_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17hae135acb574359f2E
          i32.const 0
          local.get 0
          i32.store offset=1060000
          br 2 (;@1;)
        end
        local.get 0
        i32.load
        local.get 1
        local.get 2
        call $mBufferAppendBytes
        drop
        br 1 (;@1;)
      end
      local.get 0
      call $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$23flush_to_managed_buffer17hc1d7393cf7a6f3f6E
      local.get 0
      i32.load
      local.get 1
      local.get 2
      call $mBufferAppendBytes
      drop
    end
    local.get 3
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E (type 2) (param i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 0
    i32.load
    local.tee 3
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$3len17h326da4425d923b01E
    local.get 1
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h3dd180332d7387d9E
    local.get 3
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.set 3
    local.get 2
    local.get 0
    i32.store offset=24
    local.get 2
    local.get 3
    i32.store offset=20
    local.get 2
    i32.const 0
    i32.store offset=16
    loop  ;; label = @1
      local.get 2
      i32.const 8
      i32.add
      local.get 2
      i32.const 16
      i32.add
      call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
      block  ;; label = @2
        local.get 2
        i32.load offset=8
        br_if 0 (;@2;)
        local.get 2
        i32.const 32
        i32.add
        global.set $__stack_pointer
        return
      end
      local.get 2
      i32.load offset=12
      local.get 1
      call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hb4a53d74daad638bE
      br 0 (;@1;)
    end)
  (func $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E (type 1) (param i32 i32 i32)
    local.get 0
    local.get 1
    local.get 2
    call $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$19into_managed_buffer17h28779c5acb692ec4E
    call $mBufferStorageStore
    drop)
  (func $_ZN13multiversx_sc5types11interaction10async_call19AsyncCall$LT$SA$GT$29call_and_exit_ignore_callback17hb881592f70a87b48E (type 6) (param i32)
    local.get 0
    i32.load
    local.get 0
    i32.load offset=4
    local.get 0
    i32.load offset=8
    local.get 0
    i32.load offset=12
    call $_ZN13multiversx_sc13contract_base8wrappers16send_raw_wrapper23SendRawWrapper$LT$A$GT$14async_call_raw17h6cea37911a142161E
    unreachable)
  (func $_ZN13multiversx_sc5types11interaction16callback_closure32CallbackClosureForDeser$LT$M$GT$7matcher17h9aa0086f5c7eb0c5E (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i32.const 16
    i32.add
    i32.const 24
    i32.add
    local.tee 3
    i64.const 0
    i64.store
    local.get 2
    i32.const 16
    i32.add
    i32.const 16
    i32.add
    local.tee 4
    i64.const 0
    i64.store
    local.get 2
    i32.const 16
    i32.add
    i32.const 8
    i32.add
    local.tee 5
    i64.const 0
    i64.store
    local.get 2
    i64.const 0
    i64.store offset=16
    local.get 2
    i32.const 8
    i32.add
    local.get 2
    i32.const 16
    i32.add
    i32.const 32
    local.get 1
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.tee 6
    call $_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17h1f3c1b69343042ddE
    local.get 1
    i32.const 0
    local.get 2
    i32.load offset=8
    local.get 2
    i32.load offset=12
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE
    drop
    local.get 0
    local.get 6
    i32.store offset=32
    local.get 0
    i32.const 24
    i32.add
    local.get 3
    i64.load
    i64.store align=1
    local.get 0
    i32.const 16
    i32.add
    local.get 4
    i64.load
    i64.store align=1
    local.get 0
    i32.const 8
    i32.add
    local.get 5
    i64.load
    i64.store align=1
    local.get 0
    local.get 2
    i64.load offset=16
    i64.store align=1
    local.get 2
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17h1f3c1b69343042ddE (type 12) (param i32 i32 i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    local.get 4
    i32.const 8
    i32.add
    i32.const 0
    local.get 3
    local.get 1
    local.get 2
    call $_ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h7c0a7b136baa41e0E
    local.get 4
    i32.load offset=12
    local.set 2
    local.get 0
    local.get 4
    i32.load offset=8
    i32.store
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 4
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE (type 11) (param i32 i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 3
    local.get 2
    call $mBufferGetByteSlice
    i32.const 0
    i32.ne)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17h2a0d7f7707de45aeE (type 5) (param i32) (result i32)
    (local i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 0
    i32.store offset=12
    local.get 0
    local.get 1
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h98c72a94d7838cc8E
    local.get 1
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN19multiversx_sc_codec8num_conv23universal_decode_number17h3c05f972cc915e48E
    local.set 2
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 2
    i32.wrap_i64)
  (func $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$27read_managed_buffer_of_size17h712fbec01e5437caE (type 3) (param i32 i32) (result i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i32.const 8
    i32.add
    local.get 0
    i32.load offset=8
    local.get 0
    i32.load
    local.tee 3
    local.get 1
    call $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10copy_slice17h0eecfde367fc8ab7E
    block  ;; label = @1
      local.get 2
      i32.load offset=8
      i32.const 1
      i32.ne
      br_if 0 (;@1;)
      local.get 2
      i32.load offset=12
      local.set 4
      local.get 0
      local.get 3
      local.get 1
      i32.add
      i32.store
      local.get 2
      i32.const 16
      i32.add
      global.set $__stack_pointer
      local.get 4
      return
    end
    i32.const 1048789
    i32.const 15
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
    unreachable)
  (func $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10copy_slice17h0eecfde367fc8ab7E (type 12) (param i32 i32 i32 i32)
    (local i32)
    local.get 1
    local.get 2
    local.get 3
    call $mBufferNew
    local.tee 4
    call $mBufferCopyByteSlice
    local.set 3
    local.get 0
    local.get 4
    i32.store offset=4
    local.get 0
    local.get 3
    i32.eqz
    i32.store)
  (func $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE (type 2) (param i32 i32)
    (local i32)
    i32.const 1048849
    i32.const 22
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 2
    local.get 0
    local.get 1
    call $mBufferAppendBytes
    drop
    local.get 2
    call $managedSignalError
    unreachable)
  (func $_ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h432fb33eb11a2ceeE (type 1) (param i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 1
        i32.lt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 10000
        i32.le_u
        br_if 1 (;@1;)
        local.get 2
        i32.const 10000
        call $_ZN4core5slice5index22slice_index_order_fail17h2ea00a67370b9381E
        unreachable
      end
      local.get 1
      local.get 2
      call $_ZN4core5slice5index22slice_index_order_fail17h2ea00a67370b9381E
      unreachable
    end
    local.get 0
    local.get 2
    local.get 1
    i32.sub
    i32.store offset=4
    local.get 0
    local.get 1
    i32.const 1050000
    i32.add
    i32.store)
  (func $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$23flush_to_managed_buffer17hc1d7393cf7a6f3f6E (type 6) (param i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 0
    i32.load8_u offset=4
    local.set 2
    local.get 0
    i32.const 0
    i32.store8 offset=4
    block  ;; label = @1
      local.get 2
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.const 8
      i32.add
      i32.const 0
      i32.const 0
      i32.load offset=1060000
      call $_ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$5index17h432fb33eb11a2ceeE
      local.get 0
      i32.load
      local.get 1
      i32.load offset=8
      local.get 1
      i32.load offset=12
      call $mBufferAppendBytes
      drop
      i32.const 0
      i32.const 0
      i32.store offset=1060000
      i32.const 0
      i32.const 0
      i32.store8 offset=1060004
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc7storage11storage_get11storage_get17h760d6ca8500f9c1fE (type 5) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      call $_ZN143_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_de..TopDecode$GT$24top_decode_or_handle_err17hdb6405115833d70bE
      local.tee 0
      call $mBufferGetLength
      i32.const 32
      i32.eq
      br_if 0 (;@1;)
      i32.const 1048875
      i32.const 16
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
      unreachable
    end
    local.get 0)
  (func $_ZN143_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_de..TopDecode$GT$24top_decode_or_handle_err17hdb6405115833d70bE (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h46ae0bf2bea55de4E)
  (func $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E (type 5) (param i32) (result i32)
    (local i64)
    block  ;; label = @1
      local.get 0
      call $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h120aedf0f35dab49E
      local.tee 1
      i64.const 4294967296
      i64.lt_u
      br_if 0 (;@1;)
      i32.const 1048589
      i32.const 14
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
      unreachable
    end
    local.get 1
    i32.wrap_i64)
  (func $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h120aedf0f35dab49E (type 9) (param i32) (result i64)
    (local i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i64.const 0
    i64.store offset=8
    block  ;; label = @1
      local.get 0
      call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h46ae0bf2bea55de4E
      local.tee 0
      call $mBufferGetLength
      local.tee 2
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 1048589
      i32.const 14
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
      unreachable
    end
    local.get 1
    local.get 1
    i32.const 8
    i32.add
    i32.const 8
    local.get 2
    call $_ZN4core5slice5index77_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u5d$$GT$9index_mut17h1f3c1b69343042ddE
    local.get 0
    i32.const 0
    local.get 1
    i32.load
    local.tee 2
    local.get 1
    i32.load offset=4
    local.tee 3
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE
    drop
    local.get 2
    local.get 3
    call $_ZN19multiversx_sc_codec8num_conv23universal_decode_number17h3c05f972cc915e48E
    local.set 4
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $_ZN13multiversx_sc7storage11storage_get15storage_get_len17hd7d143c8060de3aaE (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h331a00ef439a0b28E)
  (func $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h331a00ef439a0b28E (type 5) (param i32) (result i32)
    local.get 0
    i32.const -25
    call $mBufferStorageLoad
    drop
    i32.const -25
    call $mBufferGetLength)
  (func $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h46ae0bf2bea55de4E (type 5) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
    local.tee 1
    call $mBufferStorageLoad
    drop
    local.get 1)
  (func $_ZN13multiversx_sc7storage11storage_set13storage_clear17he483ef5d230142d2E (type 6) (param i32)
    i32.const -20
    i32.const 0
    i32.const 0
    call $mBufferSetBytes
    drop
    local.get 0
    i32.const -20
    call $mBufferStorageStore
    drop)
  (func $_ZN13multiversx_sc7storage11storage_set25StorageSetOutput$LT$A$GT$18set_managed_buffer17he887f3ada7924ea2E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $mBufferStorageStore
    drop)
  (func $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$10save_count17hd0922b1b82d7e157E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    i64.extend_i32_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E)
  (func $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E (type 0) (param i32 i64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i64.const 0
    i64.store offset=8
    local.get 2
    local.get 1
    local.get 2
    i32.const 8
    i32.add
    call $_ZN19multiversx_sc_codec8num_conv17top_encode_number17h5a1a1e19334c4231E
    local.get 0
    local.get 2
    i32.load
    local.get 2
    i32.load offset=4
    call $_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17hf1b34842d88e952aE
    call $mBufferStorageStore
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E (type 3) (param i32 i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 0
    i32.const 1048804
    i32.const 5
    call $mBufferAppendBytes
    drop
    local.get 1
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 0)
  (func $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$23item_is_empty_unchecked17h927aa7e75e23afd3E (type 3) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
    call $_ZN13multiversx_sc7storage11storage_get15storage_get_len17hd7d143c8060de3aaE
    i32.eqz)
  (func $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3get17h7754dbc65332b78bE (type 12) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3len17h49d4212332c00331E
        local.get 3
        i32.lt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            local.get 3
            call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
            local.tee 3
            call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h331a00ef439a0b28E
            br_if 0 (;@4;)
            i32.const 0
            local.set 3
            br 1 (;@3;)
          end
          local.get 4
          i32.const 8
          i32.add
          local.get 3
          call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h46ae0bf2bea55de4E
          call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$3new17h0f552cb474e5f85eE
          i32.const 0
          local.set 3
          local.get 4
          i32.const 0
          i32.store8 offset=32
          local.get 4
          i32.const 8
          i32.add
          local.get 4
          i32.const 32
          i32.add
          i32.const 1
          call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h98c72a94d7838cc8E
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 4
                              i32.load8_u offset=32
                              br_table 9 (;@4;) 1 (;@12;) 2 (;@11;) 3 (;@10;) 4 (;@9;) 5 (;@8;) 6 (;@7;) 7 (;@6;) 8 (;@5;) 0 (;@13;)
                            end
                            i32.const 1048576
                            i32.const 13
                            call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
                            unreachable
                          end
                          local.get 4
                          i32.const 8
                          i32.add
                          call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
                          local.set 5
                          i32.const 1
                          local.set 3
                          br 7 (;@4;)
                        end
                        i32.const 2
                        local.set 3
                        local.get 4
                        i32.const 8
                        i32.add
                        call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
                        local.set 5
                        br 6 (;@4;)
                      end
                      i32.const 3
                      local.set 3
                      local.get 4
                      i32.const 8
                      i32.add
                      call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
                      local.set 5
                      br 5 (;@4;)
                    end
                    i32.const 4
                    local.set 3
                    local.get 4
                    i32.const 8
                    i32.add
                    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17h2a0d7f7707de45aeE
                    local.set 5
                    br 4 (;@4;)
                  end
                  local.get 4
                  i32.const 32
                  i32.add
                  local.get 4
                  i32.const 8
                  i32.add
                  call $_ZN114_$LT$multisig..action..CallActionData$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17hb2e862b8d35fb96fE
                  local.get 4
                  i32.load offset=44
                  local.set 2
                  local.get 4
                  i32.load offset=40
                  local.set 1
                  local.get 4
                  i32.load offset=36
                  local.set 6
                  local.get 4
                  i32.load offset=32
                  local.set 5
                  i32.const 5
                  local.set 3
                  br 3 (;@4;)
                end
                local.get 4
                i32.const 32
                i32.add
                local.get 4
                i32.const 8
                i32.add
                call $_ZN114_$LT$multisig..action..CallActionData$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17hb2e862b8d35fb96fE
                local.get 4
                i32.load offset=44
                local.set 2
                local.get 4
                i32.load offset=40
                local.set 1
                local.get 4
                i32.load offset=36
                local.set 6
                local.get 4
                i32.load offset=32
                local.set 5
                i32.const 6
                local.set 3
                br 2 (;@4;)
              end
              local.get 4
              i32.const 8
              i32.add
              call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$13read_big_uint17hc121fb850d163deaE
              local.set 5
              local.get 4
              i32.const 8
              i32.add
              call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
              local.set 6
              local.get 4
              i32.const 8
              i32.add
              call $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17hb387eb5233ef3459E
              i32.const 65535
              i32.and
              local.set 7
              i32.const 7
              local.set 3
              local.get 4
              i32.const 8
              i32.add
              call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h6c68f2c57efc314aE
              local.set 1
              br 1 (;@4;)
            end
            local.get 4
            i32.const 8
            i32.add
            call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
            local.set 5
            local.get 4
            i32.const 8
            i32.add
            call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$13read_big_uint17hc121fb850d163deaE
            local.set 6
            local.get 4
            i32.const 8
            i32.add
            call $_ZN153_$LT$multiversx_sc..types..managed..wrapped..managed_address..ManagedAddress$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h30f83a8f6fa2f85cE
            local.set 1
            local.get 4
            i32.const 8
            i32.add
            call $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17hb387eb5233ef3459E
            i32.const 65535
            i32.and
            local.set 7
            i32.const 8
            local.set 3
            local.get 4
            i32.const 8
            i32.add
            call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h6c68f2c57efc314aE
            local.set 2
          end
          local.get 4
          i32.load offset=12
          local.get 4
          i32.load offset=8
          i32.ne
          br_if 2 (;@1;)
          local.get 4
          i32.const 24
          i32.add
          i32.load8_u
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          i32.const 0
          i32.store offset=1060000
          i32.const 0
          i32.const 0
          i32.store8 offset=1060004
        end
        local.get 0
        local.get 2
        i32.store offset=16
        local.get 0
        local.get 1
        i32.store offset=12
        local.get 0
        local.get 6
        i32.store offset=8
        local.get 0
        local.get 5
        i32.store offset=4
        local.get 0
        local.get 7
        i32.store16 offset=2
        local.get 0
        local.get 3
        i32.store16
        local.get 4
        i32.const 48
        i32.add
        global.set $__stack_pointer
        return
      end
      i32.const 1049960
      i32.const 18
      call $signalError
      unreachable
    end
    i32.const 1048589
    i32.const 14
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
    unreachable)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11get_user_id17h7264882f76ba5725E (type 3) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$15get_user_id_key17hbd9e72502691c84bE
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$15get_user_id_key17hbd9e72502691c84bE (type 3) (param i32 i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 0
    i32.const 1048809
    i32.const 14
    call $mBufferAppendBytes
    drop
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
    local.get 0)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11set_user_id17h69281ea05de6753cE (type 1) (param i32 i32 i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$15get_user_id_key17hbd9e72502691c84bE
    local.get 2
    i64.extend_i32_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14get_user_count17h7d7cb4d1c94cd5baE (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$18get_user_count_key17hf365994f48748291E
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$18get_user_count_key17hf365994f48748291E (type 5) (param i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 0
    i32.const 1048823
    i32.const 6
    call $mBufferAppendBytes
    drop
    local.get 0)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14set_user_count17h55042e9f9f646e0cE (type 2) (param i32 i32)
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$18get_user_count_key17hf365994f48748291E
    local.get 1
    i64.extend_i32_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$16set_user_address17h5011da9251b66a2aE (type 1) (param i32 i32 i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$20get_user_address_key17h333d8f38045f29aeE
    local.get 2
    call $_ZN13multiversx_sc7storage11storage_set25StorageSetOutput$LT$A$GT$18set_managed_buffer17he887f3ada7924ea2E)
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$20get_user_address_key17h333d8f38045f29aeE (type 3) (param i32 i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 0
    i32.const 1048829
    i32.const 14
    call $mBufferAppendBytes
    drop
    local.get 1
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 0)
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h1353d63d80ca67d2E (type 5) (param i32) (result i32)
    (local i64)
    block  ;; label = @1
      local.get 0
      call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h331a00ef439a0b28E
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        call $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h120aedf0f35dab49E
        local.tee 1
        i64.const 256
        i64.ge_u
        br_if 0 (;@2;)
        local.get 1
        i32.wrap_i64
        local.tee 0
        i32.const 255
        i32.and
        i32.const 3
        i32.ge_u
        br_if 1 (;@1;)
        local.get 0
        return
      end
      i32.const 1048589
      i32.const 14
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
      unreachable
    end
    i32.const 1048576
    i32.const 13
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
    unreachable)
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17h7be41dd828ad1972E (type 2) (param i32 i32)
    local.get 1
    i32.const 255
    i32.and
    i32.const 2
    i32.shl
    i32.const 1049912
    i32.add
    i32.load
    i32.load8_u
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned79_$LT$impl$u20$multiversx_sc_codec..single..top_en..TopEncode$u20$for$u20$u8$GT$24top_encode_or_handle_err17h932c70f96925f17eE)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned79_$LT$impl$u20$multiversx_sc_codec..single..top_en..TopEncode$u20$for$u20$u8$GT$24top_encode_or_handle_err17h932c70f96925f17eE (type 2) (param i32 i32)
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.const 255
    i64.and
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E)
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17hc87e9a1b2e12d8a3E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    i64.extend_i32_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E)
  (func $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$11clear_index17h507f4f1a1f926b4eE (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$14item_index_key17h33be6e599e207a04E
    call $_ZN13multiversx_sc7storage11storage_set13storage_clear17he483ef5d230142d2E)
  (func $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$14item_index_key17h33be6e599e207a04E (type 3) (param i32 i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 0
    i32.const 1048843
    i32.const 6
    call $mBufferAppendBytes
    drop
    local.get 1
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 0)
  (func $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$6insert17h3481eb08d6fa7d76E (type 2) (param i32 i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 8
      i32.add
      i32.load
      local.tee 2
      local.get 1
      call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$8contains17h1e92a21a1665ef18E
      br_if 0 (;@1;)
      local.get 0
      i32.const 4
      i32.add
      i32.load
      local.tee 3
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3len17h49d4212332c00331E
      local.set 4
      local.get 0
      i32.load
      local.get 4
      i32.const 1
      i32.add
      local.tee 0
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
      local.get 1
      i64.extend_i32_u
      call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E
      local.get 3
      local.get 0
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$10save_count17hd0922b1b82d7e157E
      local.get 2
      local.get 1
      local.get 3
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3len17h49d4212332c00331E
      call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$9set_index17h0593f760e658c57eE
    end)
  (func $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$8contains17h1e92a21a1665ef18E (type 3) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$9get_index17h8eb29b2a4f05fd01E
    i32.const 0
    i32.ne)
  (func $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$9set_index17h0593f760e658c57eE (type 1) (param i32 i32 i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$14item_index_key17h33be6e599e207a04E
    local.get 2
    i64.extend_i32_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E)
  (func $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$9get_index17h8eb29b2a4f05fd01E (type 3) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$14item_index_key17h33be6e599e207a04E
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h2d7c67d0d6763b7eE (type 2) (param i32 i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    drop
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc5types7managed5basic8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17h89a6c34ce225ef7cE
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h32025846d90d4b3eE (type 2) (param i32 i32)
    (local i32)
    local.get 1
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 2
    call $_ZN129_$LT$multiversx_sc..types..flags..code_metadata..CodeMetadata$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h281be725b09a0aafE
    local.get 0
    local.get 2
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE (type 2) (param i32 i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    drop
    local.get 0
    local.get 1
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h57c642cdbff22166E (type 2) (param i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 1
    i32.load
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
    local.set 3
    local.get 2
    local.get 1
    i32.store offset=24
    local.get 2
    local.get 3
    i32.store offset=20
    local.get 2
    i32.const 0
    i32.store offset=16
    block  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.const 8
        i32.add
        local.get 2
        i32.const 16
        i32.add
        call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
        local.get 2
        i32.load offset=8
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        i32.load offset=12
        local.get 0
        call $_ZN78_$LT$T$u20$as$u20$multiversx_sc_codec..multi..top_en_multi..TopEncodeMulti$GT$26multi_encode_or_handle_err17h004f8c534baa540fE
        br 0 (;@2;)
      end
    end
    local.get 2
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN78_$LT$T$u20$as$u20$multiversx_sc_codec..multi..top_en_multi..TopEncodeMulti$GT$26multi_encode_or_handle_err17h004f8c534baa540fE (type 2) (param i32 i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    drop
    local.get 1
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h84c03ea503a16905E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    call $_ZN241_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$$u20$as$u20$multiversx_sc_codec..multi..top_en_multi_output..TopEncodeMultiOutput$GT$17push_single_value17hac7114babfbd191dE)
  (func $_ZN241_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$$u20$as$u20$multiversx_sc_codec..multi..top_en_multi_output..TopEncodeMultiOutput$GT$17push_single_value17hac7114babfbd191dE (type 2) (param i32 i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    drop
    local.get 0
    local.get 1
    i32.load
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE (type 2) (param i32 i32)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.tee 2
    local.get 1
    i64.extend_i32_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hfaa77095a04c3951E
    local.get 0
    local.get 2
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hfaa77095a04c3951E (type 0) (param i32 i64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i64.const 0
    i64.store offset=8
    local.get 2
    local.get 1
    local.get 2
    i32.const 8
    i32.add
    call $_ZN19multiversx_sc_codec8num_conv17top_encode_number17h5a1a1e19334c4231E
    local.get 0
    local.get 2
    i32.load
    local.get 2
    i32.load offset=4
    call $mBufferSetBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17hd302060c8ea1f4d4E (type 2) (param i32 i32)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.tee 2
    local.get 1
    i32.const 255
    i32.and
    i32.const 2
    i32.shl
    i32.const 1049912
    i32.add
    i32.load
    i64.load8_u
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hfaa77095a04c3951E
    local.get 0
    local.get 2
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17hd9b6d56d5e2ed0feE (type 0) (param i32 i64)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.tee 2
    local.get 1
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hfaa77095a04c3951E
    local.get 0
    local.get 2
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E)
  (func $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E (type 3) (param i32 i32) (result i32)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.tee 2
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
    local.get 2)
  (func $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h39a7c33210bdbf32E (type 5) (param i32) (result i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 0
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17hc01bfdc41ecf0dc2E
    local.set 2
    local.get 1
    i32.const 8
    i32.add
    local.get 0
    i32.load offset=8
    local.get 0
    i32.load
    local.tee 3
    local.get 2
    call $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10copy_slice17h0eecfde367fc8ab7E
    block  ;; label = @1
      local.get 1
      i32.load offset=8
      i32.const 1
      i32.eq
      br_if 0 (;@1;)
      i32.const 1048631
      i32.const 25
      i32.const 1048789
      i32.const 15
      call $_ZN161_$LT$multiversx_sc..contract_base..wrappers..serializer..ExitCodecErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h7535ef1e83cf0b60E
      unreachable
    end
    local.get 1
    i32.load offset=12
    local.set 4
    local.get 0
    local.get 3
    local.get 2
    i32.add
    i32.store
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17hc01bfdc41ecf0dc2E (type 5) (param i32) (result i32)
    (local i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 0
    i32.store offset=12
    block  ;; label = @1
      local.get 0
      i32.const 8
      i32.add
      local.get 0
      i32.load
      local.get 1
      i32.const 12
      i32.add
      i32.const 4
      call $_ZN13multiversx_sc5types7managed7wrapped24preloaded_managed_buffer31PreloadedManagedBuffer$LT$M$GT$10load_slice17h06f227c05f23ac07E
      i32.eqz
      br_if 0 (;@1;)
      i32.const 1048631
      i32.const 25
      call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17h3ebdcf2df8014b74E
      unreachable
    end
    local.get 0
    local.get 0
    i32.load
    i32.const 4
    i32.add
    i32.store
    local.get 1
    i32.const 12
    i32.add
    i32.const 4
    call $_ZN19multiversx_sc_codec8num_conv23universal_decode_number17h3c05f972cc915e48E
    local.set 2
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 2
    i32.wrap_i64)
  (func $_ZN161_$LT$multiversx_sc..contract_base..wrappers..serializer..ExitCodecErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h7535ef1e83cf0b60E (type 12) (param i32 i32 i32 i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 1
    local.get 2
    local.get 3
    call $mBufferAppendBytes
    drop
    local.get 1
    call $managedSignalError
    unreachable)
  (func $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E (type 2) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 0
    i32.load8_u offset=4
    local.set 3
    local.get 0
    i32.const 0
    i32.store8 offset=4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 1
            i32.and
            local.tee 3
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3len17h235b380363869d42E
            local.set 4
            i32.const 10000
            i32.const 0
            i32.load offset=1060000
            local.tee 5
            i32.sub
            local.get 4
            i32.lt_u
            br_if 2 (;@2;)
            local.get 2
            i32.const 8
            i32.add
            local.get 5
            local.get 5
            local.get 4
            i32.add
            local.tee 4
            call $_ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h4669ceec602b3051E
            local.get 1
            i32.const 0
            local.get 2
            i32.load offset=8
            local.get 2
            i32.load offset=12
            call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$10load_slice17hafb05f2ae3fcbc5aE
            drop
            i32.const 0
            local.get 4
            i32.store offset=1060000
            br 1 (;@3;)
          end
          local.get 0
          i32.load
          local.get 1
          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
        end
        local.get 0
        local.get 3
        i32.store8 offset=4
        br 1 (;@1;)
      end
      local.get 0
      call $_ZN13multiversx_sc5types7managed7wrapped29managed_buffer_cached_builder35ManagedBufferCachedBuilder$LT$M$GT$23flush_to_managed_buffer17hc1d7393cf7a6f3f6E
      local.get 0
      i32.load
      local.get 1
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$6append17h3ccf20d6e2bfddf9E
      local.get 0
      i32.load8_u offset=4
      local.set 1
      local.get 0
      local.get 3
      i32.store8 offset=4
      local.get 1
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      i32.const 0
      i32.const 0
      i32.store offset=1060000
      i32.const 0
      i32.const 0
      i32.store8 offset=1060004
    end
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN4core5array88_$LT$impl$u20$core..ops..index..IndexMut$LT$I$GT$$u20$for$u20$$u5b$T$u3b$$u20$N$u5d$$GT$9index_mut17h4669ceec602b3051E (type 1) (param i32 i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    local.get 3
    i32.const 8
    i32.add
    local.get 1
    local.get 2
    i32.const 1050000
    i32.const 10000
    call $_ZN106_$LT$core..ops..range..Range$LT$usize$GT$$u20$as$u20$core..slice..index..SliceIndex$LT$$u5b$T$u5d$$GT$$GT$9index_mut17h7c0a7b136baa41e0E
    local.get 3
    i32.load offset=12
    local.set 2
    local.get 0
    local.get 3
    i32.load offset=8
    i32.store
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 3
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17h3ebdcf2df8014b74E (type 2) (param i32 i32)
    local.get 0
    local.get 1
    i32.const 1048789
    i32.const 15
    call $_ZN161_$LT$multiversx_sc..contract_base..wrappers..serializer..ExitCodecErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h7535ef1e83cf0b60E
    unreachable)
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17h87156cd76d16ced9E (type 13)
    i32.const 1048789
    i32.const 15
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17hae89ad18d99a8e8cE
    unreachable)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned79_$LT$impl$u20$multiversx_sc_codec..single..top_en..TopEncode$u20$for$u20$u8$GT$24top_encode_or_handle_err17h53a9d68ff27a9072E (type 6) (param i32)
    local.get 0
    i64.extend_i32_u
    i64.const 255
    i64.and
    call $smallIntFinishUnsigned)
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i32.store8 offset=15
    local.get 1
    local.get 2
    i32.const 15
    i32.add
    i32.const 1
    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$5write17h226448ae2ba0ffbbE
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h67cca4e75573e390E (type 2) (param i32 i32)
    local.get 1
    local.get 0
    i32.load
    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
    local.get 0
    i32.load offset=4
    local.get 1
    call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h9acead432087e203E
    local.get 0
    i32.load offset=8
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17hb4a53d74daad638bE
    local.get 0
    i32.const 12
    i32.add
    local.get 1
    call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E)
  (func $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17hb230d5f3a978c754E (type 2) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i32.load16_u
    local.tee 0
    i32.const 8
    i32.shl
    local.get 0
    i32.const 8
    i32.shr_u
    i32.or
    i32.store16 offset=14
    local.get 1
    local.get 2
    i32.const 14
    i32.add
    i32.const 2
    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$5write17h226448ae2ba0ffbbE
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN19multiversx_sc_codec8num_conv17top_encode_number17h5a1a1e19334c4231E (type 19) (param i32 i64 i32)
    (local i32 i32)
    local.get 2
    local.get 1
    i64.const 56
    i64.shl
    local.get 1
    i64.const 40
    i64.shl
    i64.const 71776119061217280
    i64.and
    i64.or
    local.get 1
    i64.const 24
    i64.shl
    i64.const 280375465082880
    i64.and
    local.get 1
    i64.const 8
    i64.shl
    i64.const 1095216660480
    i64.and
    i64.or
    i64.or
    local.get 1
    i64.const 8
    i64.shr_u
    i64.const 4278190080
    i64.and
    local.get 1
    i64.const 24
    i64.shr_u
    i64.const 16711680
    i64.and
    i64.or
    local.get 1
    i64.const 40
    i64.shr_u
    i64.const 65280
    i64.and
    local.get 1
    i64.const 56
    i64.shr_u
    i64.or
    i64.or
    i64.or
    i64.store align=1
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i64.eqz
        i32.eqz
        br_if 0 (;@2;)
        i32.const 1049980
        local.set 3
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      i32.const 0
      local.set 4
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 4
              i32.const 8
              i32.eq
              br_if 0 (;@5;)
              local.get 2
              local.get 4
              i32.add
              local.tee 3
              i32.load8_u
              i32.eqz
              br_if 2 (;@3;)
              local.get 4
              i32.const 9
              i32.ge_u
              br_if 1 (;@4;)
              i32.const 8
              local.get 4
              i32.sub
              local.set 4
              br 4 (;@1;)
            end
            call $_ZN4core9panicking18panic_bounds_check17h38fbb319fd348cd4E
            unreachable
          end
          local.get 4
          call $_ZN4core5slice5index26slice_start_index_len_fail17h5738b4a31f480daeE
          unreachable
        end
        local.get 4
        i32.const 1
        i32.add
        local.set 4
        br 0 (;@2;)
      end
    end
    local.get 0
    local.get 4
    i32.store offset=4
    local.get 0
    local.get 3
    i32.store)
  (func $_ZN21multiversx_sc_modules3dns9dns_proxy10ProxyTrait8register17h96025d1d86d59050E (type 1) (param i32 i32 i32)
    (local i32 i32)
    local.get 1
    i32.load
    local.set 3
    local.get 1
    i32.const 2147483646
    i32.store
    block  ;; label = @1
      local.get 3
      i32.const 2147483646
      i32.ne
      br_if 0 (;@1;)
      i32.const 1048606
      i32.const 25
      call $signalError
      unreachable
    end
    i32.const 1048902
    i32.const 8
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.set 1
    local.get 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.tee 4
    i32.store offset=16
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    local.get 3
    i32.store offset=8
    local.get 0
    i64.const -1
    i64.store
    local.get 4
    local.get 2
    call $_ZN241_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$GT$$u20$as$u20$multiversx_sc_codec..multi..top_en_multi_output..TopEncodeMultiOutput$GT$17push_single_value17hac7114babfbd191dE)
  (func $_ZN4core4iter5range110_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..RangeInclusive$LT$A$GT$$GT$4next17he8209a343d477d9eE (type 2) (param i32 i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load8_u offset=8
        i32.eqz
        br_if 0 (;@2;)
        br 1 (;@1;)
      end
      local.get 1
      i32.load
      local.tee 3
      local.get 1
      i32.load offset=4
      local.tee 4
      i32.gt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        local.get 4
        i32.lt_u
        br_if 0 (;@2;)
        i32.const 1
        local.set 2
        local.get 1
        i32.const 1
        i32.store8 offset=8
        br 1 (;@1;)
      end
      i32.const 1
      local.set 2
      local.get 1
      local.get 3
      i32.const 1
      i32.add
      i32.store
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE (type 4) (result i32)
    i32.const 1048937
    i32.const 4
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E (type 6) (param i32)
    (local i32 i32)
    i32.const 1048941
    i32.const 11
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 1
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 2
    i32.const 1048871
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13num_proposers17hb7bb5ad9f3d939ffE (type 4) (result i32)
    i32.const 1048952
    i32.const 13
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE (type 5) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 1048965
    i32.const 9
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 1
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 1)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E (type 2) (param i32 i32)
    (local i32 i32)
    local.get 1
    i32.const 1048974
    i32.const 17
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E
    local.tee 2
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h7d0146e8e6d781adE
    local.get 2
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.set 1
    local.get 2
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.tee 3
    i32.const 1048871
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store
    local.get 0
    local.get 1
    i32.store offset=8)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E (type 4) (result i32)
    i32.const 1048991
    i32.const 17
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E)
  (func $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E (type 4) (result i32)
    i32.const 1049008
    i32.const 6
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17hf2be9b825bb19091E)
  (func $_ZN69_$LT$C$u20$as$u20$multisig..multisig_events..MultisigEventsModule$GT$24perform_async_call_event17h9554d87350bca7dcE (type 20) (param i32 i32 i32 i64 i32 i32)
    (local i32)
    i32.const 1049014
    i32.const 16
    call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
    local.tee 6
    local.get 0
    call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
    local.get 6
    local.get 1
    call $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE
    local.get 6
    local.get 2
    call $_ZN13multiversx_sc8log_util21serialize_event_topic17h2d7c67d0d6763b7eE
    local.get 6
    local.get 3
    call $_ZN13multiversx_sc8log_util21serialize_event_topic17hd9b6d56d5e2ed0feE
    local.get 6
    local.get 4
    call $_ZN13multiversx_sc8log_util21serialize_event_topic17h84c03ea503a16905E
    local.get 6
    local.get 5
    call $_ZN13multiversx_sc8log_util21serialize_event_topic17h57c642cdbff22166E
    local.get 6
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    call $managedWriteLog)
  (func $_ZN80_$LT$multisig..action..CallActionData$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h4cf80c9a93a31b3cE (type 2) (param i32 i32)
    (local i32 i32 i32)
    local.get 1
    i32.load
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.set 2
    local.get 1
    i32.load offset=4
    call $_ZN103_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h47cb92ae47e84177E
    local.set 3
    local.get 1
    i32.load offset=8
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
    local.set 4
    local.get 0
    local.get 1
    i32.const 12
    i32.add
    call $_ZN115_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h3ddfd7b7e279dbcfE
    i32.store offset=12
    local.get 0
    local.get 4
    i32.store offset=8
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func $_ZN8multisig14multisig_state19MultisigStateModule18get_action_signers17h13c78cd7b88aa257E (type 5) (param i32) (result i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 16
    i32.add
    local.get 0
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 2
    local.get 1
    local.get 1
    i32.load offset=20
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
    i32.store offset=36
    local.get 1
    i32.const 1
    i32.store offset=32
    local.get 1
    local.get 1
    i32.const 16
    i32.add
    i32.store offset=40
    loop (result i32)  ;; label = @1
      local.get 1
      i32.const 8
      i32.add
      local.get 1
      i32.const 32
      i32.add
      call $_ZN122_$LT$multiversx_sc..storage..mappers..vec_mapper..Iter$LT$SA$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc8a4d288cd840622E
      block  ;; label = @2
        local.get 1
        i32.load offset=8
        br_if 0 (;@2;)
        local.get 1
        i32.const 48
        i32.add
        global.set $__stack_pointer
        local.get 2
        return
      end
      local.get 1
      i32.load offset=12
      local.set 0
      local.get 2
      call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
      local.get 0
      call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$20get_user_address_key17h333d8f38045f29aeE
      call $_ZN13multiversx_sc7storage11storage_get11storage_get17h760d6ca8500f9c1fE
      call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
      br 0 (;@1;)
    end)
  (func $_ZN8multisig14multisig_state19MultisigStateModule21get_action_last_index17hcdc6ade39ecaa28bE (type 4) (result i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    local.get 0
    i32.const 8
    i32.add
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
    local.get 0
    i32.load offset=12
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
    local.set 1
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 1)
  (func $_ZN8multisig14multisig_state19MultisigStateModule22get_caller_id_and_role17h3502b5bac4a03605E (type 6) (param i32)
    (local i32)
    call $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$10get_caller17h4351fc9dfbe955ceE
    local.set 1
    local.get 0
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11get_user_id17h7264882f76ba5725E
    local.tee 1
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h1353d63d80ca67d2E
    i32.store8 offset=4
    local.get 0
    local.get 1
    i32.store)
  (func $_ZN8multisig14multisig_state19MultisigStateModule26add_multiple_board_members28_$u7b$$u7b$closure$u7d$$u7d$17h9a9fbeecb9867651E (type 1) (param i32 i32 i32)
    block  ;; label = @1
      local.get 2
      br_if 0 (;@1;)
      local.get 0
      i32.const 1
      i32.store8
    end
    local.get 1
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE
    i32.const 2
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17h7be41dd828ad1972E)
  (func $_ZN8multisig14multisig_state19MultisigStateModule29get_action_valid_signer_count17hb535030249e14c32E (type 5) (param i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 16
    i32.add
    local.get 0
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
    local.get 1
    local.get 1
    i32.load offset=20
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
    i32.store offset=36
    local.get 1
    i32.const 1
    i32.store offset=32
    local.get 1
    local.get 1
    i32.const 16
    i32.add
    i32.store offset=40
    i32.const 0
    local.set 0
    block  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 8
        i32.add
        local.get 1
        i32.const 32
        i32.add
        call $_ZN122_$LT$multiversx_sc..storage..mappers..vec_mapper..Iter$LT$SA$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc8a4d288cd840622E
        local.get 1
        i32.load offset=8
        i32.const 1
        i32.ne
        br_if 1 (;@1;)
        local.get 0
        local.get 1
        i32.load offset=12
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE
        call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h1353d63d80ca67d2E
        i32.const 255
        i32.and
        i32.const 2
        i32.eq
        i32.add
        local.set 0
        br 0 (;@2;)
      end
    end
    local.get 1
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $_ZN8multisig16multisig_perform21MultisigPerformModule12clear_action17hd235a2c1ca188cbdE (type 6) (param i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 24
    i32.add
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
    local.get 1
    i32.load offset=24
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
    call $_ZN13multiversx_sc7storage11storage_set13storage_clear17he483ef5d230142d2E
    local.get 1
    i32.const 32
    i32.add
    local.get 0
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
    local.get 1
    local.get 1
    i32.load offset=36
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
    i32.store offset=52
    local.get 1
    i32.const 1
    i32.store offset=48
    local.get 1
    local.get 1
    i32.const 32
    i32.add
    i32.store offset=56
    block  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 16
        i32.add
        local.get 1
        i32.const 48
        i32.add
        call $_ZN122_$LT$multiversx_sc..storage..mappers..vec_mapper..Iter$LT$SA$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc8a4d288cd840622E
        block  ;; label = @3
          local.get 1
          i32.load offset=16
          br_if 0 (;@3;)
          local.get 1
          i32.load offset=36
          call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
          local.set 0
          local.get 1
          i32.const 0
          i32.store8 offset=56
          local.get 1
          local.get 0
          i32.store offset=52
          local.get 1
          i32.const 1
          i32.store offset=48
          loop  ;; label = @4
            local.get 1
            i32.const 8
            i32.add
            local.get 1
            i32.const 48
            i32.add
            call $_ZN4core4iter5range110_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..RangeInclusive$LT$A$GT$$GT$4next17he8209a343d477d9eE
            local.get 1
            i32.load offset=8
            i32.eqz
            br_if 3 (;@1;)
            local.get 1
            i32.load offset=32
            local.get 1
            i32.load offset=12
            call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
            call $_ZN13multiversx_sc7storage11storage_set13storage_clear17he483ef5d230142d2E
            br 0 (;@4;)
          end
        end
        local.get 1
        i32.load offset=40
        local.get 1
        i32.load offset=20
        call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$11clear_index17h507f4f1a1f926b4eE
        br 0 (;@2;)
      end
    end
    local.get 1
    i32.load offset=36
    i64.const 0
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E
    local.get 1
    i32.const 64
    i32.add
    global.set $__stack_pointer)
  (func $_ZN8multisig16multisig_perform21MultisigPerformModule14quorum_reached17h6ed0ba2d25403347E (type 5) (param i32) (result i32)
    (local i32)
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
    local.set 1
    local.get 0
    call $_ZN8multisig14multisig_state19MultisigStateModule29get_action_valid_signer_count17hb535030249e14c32E
    local.get 1
    i32.ge_u)
  (func $_ZN8multisig16multisig_perform21MultisigPerformModule16change_user_role17hc5b4803d3a527bc4E (type 1) (param i32 i32 i32)
    (local i32 i32)
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
    local.tee 3
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11get_user_id17h7264882f76ba5725E
    local.set 4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 255
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          br_if 1 (;@2;)
          local.get 3
          local.get 3
          call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14get_user_count17h7d7cb4d1c94cd5baE
          i32.const 1
          i32.add
          local.tee 4
          call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14set_user_count17h55042e9f9f646e0cE
          local.get 3
          local.get 1
          local.get 4
          call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11set_user_id17h69281ea05de6753cE
          local.get 3
          local.get 4
          local.get 1
          call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$16set_user_address17h5011da9251b66a2aE
          br 1 (;@2;)
        end
        local.get 4
        i32.eqz
        br_if 1 (;@1;)
      end
      local.get 4
      call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE
      local.tee 4
      call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h1353d63d80ca67d2E
      local.set 3
      local.get 4
      local.get 2
      call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17h7be41dd828ad1972E
      i32.const 1049030
      i32.const 17
      call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
      local.tee 4
      local.get 0
      call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
      local.get 4
      local.get 1
      call $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE
      local.get 4
      local.get 3
      call $_ZN13multiversx_sc8log_util21serialize_event_topic17hd302060c8ea1f4d4E
      local.get 4
      local.get 2
      call $_ZN13multiversx_sc8log_util21serialize_event_topic17hd302060c8ea1f4d4E
      local.get 4
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
      call $managedWriteLog
      block  ;; label = @2
        local.get 3
        i32.const 255
        i32.and
        local.tee 4
        i32.const 2
        i32.ne
        i32.const -1
        i32.const 0
        local.get 4
        i32.const 2
        i32.eq
        select
        local.get 2
        i32.const 255
        i32.and
        local.tee 2
        i32.const 2
        i32.eq
        select
        local.tee 3
        i32.eqz
        br_if 0 (;@2;)
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E
        local.set 1
        local.get 1
        local.get 1
        call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
        local.get 3
        i32.add
        call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17hc87e9a1b2e12d8a3E
      end
      local.get 4
      i32.const 1
      i32.ne
      i32.const -1
      i32.const 0
      local.get 4
      i32.const 1
      i32.eq
      select
      local.get 2
      i32.const 1
      i32.eq
      select
      local.tee 4
      i32.eqz
      br_if 0 (;@1;)
      call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13num_proposers17hb7bb5ad9f3d939ffE
      local.set 2
      local.get 2
      local.get 2
      call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
      local.get 4
      i32.add
      call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17hc87e9a1b2e12d8a3E
    end)
  (func $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E (type 5) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    i32.const 72
    i32.add
    call $_ZN8multisig14multisig_state19MultisigStateModule22get_caller_id_and_role17h3502b5bac4a03605E
    block  ;; label = @1
      local.get 1
      i32.load8_u offset=76
      local.tee 2
      i32.const -1
      i32.add
      i32.const 1
      i32.gt_u
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=72
      local.set 3
      local.get 1
      i32.const 64
      i32.add
      call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
      local.get 1
      i32.load offset=64
      local.get 1
      i32.load offset=68
      local.tee 4
      call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
      i32.const 1
      i32.add
      local.tee 5
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 0
                          i32.load16_u
                          br_table 0 (;@11;) 1 (;@10;) 2 (;@9;) 3 (;@8;) 4 (;@7;) 5 (;@6;) 6 (;@5;) 7 (;@4;) 8 (;@3;) 0 (;@11;)
                        end
                        i32.const 0
                        local.get 6
                        call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned79_$LT$impl$u20$multiversx_sc_codec..single..top_en..TopEncode$u20$for$u20$u8$GT$24top_encode_or_handle_err17h932c70f96925f17eE
                        br 8 (;@2;)
                      end
                      local.get 1
                      call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                      local.get 1
                      local.get 1
                      i32.load8_u offset=4
                      i32.store8 offset=84
                      local.get 1
                      local.get 1
                      i32.load
                      i32.store offset=80
                      i32.const 1
                      local.get 1
                      i32.const 80
                      i32.add
                      call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                      local.get 1
                      i32.const 80
                      i32.add
                      local.get 0
                      i32.load offset=4
                      call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
                      local.get 6
                      local.get 1
                      i32.load offset=80
                      local.get 1
                      i32.load8_u offset=84
                      call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
                      br 7 (;@2;)
                    end
                    local.get 1
                    i32.const 8
                    i32.add
                    call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                    local.get 1
                    local.get 1
                    i32.load8_u offset=12
                    i32.store8 offset=84
                    local.get 1
                    local.get 1
                    i32.load offset=8
                    i32.store offset=80
                    i32.const 2
                    local.get 1
                    i32.const 80
                    i32.add
                    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                    local.get 1
                    i32.const 80
                    i32.add
                    local.get 0
                    i32.load offset=4
                    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
                    local.get 6
                    local.get 1
                    i32.load offset=80
                    local.get 1
                    i32.load8_u offset=84
                    call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
                    br 6 (;@2;)
                  end
                  local.get 1
                  i32.const 16
                  i32.add
                  call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                  local.get 1
                  local.get 1
                  i32.load8_u offset=20
                  i32.store8 offset=84
                  local.get 1
                  local.get 1
                  i32.load offset=16
                  i32.store offset=80
                  i32.const 3
                  local.get 1
                  i32.const 80
                  i32.add
                  call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                  local.get 1
                  i32.const 80
                  i32.add
                  local.get 0
                  i32.load offset=4
                  call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
                  local.get 6
                  local.get 1
                  i32.load offset=80
                  local.get 1
                  i32.load8_u offset=84
                  call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
                  br 5 (;@2;)
                end
                local.get 1
                i32.const 24
                i32.add
                call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                local.get 1
                local.get 1
                i32.load8_u offset=28
                i32.store8 offset=84
                local.get 1
                local.get 1
                i32.load offset=24
                i32.store offset=80
                i32.const 4
                local.get 1
                i32.const 80
                i32.add
                call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                local.get 0
                i32.load offset=4
                local.get 1
                i32.const 80
                i32.add
                call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h3dd180332d7387d9E
                local.get 6
                local.get 1
                i32.load offset=80
                local.get 1
                i32.load8_u offset=84
                call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
                br 4 (;@2;)
              end
              local.get 1
              i32.const 32
              i32.add
              call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
              local.get 1
              local.get 1
              i32.load8_u offset=36
              i32.store8 offset=84
              local.get 1
              local.get 1
              i32.load offset=32
              i32.store offset=80
              i32.const 5
              local.get 1
              i32.const 80
              i32.add
              call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
              local.get 0
              i32.const 4
              i32.add
              local.get 1
              i32.const 80
              i32.add
              call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h67cca4e75573e390E
              local.get 6
              local.get 1
              i32.load offset=80
              local.get 1
              i32.load8_u offset=84
              call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
              br 3 (;@2;)
            end
            local.get 1
            i32.const 40
            i32.add
            call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
            local.get 1
            local.get 1
            i32.load8_u offset=44
            i32.store8 offset=84
            local.get 1
            local.get 1
            i32.load offset=40
            i32.store offset=80
            i32.const 6
            local.get 1
            i32.const 80
            i32.add
            call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
            local.get 0
            i32.const 4
            i32.add
            local.get 1
            i32.const 80
            i32.add
            call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h67cca4e75573e390E
            local.get 6
            local.get 1
            i32.load offset=80
            local.get 1
            i32.load8_u offset=84
            call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
            br 2 (;@2;)
          end
          local.get 1
          i32.const 48
          i32.add
          call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
          local.get 1
          local.get 1
          i32.load8_u offset=52
          i32.store8 offset=84
          local.get 1
          local.get 1
          i32.load offset=48
          i32.store offset=80
          i32.const 7
          local.get 1
          i32.const 80
          i32.add
          call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
          local.get 0
          i32.load offset=4
          local.get 1
          i32.const 80
          i32.add
          call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h9acead432087e203E
          local.get 1
          i32.const 80
          i32.add
          local.get 0
          i32.load offset=8
          call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
          local.get 0
          i32.const 2
          i32.add
          local.get 1
          i32.const 80
          i32.add
          call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17hb230d5f3a978c754E
          local.get 0
          i32.const 12
          i32.add
          local.get 1
          i32.const 80
          i32.add
          call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E
          local.get 6
          local.get 1
          i32.load offset=80
          local.get 1
          i32.load8_u offset=84
          call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
          br 1 (;@2;)
        end
        local.get 1
        i32.const 56
        i32.add
        call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
        local.get 1
        local.get 1
        i32.load8_u offset=60
        i32.store8 offset=84
        local.get 1
        local.get 1
        i32.load offset=56
        i32.store offset=80
        i32.const 8
        local.get 1
        i32.const 80
        i32.add
        call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
        local.get 1
        i32.const 80
        i32.add
        local.get 0
        i32.load offset=4
        call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
        local.get 0
        i32.load offset=8
        local.get 1
        i32.const 80
        i32.add
        call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h9acead432087e203E
        local.get 1
        i32.const 80
        i32.add
        local.get 0
        i32.load offset=12
        call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
        local.get 0
        i32.const 2
        i32.add
        local.get 1
        i32.const 80
        i32.add
        call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17hb230d5f3a978c754E
        local.get 0
        i32.const 16
        i32.add
        local.get 1
        i32.const 80
        i32.add
        call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E
        local.get 6
        local.get 1
        i32.load offset=80
        local.get 1
        i32.load8_u offset=84
        call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17hfd36fe8048823691E
      end
      local.get 4
      local.get 5
      i64.extend_i32_u
      call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E
      block  ;; label = @2
        local.get 2
        i32.const 2
        i32.ne
        br_if 0 (;@2;)
        local.get 1
        i32.const 80
        i32.add
        local.get 5
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
        local.get 1
        i32.const 80
        i32.add
        local.get 3
        call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$6insert17h3481eb08d6fa7d76E
      end
      local.get 1
      i32.const 96
      i32.add
      global.set $__stack_pointer
      local.get 5
      return
    end
    i32.const 1049601
    i32.const 44
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
    unreachable)
  (func $_ZN8multisig16multisig_propose21MultisigProposeModule17prepare_call_data17h213e26757802370bE (type 21) (param i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        call $bigIntSign
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 3
        i32.eqz
        br_if 1 (;@1;)
        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
        local.set 4
        br 1 (;@1;)
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      i32.const 1049645
      i32.const 29
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
      unreachable
    end
    local.get 0
    local.get 5
    i32.store offset=12
    local.get 0
    local.get 4
    i32.store offset=8
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store)
  (func $_ZN8multisig8Multisig23get_all_users_with_role17hd86e927a1842c1e9E (type 5) (param i32) (result i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 2
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
    call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14get_user_count17h7d7cb4d1c94cd5baE
    local.set 3
    local.get 1
    i32.const 0
    i32.store8 offset=24
    local.get 1
    local.get 3
    i32.store offset=20
    local.get 1
    i32.const 1
    i32.store offset=16
    local.get 0
    i32.const 255
    i32.and
    local.set 3
    block  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 8
        i32.add
        local.get 1
        i32.const 16
        i32.add
        call $_ZN4core4iter5range110_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..RangeInclusive$LT$A$GT$$GT$4next17he8209a343d477d9eE
        local.get 1
        i32.load offset=8
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        i32.load offset=12
        local.tee 0
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE
        call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h1353d63d80ca67d2E
        i32.const 255
        i32.and
        local.get 3
        i32.ne
        br_if 0 (;@2;)
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
        local.get 0
        call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$20get_user_address_key17h333d8f38045f29aeE
        local.tee 0
        call $_ZN13multiversx_sc7storage11storage_get15storage_get_len17hd7d143c8060de3aaE
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        call $_ZN13multiversx_sc7storage11storage_get11storage_get17h760d6ca8500f9c1fE
        local.set 0
        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
        drop
        local.get 2
        local.get 0
        call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
        call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
        br 0 (;@2;)
      end
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get 2)
  (func $rust_begin_unwind (type 13)
    call $_ZN26multiversx_sc_wasm_adapter9wasm_deps9panic_fmt17h9e8d9ada64e30edfE
    unreachable)
  (func $_ZN26multiversx_sc_wasm_adapter9wasm_deps9panic_fmt17h9e8d9ada64e30edfE (type 13)
    i32.const 1049980
    i32.const 14
    call $signalError
    unreachable)
  (func $init (type 13)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E
    i32.const 0
    i32.const 1049008
    i32.const 6
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 1
    i32.store offset=32
    local.get 0
    i32.const 32
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h9c6df3612827bc63E
    local.set 2
    local.get 0
    i32.load offset=32
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE
    local.get 0
    local.get 2
    i32.store offset=20
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 3
    local.get 0
    local.get 2
    call $mBufferGetLength
    i32.store offset=36
    local.get 0
    i32.const 0
    i32.store offset=32
    local.get 0
    local.get 0
    i32.const 20
    i32.add
    i32.store offset=40
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 0
                i32.const 8
                i32.add
                local.get 0
                i32.const 32
                i32.add
                call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
                local.get 0
                i32.load offset=8
                i32.eqz
                br_if 1 (;@5;)
                local.get 0
                i32.load offset=12
                call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                local.tee 2
                call $mBufferGetLength
                i32.const 32
                i32.ne
                br_if 2 (;@4;)
                local.get 3
                local.get 2
                call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
                br 0 (;@6;)
              end
            end
            local.get 0
            local.get 3
            i32.store offset=24
            local.get 0
            i32.const 0
            i32.store8 offset=31
            call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
            local.set 4
            local.get 3
            call $mBufferGetLength
            local.set 2
            local.get 4
            call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14get_user_count17h7d7cb4d1c94cd5baE
            local.set 5
            local.get 0
            local.get 2
            i32.store offset=36
            local.get 0
            i32.const 0
            i32.store offset=32
            local.get 0
            local.get 0
            i32.const 24
            i32.add
            i32.store offset=40
            block  ;; label = @5
              loop  ;; label = @6
                local.get 0
                local.get 0
                i32.const 32
                i32.add
                call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
                local.get 0
                i32.load
                i32.eqz
                br_if 1 (;@5;)
                block  ;; label = @7
                  local.get 4
                  local.get 0
                  i32.load offset=4
                  local.tee 3
                  call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11get_user_id17h7264882f76ba5725E
                  local.tee 2
                  br_if 0 (;@7;)
                  local.get 4
                  local.get 3
                  local.get 5
                  i32.const 1
                  i32.add
                  local.tee 5
                  call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11set_user_id17h69281ea05de6753cE
                  local.get 4
                  local.get 5
                  local.get 3
                  call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$16set_user_address17h5011da9251b66a2aE
                  local.get 0
                  i32.const 31
                  i32.add
                  local.get 5
                  i32.const 1
                  call $_ZN8multisig14multisig_state19MultisigStateModule26add_multiple_board_members28_$u7b$$u7b$closure$u7d$$u7d$17h9a9fbeecb9867651E
                  br 1 (;@6;)
                end
                local.get 0
                i32.const 31
                i32.add
                local.get 2
                i32.const 0
                call $_ZN8multisig14multisig_state19MultisigStateModule26add_multiple_board_members28_$u7b$$u7b$closure$u7d$$u7d$17h9a9fbeecb9867651E
                br 0 (;@6;)
              end
            end
            local.get 4
            local.get 5
            call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$14set_user_count17h55042e9f9f646e0cE
            local.get 0
            i32.load8_u offset=31
            br_if 1 (;@3;)
            call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E
            local.set 2
            local.get 2
            local.get 2
            call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
            local.get 0
            i32.load offset=24
            call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$3len17h326da4425d923b01E
            i32.add
            local.tee 4
            call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17hc87e9a1b2e12d8a3E
            local.get 4
            i32.const 0
            call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13num_proposers17hb7bb5ad9f3d939ffE
            call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
            i32.sub
            i32.eq
            br_if 2 (;@2;)
            local.get 4
            local.get 1
            i32.lt_u
            br_if 3 (;@1;)
            call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E
            local.get 1
            call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17hc87e9a1b2e12d8a3E
            local.get 0
            i32.const 48
            i32.add
            global.set $__stack_pointer
            return
          end
          i32.const 1048631
          i32.const 25
          i32.const 1048875
          i32.const 16
          call $_ZN161_$LT$multiversx_sc..contract_base..wrappers..serializer..ExitCodecErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h7535ef1e83cf0b60E
          unreachable
        end
        i32.const 1049192
        i32.const 22
        call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
        unreachable
      end
      i32.const 1049769
      i32.const 62
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
      unreachable
    end
    i32.const 1049311
    i32.const 31
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
    unreachable)
  (func $deposit (type 13)
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE)
  (func $signed (type 13)
    (local i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 2
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1048937
    i32.const 4
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    i32.const 1
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
        local.get 1
        call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11get_user_id17h7264882f76ba5725E
        local.tee 1
        br_if 0 (;@2;)
        i64.const 0
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      local.get 2
      call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
      local.get 0
      i32.load offset=8
      local.get 1
      call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$8contains17h1e92a21a1665ef18E
      i64.extend_i32_u
      local.set 3
    end
    local.get 3
    call $smallIntFinishSigned
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $sign (type 13)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 8
    i32.add
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=8
        local.get 1
        call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$23item_is_empty_unchecked17h927aa7e75e23afd3E
        br_if 0 (;@2;)
        local.get 0
        call $_ZN8multisig14multisig_state19MultisigStateModule22get_caller_id_and_role17h3502b5bac4a03605E
        local.get 0
        i32.load8_u offset=4
        i32.const 2
        i32.ne
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.set 2
        local.get 0
        i32.const 16
        i32.add
        local.get 1
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
        block  ;; label = @3
          local.get 0
          i32.load offset=24
          local.get 2
          call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$8contains17h1e92a21a1665ef18E
          br_if 0 (;@3;)
          local.get 0
          i32.const 16
          i32.add
          local.get 1
          call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
          local.get 0
          i32.const 16
          i32.add
          local.get 2
          call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$6insert17h3481eb08d6fa7d76E
        end
        local.get 0
        i32.const 32
        i32.add
        global.set $__stack_pointer
        return
      end
      i32.const 1049831
      i32.const 21
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
      unreachable
    end
    i32.const 1049852
    i32.const 27
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
    unreachable)
  (func $unsign (type 13)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 8
    i32.add
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 0
                  i32.load offset=8
                  local.get 1
                  call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$23item_is_empty_unchecked17h927aa7e75e23afd3E
                  br_if 0 (;@7;)
                  local.get 0
                  call $_ZN8multisig14multisig_state19MultisigStateModule22get_caller_id_and_role17h3502b5bac4a03605E
                  local.get 0
                  i32.load8_u offset=4
                  i32.const 2
                  i32.ne
                  br_if 4 (;@3;)
                  local.get 0
                  i32.load
                  local.set 2
                  local.get 0
                  i32.const 16
                  i32.add
                  local.get 1
                  call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
                  local.get 0
                  i32.load offset=24
                  local.tee 3
                  local.get 2
                  call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$9get_index17h8eb29b2a4f05fd01E
                  local.tee 4
                  i32.eqz
                  br_if 6 (;@1;)
                  local.get 0
                  i32.load offset=20
                  local.tee 5
                  call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                  local.tee 1
                  local.get 4
                  i32.lt_u
                  br_if 1 (;@6;)
                  local.get 1
                  local.get 4
                  i32.eq
                  local.tee 6
                  br_if 5 (;@2;)
                  local.get 5
                  call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                  local.get 1
                  i32.lt_u
                  br_if 2 (;@5;)
                  local.get 0
                  i32.load offset=16
                  local.tee 7
                  local.get 1
                  call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$13get_unchecked17h113f998e41294299E
                  local.set 8
                  local.get 5
                  call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                  local.get 4
                  i32.lt_u
                  br_if 3 (;@4;)
                  local.get 7
                  local.get 4
                  call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
                  local.get 8
                  i64.extend_i32_u
                  call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h91fb4a3d60b83d69E
                  br 5 (;@2;)
                end
                i32.const 1049831
                i32.const 21
                call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
                unreachable
              end
              i32.const 1049960
              i32.const 18
              call $signalError
              unreachable
            end
            i32.const 1049960
            i32.const 18
            call $signalError
            unreachable
          end
          i32.const 1049960
          i32.const 18
          call $signalError
          unreachable
        end
        i32.const 1049879
        i32.const 30
        call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
        unreachable
      end
      block  ;; label = @2
        local.get 5
        call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
        local.get 1
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 1049960
        i32.const 18
        call $signalError
        unreachable
      end
      local.get 0
      i32.load offset=16
      local.get 1
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$8item_key17h904aca8a6a702d25E
      call $_ZN13multiversx_sc7storage11storage_set13storage_clear17he483ef5d230142d2E
      local.get 5
      local.get 1
      i32.const -1
      i32.add
      call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$10save_count17hd0922b1b82d7e157E
      block  ;; label = @2
        local.get 6
        br_if 0 (;@2;)
        local.get 3
        local.get 8
        local.get 4
        call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$9set_index17h0593f760e658c57eE
      end
      local.get 3
      local.get 2
      call $_ZN13multiversx_sc7storage7mappers20unordered_set_mapper32UnorderedSetMapper$LT$SA$C$T$GT$11clear_index17h507f4f1a1f926b4eE
    end
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $discardAction (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig14multisig_state19MultisigStateModule22get_caller_id_and_role17h3502b5bac4a03605E
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load8_u offset=12
        i32.const -1
        i32.add
        i32.const 1
        i32.gt_u
        br_if 0 (;@2;)
        local.get 1
        call $_ZN8multisig14multisig_state19MultisigStateModule29get_action_valid_signer_count17hb535030249e14c32E
        br_if 1 (;@1;)
        local.get 1
        call $_ZN8multisig16multisig_perform21MultisigPerformModule12clear_action17hd235a2c1ca188cbdE
        local.get 0
        i32.const 16
        i32.add
        global.set $__stack_pointer
        return
      end
      i32.const 1049674
      i32.const 52
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
      unreachable
    end
    i32.const 1049726
    i32.const 43
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
    unreachable)
  (func $getQuorum (type 13)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E
    call $_ZN13multiversx_sc2io6finish12finish_multi17h03e27614146b8951E)
  (func $getNumBoardMembers (type 13)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E
    call $_ZN13multiversx_sc2io6finish12finish_multi17h03e27614146b8951E)
  (func $getNumProposers (type 13)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13num_proposers17hb7bb5ad9f3d939ffE
    call $_ZN13multiversx_sc2io6finish12finish_multi17h03e27614146b8951E)
  (func $getActionLastIndex (type 13)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    call $_ZN8multisig14multisig_state19MultisigStateModule21get_action_last_index17hcdc6ade39ecaa28bE
    i64.extend_i32_u
    call $smallIntFinishUnsigned)
  (func $proposeAddBoardMember (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049552
    i32.const 20
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    local.get 0
    i32.const 1
    i32.store16 offset=8
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $proposeAddProposer (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049526
    i32.const 16
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    local.get 0
    i32.const 2
    i32.store16 offset=8
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $proposeRemoveUser (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049514
    i32.const 12
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    local.get 0
    i32.const 3
    i32.store16 offset=8
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $proposeChangeQuorum (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049542
    i32.const 10
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 4
    i32.store16 offset=8
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $proposeTransferExecute (type 13)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
    i32.const 2
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E
    i32.const 0
    i32.const 1049512
    i32.const 2
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc854eba343585468E
    local.set 2
    local.get 0
    i32.const 2
    i32.store offset=8
    local.get 0
    local.get 0
    i32.const 8
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17he03d13e4046ecfb7E
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 0
    i32.load
    local.set 4
    local.get 0
    local.get 0
    i32.load offset=8
    i32.store offset=24
    local.get 0
    i32.const 24
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h161ad9414a385821E
    local.set 5
    local.get 0
    i32.load offset=24
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE
    local.get 0
    i32.const 8
    i32.add
    local.get 1
    local.get 2
    local.get 4
    local.get 3
    local.get 5
    call $_ZN8multisig16multisig_propose21MultisigProposeModule17prepare_call_data17h213e26757802370bE
    local.get 0
    i32.const 36
    i32.add
    local.get 0
    i32.const 16
    i32.add
    i64.load
    i64.store align=4
    local.get 0
    local.get 0
    i64.load offset=8
    i64.store offset=28 align=4
    local.get 0
    i32.const 5
    i32.store16 offset=24
    local.get 0
    i32.const 24
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $proposeAsyncCall (type 13)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
    i32.const 2
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E
    i32.const 0
    i32.const 1049512
    i32.const 2
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc854eba343585468E
    local.set 2
    local.get 0
    i32.const 2
    i32.store offset=8
    local.get 0
    local.get 0
    i32.const 8
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17he03d13e4046ecfb7E
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 0
    i32.load
    local.set 4
    local.get 0
    local.get 0
    i32.load offset=8
    i32.store offset=24
    local.get 0
    i32.const 24
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h161ad9414a385821E
    local.set 5
    local.get 0
    i32.load offset=24
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE
    local.get 0
    i32.const 8
    i32.add
    local.get 1
    local.get 2
    local.get 4
    local.get 3
    local.get 5
    call $_ZN8multisig16multisig_propose21MultisigProposeModule17prepare_call_data17h213e26757802370bE
    local.get 0
    i32.const 36
    i32.add
    local.get 0
    i32.const 16
    i32.add
    i64.load
    i64.store align=4
    local.get 0
    local.get 0
    i64.load offset=8
    i64.store offset=28 align=4
    local.get 0
    i32.const 6
    i32.store16 offset=24
    local.get 0
    i32.const 24
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $proposeSCDeployFromSource (type 13)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
    i32.const 3
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc854eba343585468E
    local.set 1
    i32.const 1
    i32.const 1049585
    i32.const 6
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 2
    i32.const 2
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h2896e88c1eba2d5eE
    local.set 3
    local.get 0
    i32.const 3
    i32.store offset=8
    local.get 0
    i32.const 8
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h161ad9414a385821E
    local.set 4
    local.get 0
    i32.load offset=8
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE
    local.get 0
    local.get 2
    i32.store offset=16
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    local.get 4
    i32.store offset=20
    local.get 0
    local.get 3
    i32.store16 offset=10
    local.get 0
    i32.const 7
    i32.store16 offset=8
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $proposeSCUpgradeFromSource (type 13)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
    i32.const 4
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E
    i32.const 0
    i32.const 1049591
    i32.const 10
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 1
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc854eba343585468E
    local.set 2
    i32.const 2
    i32.const 1049585
    i32.const 6
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 3
    i32.const 3
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h2896e88c1eba2d5eE
    local.set 4
    local.get 0
    i32.const 4
    i32.store offset=8
    local.get 0
    i32.const 8
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h161ad9414a385821E
    local.set 5
    local.get 0
    i32.load offset=8
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE
    local.get 0
    local.get 3
    i32.store offset=20
    local.get 0
    local.get 2
    i32.store offset=16
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    local.get 5
    i32.store offset=24
    local.get 0
    local.get 4
    i32.store16 offset=10
    local.get 0
    i32.const 8
    i32.store16 offset=8
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig16multisig_propose21MultisigProposeModule14propose_action17h5a5c724652c5b511E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $quorumReached (type 13)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    call $_ZN8multisig16multisig_perform21MultisigPerformModule14quorum_reached17h6ed0ba2d25403347E
    i64.extend_i32_u
    call $smallIntFinishSigned)
  (func $performAction (type 13)
    (local i32 i32 i32 i32 i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 8
    i32.add
    call $_ZN8multisig14multisig_state19MultisigStateModule22get_caller_id_and_role17h3502b5bac4a03605E
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u offset=12
          i32.const -1
          i32.add
          i32.const 1
          i32.gt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 1
                  call $_ZN8multisig16multisig_perform21MultisigPerformModule14quorum_reached17h6ed0ba2d25403347E
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 0
                  call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
                  local.get 0
                  i32.const 16
                  i32.add
                  local.get 0
                  i32.load
                  local.get 0
                  i32.load offset=4
                  local.get 1
                  call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3get17h7754dbc65332b78bE
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      local.get 0
                                      i32.load16_u offset=16
                                      br_table 0 (;@17;) 1 (;@16;) 2 (;@15;) 3 (;@14;) 4 (;@13;) 5 (;@12;) 6 (;@11;) 7 (;@10;) 8 (;@9;) 0 (;@17;)
                                    end
                                    local.get 0
                                    i32.const 0
                                    i32.store16 offset=40
                                    br 8 (;@8;)
                                  end
                                  local.get 0
                                  i32.load offset=20
                                  call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                                  local.set 2
                                  local.get 0
                                  i32.const 1
                                  i32.store16 offset=40
                                  local.get 0
                                  local.get 2
                                  i32.store offset=44
                                  br 7 (;@8;)
                                end
                                local.get 0
                                i32.load offset=20
                                call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                                local.set 2
                                local.get 0
                                i32.const 2
                                i32.store16 offset=40
                                local.get 0
                                local.get 2
                                i32.store offset=44
                                br 6 (;@8;)
                              end
                              local.get 0
                              i32.load offset=20
                              call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                              local.set 2
                              local.get 0
                              i32.const 3
                              i32.store16 offset=40
                              local.get 0
                              local.get 2
                              i32.store offset=44
                              br 5 (;@8;)
                            end
                            local.get 0
                            local.get 0
                            i32.load offset=20
                            i32.store offset=44
                            local.get 0
                            i32.const 4
                            i32.store16 offset=40
                            br 4 (;@8;)
                          end
                          local.get 0
                          i32.const 40
                          i32.add
                          i32.const 4
                          i32.or
                          local.get 0
                          i32.const 16
                          i32.add
                          i32.const 4
                          i32.or
                          call $_ZN80_$LT$multisig..action..CallActionData$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h4cf80c9a93a31b3cE
                          local.get 0
                          i32.const 5
                          i32.store16 offset=40
                          br 3 (;@8;)
                        end
                        local.get 0
                        i32.const 40
                        i32.add
                        i32.const 4
                        i32.or
                        local.get 0
                        i32.const 16
                        i32.add
                        i32.const 4
                        i32.or
                        call $_ZN80_$LT$multisig..action..CallActionData$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h4cf80c9a93a31b3cE
                        local.get 0
                        i32.const 6
                        i32.store16 offset=40
                        br 2 (;@8;)
                      end
                      local.get 0
                      i32.load offset=20
                      call $_ZN103_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h47cb92ae47e84177E
                      local.set 2
                      local.get 0
                      i32.load offset=24
                      call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                      local.set 3
                      local.get 0
                      i32.load16_u offset=18
                      local.set 4
                      local.get 0
                      i32.const 28
                      i32.add
                      call $_ZN115_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h3ddfd7b7e279dbcfE
                      local.set 5
                      local.get 0
                      local.get 3
                      i32.store offset=48
                      local.get 0
                      local.get 2
                      i32.store offset=44
                      local.get 0
                      local.get 5
                      i32.store offset=52
                      local.get 0
                      local.get 4
                      i32.store16 offset=42
                      local.get 0
                      i32.const 7
                      i32.store16 offset=40
                      br 1 (;@8;)
                    end
                    local.get 0
                    i32.load offset=20
                    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                    local.set 2
                    local.get 0
                    i32.load offset=24
                    call $_ZN103_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h47cb92ae47e84177E
                    local.set 3
                    local.get 0
                    i32.load offset=28
                    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
                    local.set 4
                    local.get 0
                    i32.load16_u offset=18
                    local.set 5
                    local.get 0
                    i32.const 32
                    i32.add
                    call $_ZN115_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h3ddfd7b7e279dbcfE
                    local.set 6
                    local.get 0
                    local.get 4
                    i32.store offset=52
                    local.get 0
                    local.get 3
                    i32.store offset=48
                    local.get 0
                    local.get 2
                    i32.store offset=44
                    local.get 0
                    local.get 6
                    i32.store offset=56
                    local.get 0
                    local.get 5
                    i32.store16 offset=42
                    local.get 0
                    i32.const 8
                    i32.store16 offset=40
                  end
                  local.get 1
                  call $_ZN8multisig14multisig_state19MultisigStateModule18get_action_signers17h13c78cd7b88aa257E
                  local.set 2
                  local.get 0
                  i32.const 64
                  i32.add
                  i32.const 16
                  i32.add
                  local.get 0
                  i32.const 40
                  i32.add
                  i32.const 8
                  i32.add
                  local.tee 3
                  i64.load
                  i64.store
                  local.get 0
                  i32.const 64
                  i32.add
                  i32.const 24
                  i32.add
                  local.tee 4
                  local.get 0
                  i32.const 40
                  i32.add
                  i32.const 16
                  i32.add
                  i32.load
                  i32.store
                  local.get 0
                  local.get 1
                  i32.store offset=64
                  local.get 0
                  local.get 2
                  i32.store offset=68
                  local.get 0
                  local.get 0
                  i64.load offset=40
                  i64.store offset=72
                  i32.const 1049047
                  i32.const 18
                  call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
                  local.set 2
                  local.get 0
                  call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
                  i32.store offset=40
                  local.get 0
                  i32.const 64
                  i32.add
                  local.get 0
                  i32.const 40
                  i32.add
                  call $_ZN108_$LT$multisig..action..ActionFullInfo$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_en..TopEncode$GT$24top_encode_or_handle_err17hc8c6ffa8e90456deE
                  local.get 2
                  local.get 0
                  i32.load offset=40
                  call $managedWriteLog
                  local.get 1
                  call $_ZN8multisig16multisig_perform21MultisigPerformModule12clear_action17hd235a2c1ca188cbdE
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 0
                              i32.load16_u offset=16
                              br_table 9 (;@4;) 7 (;@6;) 5 (;@8;) 4 (;@9;) 3 (;@10;) 0 (;@13;) 1 (;@12;) 8 (;@5;) 2 (;@11;) 9 (;@4;)
                            end
                            local.get 0
                            i32.const 64
                            i32.add
                            i32.const 8
                            i32.add
                            local.get 0
                            i32.const 16
                            i32.add
                            i32.const 12
                            i32.add
                            i64.load align=4
                            i64.store
                            local.get 0
                            local.get 0
                            i64.load offset=20 align=4
                            i64.store offset=64
                            call $getGasLeft
                            local.tee 7
                            i64.const 300000
                            i64.le_u
                            br_if 10 (;@2;)
                            i32.const 1049084
                            i32.const 22
                            call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
                            local.tee 2
                            local.get 1
                            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
                            local.get 2
                            local.get 0
                            i32.load offset=64
                            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE
                            local.get 2
                            local.get 0
                            i32.load offset=68
                            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h2d7c67d0d6763b7eE
                            local.get 2
                            local.get 7
                            i64.const -300000
                            i64.add
                            local.tee 7
                            call $_ZN13multiversx_sc8log_util21serialize_event_topic17hd9b6d56d5e2ed0feE
                            local.get 2
                            local.get 0
                            i32.const 72
                            i32.add
                            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h84c03ea503a16905E
                            local.get 2
                            local.get 0
                            i32.const 64
                            i32.add
                            i32.const 12
                            i32.add
                            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h57c642cdbff22166E
                            local.get 2
                            call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
                            call $managedWriteLog
                            local.get 0
                            i32.load offset=64
                            local.get 0
                            i32.load offset=68
                            local.get 7
                            local.get 0
                            i32.load offset=72
                            local.get 0
                            i32.load offset=76
                            call $managedTransferValueExecute
                            i32.eqz
                            br_if 8 (;@4;)
                            call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17h43dc5d04504fd327E
                            unreachable
                          end
                          local.get 3
                          local.get 0
                          i32.const 16
                          i32.add
                          i32.const 12
                          i32.add
                          i64.load align=4
                          i64.store
                          local.get 0
                          local.get 0
                          i64.load offset=20 align=4
                          i64.store offset=40
                          call $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$12get_gas_left17h92f14e8828e57febE
                          local.set 7
                          local.get 1
                          local.get 0
                          i32.load offset=40
                          local.get 0
                          i32.load offset=44
                          local.get 7
                          local.get 3
                          local.get 0
                          i32.const 40
                          i32.add
                          i32.const 12
                          i32.add
                          call $_ZN69_$LT$C$u20$as$u20$multisig..multisig_events..MultisigEventsModule$GT$24perform_async_call_event17h9554d87350bca7dcE
                          local.get 3
                          i32.load
                          local.set 1
                          local.get 0
                          i32.load offset=40
                          local.set 2
                          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
                          drop
                          local.get 0
                          i32.load offset=44
                          local.set 3
                          local.get 0
                          i32.load offset=52
                          local.set 5
                          local.get 4
                          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
                          i32.store
                          local.get 0
                          i32.const 84
                          i32.add
                          i32.const 27
                          i32.store
                          local.get 0
                          i32.const 1049273
                          i32.store offset=80
                          local.get 0
                          local.get 5
                          i32.store offset=76
                          local.get 0
                          local.get 1
                          i32.store offset=72
                          local.get 0
                          local.get 3
                          i32.store offset=68
                          local.get 0
                          local.get 2
                          i32.store offset=64
                          local.get 0
                          i32.const 64
                          i32.add
                          call $_ZN13multiversx_sc5types11interaction10async_call19AsyncCall$LT$SA$GT$13call_and_exit17h155fa10fab4fa1f5E
                          unreachable
                        end
                        local.get 0
                        i32.load16_u offset=18
                        local.set 3
                        local.get 0
                        i32.load offset=28
                        local.set 4
                        local.get 0
                        i32.load offset=24
                        local.set 5
                        local.get 0
                        i32.load offset=20
                        local.set 6
                        local.get 0
                        local.get 0
                        i32.load offset=32
                        i32.store offset=64
                        call $getGasLeft
                        local.set 7
                        i32.const 1049129
                        i32.const 24
                        call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
                        local.tee 2
                        local.get 1
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
                        local.get 2
                        local.get 6
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE
                        local.get 2
                        local.get 5
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h2d7c67d0d6763b7eE
                        local.get 2
                        local.get 4
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE
                        local.get 2
                        local.get 3
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h32025846d90d4b3eE
                        local.get 2
                        local.get 7
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17hd9b6d56d5e2ed0feE
                        local.get 2
                        local.get 0
                        i32.const 64
                        i32.add
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h57c642cdbff22166E
                        local.get 2
                        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
                        call $managedWriteLog
                        local.get 0
                        i32.load offset=64
                        local.set 1
                        local.get 6
                        local.get 7
                        local.get 5
                        local.get 4
                        local.get 3
                        call $_ZN26multiversx_sc_wasm_adapter3api13send_api_node30code_metadata_to_buffer_handle17heb1a75d5d738b5a4E
                        local.get 1
                        i32.const -25
                        call $managedUpgradeFromSourceContract
                        br 6 (;@4;)
                      end
                      block  ;; label = @10
                        local.get 0
                        i32.load offset=20
                        local.tee 2
                        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E
                        call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                        i32.gt_u
                        br_if 0 (;@10;)
                        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E
                        local.get 2
                        call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3set17hc87e9a1b2e12d8a3E
                        i32.const 1049065
                        i32.const 19
                        call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
                        local.tee 3
                        local.get 1
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
                        local.get 3
                        local.get 2
                        call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
                        local.get 3
                        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
                        call $managedWriteLog
                        br 6 (;@4;)
                      end
                      i32.const 1049311
                      i32.const 31
                      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
                      unreachable
                    end
                    local.get 1
                    local.get 0
                    i32.load offset=20
                    i32.const 0
                    call $_ZN8multisig16multisig_perform21MultisigPerformModule16change_user_role17hc5b4803d3a527bc4E
                    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E
                    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                    local.tee 1
                    i32.const 0
                    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13num_proposers17hb7bb5ad9f3d939ffE
                    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                    i32.sub
                    i32.eq
                    br_if 7 (;@1;)
                    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E
                    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                    local.get 1
                    i32.le_u
                    br_if 4 (;@4;)
                    i32.const 1049311
                    i32.const 31
                    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
                    unreachable
                  end
                  local.get 1
                  local.get 0
                  i32.load offset=20
                  i32.const 1
                  call $_ZN8multisig16multisig_perform21MultisigPerformModule16change_user_role17hc5b4803d3a527bc4E
                  call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$6quorum17hab20381ddf58f039E
                  call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                  call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17num_board_members17hc9fce9d2780d5e06E
                  call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
                  i32.le_u
                  br_if 3 (;@4;)
                  i32.const 1049311
                  i32.const 31
                  call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
                  unreachable
                end
                i32.const 1049464
                i32.const 27
                call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
                unreachable
              end
              local.get 1
              local.get 0
              i32.load offset=20
              i32.const 2
              call $_ZN8multisig16multisig_perform21MultisigPerformModule16change_user_role17hc5b4803d3a527bc4E
              br 1 (;@4;)
            end
            local.get 0
            i32.load16_u offset=18
            local.set 3
            local.get 0
            i32.load offset=24
            local.set 4
            local.get 0
            i32.load offset=20
            local.set 5
            local.get 0
            local.get 0
            i32.load offset=28
            i32.store offset=64
            call $getGasLeft
            local.set 7
            i32.const 1049106
            i32.const 23
            call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
            local.tee 2
            local.get 1
            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h8e058bd09633f61eE
            local.get 2
            local.get 5
            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h2d7c67d0d6763b7eE
            local.get 2
            local.get 4
            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h5178a617098a32ceE
            local.get 2
            local.get 3
            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h32025846d90d4b3eE
            local.get 2
            local.get 7
            call $_ZN13multiversx_sc8log_util21serialize_event_topic17hd9b6d56d5e2ed0feE
            local.get 2
            local.get 0
            i32.const 64
            i32.add
            call $_ZN13multiversx_sc8log_util21serialize_event_topic17h57c642cdbff22166E
            local.get 2
            call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
            call $managedWriteLog
            local.get 0
            i32.load offset=64
            local.set 1
            local.get 7
            local.get 5
            local.get 4
            local.get 3
            call $_ZN26multiversx_sc_wasm_adapter3api13send_api_node30code_metadata_to_buffer_handle17heb1a75d5d738b5a4E
            local.get 1
            call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
            local.tee 2
            call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
            call $managedDeployFromSourceContract
            drop
            local.get 2
            call $mBufferFinish
            drop
          end
          local.get 0
          i32.const 96
          i32.add
          global.set $__stack_pointer
          return
        end
        i32.const 1049412
        i32.const 52
        call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
        unreachable
      end
      i32.const 1049387
      i32.const 25
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
      unreachable
    end
    i32.const 1049342
    i32.const 45
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17hd08b33ae3a8c9454E
    unreachable)
  (func $_ZN26multiversx_sc_wasm_adapter3api13send_api_node30code_metadata_to_buffer_handle17heb1a75d5d738b5a4E (type 5) (param i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 1
    local.get 0
    i32.const 8
    i32.shl
    local.get 0
    i32.const 65280
    i32.and
    i32.const 8
    i32.shr_u
    i32.or
    i32.store16 offset=14
    local.get 1
    i32.const 14
    i32.add
    i32.const 2
    call $mBufferNewFromBytes
    local.set 0
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $dnsRegister (type 13)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 80
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        call $getNumESDTTransfers
        br_if 0 (;@2;)
        call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17hacc219f2de7a105bE
        local.tee 1
        call $managedOwnerAddress
        local.get 1
        call $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$10get_caller17h4351fc9dfbe955ceE
        call $mBufferEq
        i32.const 0
        i32.le_s
        br_if 1 (;@1;)
        i32.const 2
        call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
        i32.const 0
        i32.const 1048891
        i32.const 11
        call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
        local.set 1
        local.get 0
        call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h51e24df5548903bfE
        i32.store offset=12
        call $_ZN13multiversx_sc13contract_base8wrappers18call_value_wrapper25CallValueWrapper$LT$A$GT$10egld_value17h702a752be0274997E
        local.set 2
        local.get 0
        local.get 1
        i32.store offset=76
        local.get 0
        i32.const 48
        i32.add
        local.get 0
        i32.const 76
        i32.add
        local.get 0
        i32.const 12
        i32.add
        call $_ZN21multiversx_sc_modules3dns9dns_proxy10ProxyTrait8register17h96025d1d86d59050E
        local.get 0
        i32.const 0
        i32.store offset=32
        local.get 0
        local.get 2
        i32.store offset=20
        local.get 0
        local.get 0
        i64.load offset=60 align=4
        i64.store offset=24
        local.get 0
        local.get 0
        i32.load offset=56
        i32.store offset=16
        local.get 0
        i32.const 16
        i32.add
        call $_ZN13multiversx_sc5types11interaction10async_call19AsyncCall$LT$SA$GT$13call_and_exit17h155fa10fab4fa1f5E
        unreachable
      end
      i32.const 1048682
      i32.const 37
      call $signalError
      unreachable
    end
    i32.const 1049924
    i32.const 36
    call $signalError
    unreachable)
  (func $getPendingActionFullInfo (type 13)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
    local.set 1
    call $_ZN8multisig14multisig_state19MultisigStateModule21get_action_last_index17hcdc6ade39ecaa28bE
    local.set 2
    local.get 0
    i32.const 16
    i32.add
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
    local.get 0
    i32.load offset=20
    local.set 3
    local.get 0
    i32.load offset=16
    local.set 4
    local.get 0
    i32.const 0
    i32.store8 offset=32
    local.get 0
    local.get 2
    i32.store offset=28
    local.get 0
    i32.const 1
    i32.store offset=24
    local.get 0
    i32.const 64
    i32.add
    i32.const 8
    i32.add
    local.set 5
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.const 8
        i32.add
        local.get 0
        i32.const 24
        i32.add
        call $_ZN4core4iter5range110_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..RangeInclusive$LT$A$GT$$GT$4next17he8209a343d477d9eE
        local.get 0
        i32.load offset=8
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        i32.const 40
        i32.add
        local.get 4
        local.get 3
        local.get 0
        i32.load offset=12
        local.tee 2
        call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3get17h7754dbc65332b78bE
        local.get 0
        i32.load16_u offset=40
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        call $_ZN8multisig14multisig_state19MultisigStateModule18get_action_signers17h13c78cd7b88aa257E
        local.set 6
        local.get 5
        local.get 0
        i64.load offset=40
        i64.store align=4
        local.get 5
        i32.const 8
        i32.add
        local.get 0
        i32.const 40
        i32.add
        i32.const 8
        i32.add
        i64.load
        i64.store align=4
        local.get 5
        i32.const 16
        i32.add
        local.get 0
        i32.const 40
        i32.add
        i32.const 16
        i32.add
        i32.load
        i32.store
        local.get 0
        local.get 2
        i32.store offset=64
        local.get 0
        local.get 6
        i32.store offset=68
        local.get 0
        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
        i32.store offset=92
        local.get 0
        i32.const 64
        i32.add
        local.get 0
        i32.const 92
        i32.add
        call $_ZN108_$LT$multisig..action..ActionFullInfo$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_en..TopEncode$GT$24top_encode_or_handle_err17hc8c6ffa8e90456deE
        local.get 1
        local.get 0
        i32.load offset=92
        call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
        br 0 (;@2;)
      end
    end
    local.get 0
    local.get 1
    i32.store offset=40
    local.get 0
    local.get 1
    call $mBufferGetLength
    i32.store offset=68
    local.get 0
    i32.const 0
    i32.store offset=64
    local.get 0
    local.get 0
    i32.const 40
    i32.add
    i32.store offset=72
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        local.get 0
        i32.const 64
        i32.add
        call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
        local.get 0
        i32.load
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        i32.load offset=4
        call $mBufferFinish
        drop
        br 0 (;@2;)
      end
    end
    local.get 0
    i32.const 96
    i32.add
    global.set $__stack_pointer)
  (func $userRole (type 13)
    (local i32)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1048937
    i32.const 4
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h43e0b77ce81e5e21E
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$11user_mapper17h73347108314e9bddE
        local.get 0
        call $_ZN13multiversx_sc7storage7mappers11user_mapper20UserMapper$LT$SA$GT$11get_user_id17h7264882f76ba5725E
        local.tee 0
        br_if 0 (;@2;)
        i32.const 1048605
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$15user_id_to_role17he51cc396e6fff62cE
      call $_ZN13multiversx_sc7storage7mappers19single_value_mapper31SingleValueMapper$LT$SA$C$T$GT$3get17h1353d63d80ca67d2E
      i32.const 255
      i32.and
      i32.const 2
      i32.shl
      i32.const 1049912
      i32.add
      i32.load
      local.set 0
    end
    local.get 0
    i32.load8_u
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned79_$LT$impl$u20$multiversx_sc_codec..single..top_en..TopEncode$u20$for$u20$u8$GT$24top_encode_or_handle_err17h53a9d68ff27a9072E)
  (func $getAllBoardMembers (type 13)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    local.get 0
    i32.const 2
    call $_ZN8multisig8Multisig23get_all_users_with_role17hd86e927a1842c1e9E
    i32.store offset=12
    local.get 0
    i32.const 12
    i32.add
    call $_ZN13multiversx_sc2io6finish12finish_multi17h21b3b2efb251f986E
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $getAllProposers (type 13)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    local.get 0
    i32.const 1
    call $_ZN8multisig8Multisig23get_all_users_with_role17hd86e927a1842c1e9E
    i32.store offset=12
    local.get 0
    i32.const 12
    i32.add
    call $_ZN13multiversx_sc2io6finish12finish_multi17h21b3b2efb251f986E
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $getActionData (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 112
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    local.set 1
    local.get 0
    i32.const 72
    i32.add
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$13action_mapper17h2486131634971b22E
    local.get 0
    i32.const 80
    i32.add
    local.get 0
    i32.load offset=72
    local.get 0
    i32.load offset=76
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers10vec_mapper23VecMapper$LT$SA$C$T$GT$3get17h7754dbc65332b78bE
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 0
                        i32.load16_u offset=80
                        br_table 0 (;@10;) 1 (;@9;) 2 (;@8;) 3 (;@7;) 4 (;@6;) 5 (;@5;) 6 (;@4;) 7 (;@3;) 8 (;@2;) 0 (;@10;)
                      end
                      i32.const 0
                      call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned79_$LT$impl$u20$multiversx_sc_codec..single..top_en..TopEncode$u20$for$u20$u8$GT$24top_encode_or_handle_err17h53a9d68ff27a9072E
                      br 8 (;@1;)
                    end
                    local.get 0
                    i32.const 8
                    i32.add
                    call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                    local.get 0
                    local.get 0
                    i32.load8_u offset=12
                    i32.store8 offset=108
                    local.get 0
                    local.get 0
                    i32.load offset=8
                    i32.store offset=104
                    i32.const 1
                    local.get 0
                    i32.const 104
                    i32.add
                    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                    local.get 0
                    i32.const 104
                    i32.add
                    local.get 0
                    i32.load offset=84
                    call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
                    local.get 0
                    i32.load offset=104
                    local.get 0
                    i32.load8_u offset=108
                    call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
                    br 7 (;@1;)
                  end
                  local.get 0
                  i32.const 16
                  i32.add
                  call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                  local.get 0
                  local.get 0
                  i32.load8_u offset=20
                  i32.store8 offset=108
                  local.get 0
                  local.get 0
                  i32.load offset=16
                  i32.store offset=104
                  i32.const 2
                  local.get 0
                  i32.const 104
                  i32.add
                  call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                  local.get 0
                  i32.const 104
                  i32.add
                  local.get 0
                  i32.load offset=84
                  call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
                  local.get 0
                  i32.load offset=104
                  local.get 0
                  i32.load8_u offset=108
                  call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
                  br 6 (;@1;)
                end
                local.get 0
                i32.const 24
                i32.add
                call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
                local.get 0
                local.get 0
                i32.load8_u offset=28
                i32.store8 offset=108
                local.get 0
                local.get 0
                i32.load offset=24
                i32.store offset=104
                i32.const 3
                local.get 0
                i32.const 104
                i32.add
                call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
                local.get 0
                i32.const 104
                i32.add
                local.get 0
                i32.load offset=84
                call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
                local.get 0
                i32.load offset=104
                local.get 0
                i32.load8_u offset=108
                call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
                br 5 (;@1;)
              end
              local.get 0
              i32.const 32
              i32.add
              call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
              local.get 0
              local.get 0
              i32.load8_u offset=36
              i32.store8 offset=108
              local.get 0
              local.get 0
              i32.load offset=32
              i32.store offset=104
              i32.const 4
              local.get 0
              i32.const 104
              i32.add
              call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
              local.get 0
              i32.load offset=84
              local.get 0
              i32.const 104
              i32.add
              call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$usize$GT$24dep_encode_or_handle_err17h3dd180332d7387d9E
              local.get 0
              i32.load offset=104
              local.get 0
              i32.load8_u offset=108
              call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
              br 4 (;@1;)
            end
            local.get 0
            i32.const 40
            i32.add
            call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
            local.get 0
            local.get 0
            i32.load8_u offset=44
            i32.store8 offset=108
            local.get 0
            local.get 0
            i32.load offset=40
            i32.store offset=104
            i32.const 5
            local.get 0
            i32.const 104
            i32.add
            call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
            local.get 0
            i32.const 80
            i32.add
            i32.const 4
            i32.or
            local.get 0
            i32.const 104
            i32.add
            call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h67cca4e75573e390E
            local.get 0
            i32.load offset=104
            local.get 0
            i32.load8_u offset=108
            call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
            br 3 (;@1;)
          end
          local.get 0
          i32.const 48
          i32.add
          call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
          local.get 0
          local.get 0
          i32.load8_u offset=52
          i32.store8 offset=108
          local.get 0
          local.get 0
          i32.load offset=48
          i32.store offset=104
          i32.const 6
          local.get 0
          i32.const 104
          i32.add
          call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
          local.get 0
          i32.const 80
          i32.add
          i32.const 4
          i32.or
          local.get 0
          i32.const 104
          i32.add
          call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17h67cca4e75573e390E
          local.get 0
          i32.load offset=104
          local.get 0
          i32.load8_u offset=108
          call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
          br 2 (;@1;)
        end
        local.get 0
        i32.const 56
        i32.add
        call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
        local.get 0
        local.get 0
        i32.load8_u offset=60
        i32.store8 offset=108
        local.get 0
        local.get 0
        i32.load offset=56
        i32.store offset=104
        i32.const 7
        local.get 0
        i32.const 104
        i32.add
        call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
        local.get 0
        i32.load offset=84
        local.get 0
        i32.const 104
        i32.add
        call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h9acead432087e203E
        local.get 0
        i32.const 104
        i32.add
        local.get 0
        i32.load offset=88
        call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
        local.get 0
        i32.const 80
        i32.add
        i32.const 2
        i32.or
        local.get 0
        i32.const 104
        i32.add
        call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17hb230d5f3a978c754E
        local.get 0
        i32.const 92
        i32.add
        local.get 0
        i32.const 104
        i32.add
        call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E
        local.get 0
        i32.load offset=104
        local.get 0
        i32.load8_u offset=108
        call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
        br 1 (;@1;)
      end
      local.get 0
      i32.const 64
      i32.add
      call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
      local.get 0
      local.get 0
      i32.load8_u offset=68
      i32.store8 offset=108
      local.get 0
      local.get 0
      i32.load offset=64
      i32.store offset=104
      i32.const 8
      local.get 0
      i32.const 104
      i32.add
      call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned85_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u8$GT$24dep_encode_or_handle_err17ha464dc42d3c2ae3aE
      local.get 0
      i32.const 104
      i32.add
      local.get 0
      i32.load offset=84
      call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
      local.get 0
      i32.load offset=88
      local.get 0
      i32.const 104
      i32.add
      call $_ZN137_$LT$multiversx_sc..types..managed..basic..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h9acead432087e203E
      local.get 0
      i32.const 104
      i32.add
      local.get 0
      i32.load offset=92
      call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
      local.get 0
      i32.const 80
      i32.add
      i32.const 2
      i32.or
      local.get 0
      i32.const 104
      i32.add
      call $_ZN19multiversx_sc_codec14impl_for_types8impl_ref88_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$$RF$T$GT$24dep_encode_or_handle_err17hb230d5f3a978c754E
      local.get 0
      i32.const 96
      i32.add
      local.get 0
      i32.const 104
      i32.add
      call $_ZN149_$LT$multiversx_sc..types..managed..wrapped..managed_vec..ManagedVec$LT$M$C$T$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h0d571feafaeb8a41E
      local.get 0
      i32.load offset=104
      local.get 0
      i32.load8_u offset=108
      call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
    end
    local.get 0
    i32.const 112
    i32.add
    global.set $__stack_pointer)
  (func $getActionSigners (type 13)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    local.get 0
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    call $_ZN8multisig14multisig_state19MultisigStateModule18get_action_signers17h13c78cd7b88aa257E
    local.tee 1
    i32.store offset=20
    local.get 0
    i32.const 8
    i32.add
    call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17hebe00cfeb4e36d55E
    local.get 0
    local.get 0
    i32.load8_u offset=12
    i32.store8 offset=28
    local.get 0
    local.get 0
    i32.load offset=8
    i32.store offset=24
    local.get 0
    local.get 1
    call $mBufferGetLength
    i32.store offset=36
    local.get 0
    i32.const 0
    i32.store offset=32
    local.get 0
    local.get 0
    i32.const 20
    i32.add
    i32.store offset=40
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        local.get 0
        i32.const 32
        i32.add
        call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
        local.get 0
        i32.load
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        i32.const 24
        i32.add
        local.get 0
        i32.load offset=4
        call $_ZN192_$LT$multiversx_sc..types..managed..wrapped..managed_buffer_cached_builder..ManagedBufferCachedBuilder$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en_output..NestedEncodeOutput$GT$16push_specialized17h9a6f8ab55213bbf7E
        br 0 (;@2;)
      end
    end
    local.get 0
    i32.load offset=24
    local.get 0
    i32.load8_u offset=28
    call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$22finalize_nested_encode17h6c77d10d8ca2d5d8E
    local.get 0
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $getActionSignerCount (type 13)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    local.get 0
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    call $_ZN67_$LT$C$u20$as$u20$multisig..multisig_state..MultisigStateModule$GT$17action_signer_ids17h4a46b209064f9661E
    local.get 0
    i32.load offset=4
    call $_ZN13multiversx_sc7storage11storage_get11storage_get17h98bfd6e4d9fc5c28E
    i64.extend_i32_u
    call $smallIntFinishUnsigned
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $getActionValidSignerCount (type 13)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17h1f8ffe2c6b0e5e8dE
    i32.const 0
    i32.const 1049183
    i32.const 9
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17hc6471e0f0525168dE
    call $_ZN8multisig14multisig_state19MultisigStateModule29get_action_valid_signer_count17hb535030249e14c32E
    i64.extend_i32_u
    call $smallIntFinishUnsigned)
  (func $callBack (type 13)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 112
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          call $_ZN13multiversx_sc5types11interaction16callback_closure22cb_closure_storage_key17hc1c8d77daac2d192E
          local.tee 1
          call $_ZN143_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_de..TopDecode$GT$24top_decode_or_handle_err17hdb6405115833d70bE
          local.tee 2
          call $mBufferGetLength
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          i32.const 56
          i32.add
          local.get 2
          call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h1d1857286e0877e1E
          call $_ZN13multiversx_sc5types7managed10codec_util30managed_buffer_nested_de_input39ManagedBufferNestedDecodeInput$LT$M$GT$3new17h0f552cb474e5f85eE
          local.get 0
          i32.const 56
          i32.add
          call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h39a7c33210bdbf32E
          local.set 3
          local.get 0
          i32.const 56
          i32.add
          call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned88_$LT$impl$u20$multiversx_sc_codec..single..nested_de..NestedDecode$u20$for$u20$usize$GT$24dep_decode_or_handle_err17hc01bfdc41ecf0dc2E
          local.set 2
          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
          local.set 4
          block  ;; label = @4
            loop  ;; label = @5
              local.get 2
              i32.eqz
              br_if 1 (;@4;)
              local.get 4
              local.get 0
              i32.const 56
              i32.add
              call $_ZN149_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de..NestedDecode$GT$24dep_decode_or_handle_err17h39a7c33210bdbf32E
              call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
              local.get 2
              i32.const -1
              i32.add
              local.set 2
              br 0 (;@5;)
            end
          end
          local.get 0
          i32.load offset=60
          local.get 0
          i32.load offset=56
          i32.ne
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 0
            i32.const 72
            i32.add
            i32.load8_u
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            i32.const 0
            i32.store offset=1060000
            i32.const 0
            i32.const 0
            i32.store8 offset=1060004
          end
          local.get 1
          call $_ZN13multiversx_sc7storage11storage_set13storage_clear17he483ef5d230142d2E
          local.get 0
          i32.const 16
          i32.add
          local.get 3
          call $_ZN13multiversx_sc5types11interaction16callback_closure32CallbackClosureForDeser$LT$M$GT$7matcher17h9aa0086f5c7eb0c5E
          local.get 0
          i32.load offset=48
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          i32.const 56
          i32.add
          local.get 3
          call $_ZN13multiversx_sc5types11interaction16callback_closure32CallbackClosureForDeser$LT$M$GT$7matcher17h9aa0086f5c7eb0c5E
          local.get 0
          i32.load offset=88
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          i32.const 56
          i32.add
          local.get 3
          call $_ZN13multiversx_sc5types11interaction16callback_closure32CallbackClosureForDeser$LT$M$GT$7matcher17h9aa0086f5c7eb0c5E
          local.get 0
          i32.load offset=88
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          i32.const 27
          i32.ne
          br_if 2 (;@1;)
          local.get 0
          i32.const 56
          i32.add
          i32.const 1049273
          i32.const 27
          call $memcmp
          br_if 2 (;@1;)
          call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
          i32.const 0
          call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17h6466f1de6d4fb314E
          local.get 0
          i32.const 0
          i32.store offset=92
          local.get 0
          i32.const 96
          i32.add
          local.get 0
          i32.const 92
          i32.add
          call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17hbfd9dd5c7f018d09E
          local.get 0
          i32.load offset=92
          call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4c49652c29ef73eeE
          local.get 0
          i32.load offset=96
          local.set 2
          local.get 0
          i32.load offset=100
          local.set 3
          local.get 0
          i32.load offset=104
          local.set 1
          local.get 4
          call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$3len17h326da4425d923b01E
          local.set 4
          call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h930c19accd316b3aE
          local.get 4
          i32.const 0
          call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17h4e6e03f38a0e438bE
          block  ;; label = @4
            local.get 2
            br_if 0 (;@4;)
            i32.const 1049167
            i32.const 16
            call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
            local.set 2
            local.get 0
            local.get 3
            i32.store offset=92
            local.get 0
            local.get 3
            call $mBufferGetLength
            i32.store offset=100
            local.get 0
            i32.const 0
            i32.store offset=96
            local.get 0
            local.get 0
            i32.const 92
            i32.add
            i32.store offset=104
            block  ;; label = @5
              loop  ;; label = @6
                local.get 0
                i32.const 8
                i32.add
                local.get 0
                i32.const 96
                i32.add
                call $_ZN159_$LT$multiversx_sc..types..managed..wrapped..managed_vec_owned_iter..ManagedVecOwnedIterator$LT$M$C$T$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17h3d46cbbdd522bb84E
                local.get 0
                i32.load offset=8
                i32.eqz
                br_if 1 (;@5;)
                local.get 0
                i32.load offset=12
                local.get 2
                call $_ZN78_$LT$T$u20$as$u20$multiversx_sc_codec..multi..top_en_multi..TopEncodeMulti$GT$26multi_encode_or_handle_err17h004f8c534baa540fE
                br 0 (;@6;)
              end
            end
            local.get 2
            call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
            call $managedWriteLog
            br 1 (;@3;)
          end
          i32.const 1049153
          i32.const 14
          call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h642712de8dd26241E
          local.set 2
          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
          local.tee 4
          local.get 3
          i64.extend_i32_u
          call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hfaa77095a04c3951E
          local.get 2
          local.get 4
          call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17h3898fc8ead3b22b5E
          local.get 1
          local.get 2
          call $_ZN78_$LT$T$u20$as$u20$multiversx_sc_codec..multi..top_en_multi..TopEncodeMulti$GT$26multi_encode_or_handle_err17h004f8c534baa540fE
          local.get 2
          call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h7620a2e5b0eb066dE
          call $managedWriteLog
        end
        local.get 0
        i32.const 112
        i32.add
        global.set $__stack_pointer
        return
      end
      i32.const 1048631
      i32.const 25
      i32.const 1048589
      i32.const 14
      call $_ZN161_$LT$multiversx_sc..contract_base..wrappers..serializer..ExitCodecErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h7535ef1e83cf0b60E
      unreachable
    end
    i32.const 1049214
    i32.const 54
    call $signalError
    unreachable)
  (func $_ZN4core9panicking9panic_fmt17h4c9b8223c2dfa034E (type 13)
    call $rust_begin_unwind
    unreachable)
  (func $_ZN4core9panicking18panic_bounds_check17h38fbb319fd348cd4E (type 13)
    call $_ZN4core9panicking9panic_fmt17h4c9b8223c2dfa034E
    unreachable)
  (func $_ZN4core5slice5index26slice_start_index_len_fail17h5738b4a31f480daeE (type 6) (param i32)
    local.get 0
    call $_ZN4core5slice5index29slice_start_index_len_fail_rt17h83b106d181dd1429E
    unreachable)
  (func $_ZN4core5slice5index29slice_start_index_len_fail_rt17h83b106d181dd1429E (type 6) (param i32)
    call $_ZN4core9panicking9panic_fmt17h4c9b8223c2dfa034E
    unreachable)
  (func $_ZN4core5slice5index25slice_index_order_fail_rt17h9bf230a0cb7458abE (type 2) (param i32 i32)
    call $_ZN4core9panicking9panic_fmt17h4c9b8223c2dfa034E
    unreachable)
  (func $_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$15copy_from_slice17len_mismatch_fail17h65f99ae80ba3658aE (type 2) (param i32 i32)
    call $_ZN4core9panicking9panic_fmt17h4c9b8223c2dfa034E
    unreachable)
  (func $_ZN17compiler_builtins3mem6memcpy17h21be155e91de0eb4E (type 8) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.const 15
        i32.gt_u
        br_if 0 (;@2;)
        local.get 0
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      i32.const 0
      local.get 0
      i32.sub
      i32.const 3
      i32.and
      local.tee 4
      i32.add
      local.set 5
      block  ;; label = @2
        local.get 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.set 3
        local.get 1
        local.set 6
        loop  ;; label = @3
          local.get 3
          local.get 6
          i32.load8_u
          i32.store8
          local.get 6
          i32.const 1
          i32.add
          local.set 6
          local.get 3
          i32.const 1
          i32.add
          local.tee 3
          local.get 5
          i32.lt_u
          br_if 0 (;@3;)
        end
      end
      local.get 5
      local.get 2
      local.get 4
      i32.sub
      local.tee 7
      i32.const -4
      i32.and
      local.tee 8
      i32.add
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          local.get 4
          i32.add
          local.tee 9
          i32.const 3
          i32.and
          local.tee 6
          i32.eqz
          br_if 0 (;@3;)
          local.get 8
          i32.const 1
          i32.lt_s
          br_if 1 (;@2;)
          local.get 9
          i32.const -4
          i32.and
          local.tee 10
          i32.const 4
          i32.add
          local.set 1
          i32.const 0
          local.get 6
          i32.const 3
          i32.shl
          local.tee 2
          i32.sub
          i32.const 24
          i32.and
          local.set 4
          local.get 10
          i32.load
          local.set 6
          loop  ;; label = @4
            local.get 5
            local.get 6
            local.get 2
            i32.shr_u
            local.get 1
            i32.load
            local.tee 6
            local.get 4
            i32.shl
            i32.or
            i32.store
            local.get 1
            i32.const 4
            i32.add
            local.set 1
            local.get 5
            i32.const 4
            i32.add
            local.tee 5
            local.get 3
            i32.lt_u
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        local.get 8
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 9
        local.set 1
        loop  ;; label = @3
          local.get 5
          local.get 1
          i32.load
          i32.store
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 5
          i32.const 4
          i32.add
          local.tee 5
          local.get 3
          i32.lt_u
          br_if 0 (;@3;)
        end
      end
      local.get 7
      i32.const 3
      i32.and
      local.set 2
      local.get 9
      local.get 8
      i32.add
      local.set 1
    end
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
      local.get 2
      i32.add
      local.set 5
      loop  ;; label = @2
        local.get 3
        local.get 1
        i32.load8_u
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 3
        i32.const 1
        i32.add
        local.tee 3
        local.get 5
        i32.lt_u
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $_ZN17compiler_builtins3mem6memcmp17h753068ba860f34f1E (type 8) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 3
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          i32.load8_u
          local.tee 4
          local.get 1
          i32.load8_u
          local.tee 5
          i32.ne
          br_if 1 (;@2;)
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          i32.eqz
          br_if 2 (;@1;)
          br 0 (;@3;)
        end
      end
      local.get 4
      local.get 5
      i32.sub
      local.set 3
    end
    local.get 3)
  (func $memcpy (type 8) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $_ZN17compiler_builtins3mem6memcpy17h21be155e91de0eb4E)
  (func $memcmp (type 8) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $_ZN17compiler_builtins3mem6memcmp17h753068ba860f34f1E)
  (memory (;0;) 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1060013))
  (global (;2;) i32 (i32.const 1060016))
  (export "memory" (memory 0))
  (export "init" (func $init))
  (export "deposit" (func $deposit))
  (export "signed" (func $signed))
  (export "sign" (func $sign))
  (export "unsign" (func $unsign))
  (export "discardAction" (func $discardAction))
  (export "getQuorum" (func $getQuorum))
  (export "getNumBoardMembers" (func $getNumBoardMembers))
  (export "getNumProposers" (func $getNumProposers))
  (export "getActionLastIndex" (func $getActionLastIndex))
  (export "proposeAddBoardMember" (func $proposeAddBoardMember))
  (export "proposeAddProposer" (func $proposeAddProposer))
  (export "proposeRemoveUser" (func $proposeRemoveUser))
  (export "proposeChangeQuorum" (func $proposeChangeQuorum))
  (export "proposeTransferExecute" (func $proposeTransferExecute))
  (export "proposeAsyncCall" (func $proposeAsyncCall))
  (export "proposeSCDeployFromSource" (func $proposeSCDeployFromSource))
  (export "proposeSCUpgradeFromSource" (func $proposeSCUpgradeFromSource))
  (export "quorumReached" (func $quorumReached))
  (export "performAction" (func $performAction))
  (export "dnsRegister" (func $dnsRegister))
  (export "getPendingActionFullInfo" (func $getPendingActionFullInfo))
  (export "userRole" (func $userRole))
  (export "getAllBoardMembers" (func $getAllBoardMembers))
  (export "getAllProposers" (func $getAllProposers))
  (export "getActionData" (func $getActionData))
  (export "getActionSigners" (func $getActionSigners))
  (export "getActionSignerCount" (func $getActionSignerCount))
  (export "getActionValidSignerCount" (func $getActionValidSignerCount))
  (export "callBack" (func $callBack))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2))
  (data $.rodata (i32.const 1048576) "invalid valueinput too long\02\01\00recipient address not setserializer decode error: argument decode error (): function does not accept ESDT paymenttoo few argumentstoo many argumentswrong number of argumentsCB_CLOSUREinput too short.item_address_to_id_count_id_to_address.indexstorage decode error: .lenbad array lengthdns_addressregistertransferValueExecute faileduseraction_datanum_proposersuser_roleaction_signer_idsnum_board_membersquorumperformAsyncCallperformChangeUserstartPerformActionperformChangeQuorumperformTransferExecuteperformDeployFromSourceperformUpgradeFromSourceasyncCallErrorasyncCallSuccessaction_idduplicate board memberno callback function with that name exists in contractboardperform_async_call_callbackcall_resultquorum cannot exceed board sizecannot remove all board members and proposersinsufficient gas for callonly board members and proposers can perform actionsquorum has not been reachedargumentsopt_functiontouser_addressproposer_addressnew_quorumboard_member_addresscode_metadatasourcesc_addressonly board members and proposers can proposeproposed action has no effectonly board members and proposers can discard actionscannot discard action with valid signaturesboard cannot be empty on init, no-one would be able to proposeaction does not existonly board members can signonly board members can un-sign\00\00\00\1d\00\10\00\1c\00\10\00\1b\00\10\00Endpoint can only be called by ownerindex out of range\00\00panic occurred")
  (data $.data (i32.const 1049996) "\9c\ff\ff\ff"))
