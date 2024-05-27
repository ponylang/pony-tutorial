type T is (U32|U8)

actor Main
  new create(env: Env) =>
    let foo = "foo"
    let bar = "bar"
    let baz = "baz"
    var cond = true
    let obj: U32 = 42
    let expr: U32 = 42
  
    if \likely\ cond then
      foo
    end

    cond = false
    while \unlikely\ cond do
      bar
    end

    cond = true
    repeat
      baz
    until \likely\ cond end
    
    let res =
    match obj
    | \likely\ expr => foo
    | \unlikely\ let capt: T => bar
    end

    env.out.print("res = " + res)