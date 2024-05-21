class Foo
  let x: U32

  new val create_val(x': U32) =>
    x = x'

  new ref create_ref(x': U32) =>
    x = x'