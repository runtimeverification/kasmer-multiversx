(module
    (import "env" "bigIntGetUnsignedArgument" (func $bigIntGetUnsignedArgument (param i32 i32)))
    (import "env" "bigIntSetInt64" (func $bigIntSetInt64 (param i32 i64)))
    (import "env" "bigIntCmp" (func $bigIntCmp (param i32 i32) (result i32)))
    (import "env" "bigIntAdd" (func $bigIntAdd (param i32 i32 i32)))
    (import "env" "bigIntMul" (func $bigIntMul (param i32 i32 i32)))
    (import "env" "assertBool" (func $assertBool (param i32)))

    (func $init)

    (func $test
        ;; A
        (call $bigIntGetUnsignedArgument (i32.const 0) (i32.const 0))
        ;; 2
        (call $bigIntSetInt64 (i32.const 1) (i64.const 2))
        ;; A * 2
        (call $bigIntMul (i32.const 2) (i32.const 0) (i32.const 1))
        ;; A + A
        (call $bigIntAdd (i32.const 3) (i32.const 0) (i32.const 0))
        ;; A * 2 == A + A
        (call $bigIntCmp (i32.const 2) (i32.const 3))
        i32.eqz
        call $assertBool
    )

    (export "test" (func $test))
    (export "init" (func $init))
)