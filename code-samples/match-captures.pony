fun f(x: (U32 | String | None)): String =>
  match x
  | None => "none"
  | 2 => "two"
  | 3 => "three"
  | let u: U32 => "other integer"
  | let s: String => s
  end