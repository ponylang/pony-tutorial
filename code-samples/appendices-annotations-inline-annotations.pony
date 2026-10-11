primitive Foo
  fun \inline\ always(): U64 => 42

primitive Bar
  fun \inline(500)\ threshold(): U64 => 43

primitive Baz
  fun \noinline\ never(): U64 => 44
