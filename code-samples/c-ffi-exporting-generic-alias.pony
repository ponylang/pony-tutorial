class MyBox[A: (Real[A] val & Integer[A] val)]
  let _value: A

  new val create(value: A) => _value = value
  fun val get(): A => _value
  fun val add(y: A): A => _value + y

type \c_api\ BoxedI64 is MyBox[I64]
