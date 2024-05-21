fun f(x: (U32 | String | None)): String =>
  match x
  | None => "none"
  | 2 => "two"
  | 3 => "three"
  | "5" => "not four"
  else
    "something else"
  end