(module

    (import "env" "storageLoadLength" (func $storageLoadLength (param i32 i32)         (result i32)))
    (import "env" "storageLoad"       (func $storageLoad       (param i32 i32 i32)     (result i32)))
    (import "env" "storageStore"      (func $storageStore      (param i32 i32 i32 i32) (result i32)))

    (func $init)

    (func $i32.assertEqual (param i32 i32)
        local.get 0
        local.get 1
        (if (i32.ne) (then unreachable))
    )

    (func $i64.assertEqual (param i64 i64)
        local.get 0
        local.get 1
        (if (i64.ne) (then unreachable))
    )

    (func $test
        i32.const 0
        i64.const 1848529
        i64.store

        i32.const 8
        i64.const 99999999999
        i64.store
        (call $storageStore (i32.const 0) (i32.const 8) (i32.const 8) (i32.const 8))
        i32.const 2
        call $i32.assertEqual

        (call $storageLoadLength (i32.const 0) (i32.const 8))
        i32.const 8
        call $i32.assertEqual

        (call $storageLoad (i32.const 0) (i32.const 8) (i32.const 16))
        i32.const 16
        i64.load
        i64.const 99999999999
        call $i64.assertEqual

        drop
    )

    (export "test" (func $test))
    (export "init" (func $init))
    (memory 3)
)