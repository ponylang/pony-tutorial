actor Main
  new create(env: Env) =>
    Foo(env)
    
class Foo
  new create(env: Env) =>
    foo({(s: String)(env) => env.out.print(s) })

  fun foo(f: {(String)}) =>
    f("Hello World")