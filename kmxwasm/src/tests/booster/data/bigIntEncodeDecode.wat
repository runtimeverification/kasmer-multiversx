(module
    (import "env" "bigIntGetUnsignedArgument" (func $bigIntGetUnsignedArgument (param i32 i32)))
    (import "env" "mBufferFromBigIntUnsigned" (func $mBufferFromBigIntUnsigned (param i32 i32) (result i32)))
    (import "env" "mBufferToBigIntUnsigned" (func $mBufferToBigIntUnsigned     (param i32 i32) (result i32)))
    
    
    (import "env" "bigIntCmp" (func $bigIntCmp (param i32 i32) (result i32)))
    (import "env" "assertBool" (func $assertBool (param i32)))

    (func $init)

    (func $test
        ;; read BigUint argument
        (call $bigIntGetUnsignedArgument (i32.const 0) (i32.const 0))
        ;; encode
        (call $mBufferFromBigIntUnsigned (i32.const 0) (i32.const 0))
        drop
        ;; decode
        (call $mBufferToBigIntUnsigned   (i32.const 0) (i32.const 1))
        drop
        ;; A == A'
        (call $bigIntCmp (i32.const 0) (i32.const 1))
        i32.eqz
        call $assertBool
    )

    (export "test" (func $test))
    (export "init" (func $init))
)