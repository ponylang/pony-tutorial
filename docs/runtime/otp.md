# Pony/OTP

The most successful actor based programming language is **Erlang/OTP**.

OTP in a nutshell:

* `gen_server` & `gen_nb_server` ~ A pony actor
* `gen_event` - Easy to implement
* `gen_fsm` - In progress
* `gen_supervisor` - Harder to implement ( needs monitors, links - 
feature planned )
* distributed multinode erlang - Already being actively researched 
( A String of Ponies )
* applications ~ a binary
* libraries ~ a pony package or shared library

# GenEvent

An actor that will:

* Register one or many handlers
* Push events to all registered handlers

```pony
interface GenEventHandler[T : Any #send]
  fun box name() : String
  be handle(data : T!)
```


```pony
actor GenEvent[T: Any #send]
  var subscribers : List[GenEventHandler[T] iso!]

  new create() =>
    subscribers = List[GenEventHandler[T] iso!]

  be subscribe(handler : GenEventHandler[T] tag) =>
    subscribers = subscribers.push(consume handler)

  be push(data : T!) =>
    for subscriber in subscribers.values() do
        let data' = data
        subscriber.handle(consume data')
    end
```

A simple debug handler

```pony
actor StringEventHandler is GenEventHandler[String]
  let _name : String
  new create( name' : String ) =>
    _name = name'
  fun box name() : String =>
    _name
  be handle(data : String ) =>
    Debug.out("String: " + data + " received by handler " + name())
```

# OTP

```
actor Main
  let gen_event : GenEvent[String]

  new create(env : Env) =>
    gen_event = GenEvent[String]
    let foo = StringEventHandler("foo")
    let baz : Stringable = Foo("bar")
    gen_event.subscribe(foo)
    let x = "hello world 4 " + baz.string()
    gen_event.push("Hello Pony World 1!")
      .push("Hello Pony World 2!")
      .push(x)
      .push(baz.string())
```

