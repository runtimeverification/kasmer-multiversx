(module
    (import "env" "assertBool" (func $assertBool (param i32)))

    (func $init)

    (func $func (param i32) (result i32)
        (block (result i32)
            (if (result i32)
                (br_if 0 (i32.const 1) (local.get 0))
                (then (i32.const 2))
                (else (i32.const 3))
            )
        )
    )

    (func $test
        (i32.eq 
            (call $func (i32.const 1)) 
            (i32.const 1)
        )
        call $assertBool
    )

    (export "test" (func $test))
    (export "init" (func $init))
)