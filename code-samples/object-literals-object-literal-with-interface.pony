use "collections"

actor Main
  new create(env: Env) =>
    let sayHi =
      object is Hashable
        fun apply(): String => "hi"
        fun hash(): USize => this().hash()
      end
    env.out.print(sayHi() + ": " + sayHi.hash().string())