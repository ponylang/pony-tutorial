// partial arithmetic
let result =
  try
    USize.max_value() +? env.args.size()
  else
    env.out.print("overflow detected")
  end

// checked arithmetic
let result =
  match USize.max_value().addc(env.args.size())
  | (let result: USize, false) =>
    // use result
    ...
  | (_, true) =>
    env.out.print("overflow detected")
  end