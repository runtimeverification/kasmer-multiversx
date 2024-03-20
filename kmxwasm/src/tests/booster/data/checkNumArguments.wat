(module
    (import "env" "getNumArguments" (func $getNumArguments (result i32)))
    (import "env" "signalError" (func $signalError (;2;) (param i32 i32)))

    (func $init)

    (func $check_num_arguments (param i32)
        block ;; label = @1
            call $getNumArguments
            local.get 0
            i32.ne
            br_if 0 (;@1;)
            return
        end
        i32.const 131072
        i32.const 25
        call $signalError
        unreachable
    )

    (func $test
        i32.const 1
        call $check_num_arguments
    )

    (export "test" (func $test))
    (export "init" (func $init))
)