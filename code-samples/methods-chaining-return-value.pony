interface Factory
  fun add_option(o: Option)
  fun make_object(): Object

primitive Foo
  fun object_wrong(f: Factory, o1: Option, o2: Option): Object =>
    f.>add_option(o1).>add_option(o2).>make_object() // Error! The expression returns a Factory

  fun object_right(f: Factory, o1: Option, o2: Option): Object =>
    f.>add_option(o1).>add_option(o2).make_object() // Works. The expression returns an Object