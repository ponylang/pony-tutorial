fun f(x: U32): String =>
  match x
  | 1 => "one"
  | 2 => "two"
  | 3 => "three"
  | 5 => "not four"
  else
    "something else"
  end