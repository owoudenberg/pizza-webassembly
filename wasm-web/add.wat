(module
    (func $add (param $0 i32) (param $1 i32) (result i32)
        (i32.add
            (local.get $0)
            (local.get $1)  
        )
    )

    (export "add" (func $add))
)