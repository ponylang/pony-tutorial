actor Main
  new create(env: Env) =>
    let my_decimal_int: I32 = 1024
    let my_hexadecimal_int: I32 = 0x400
    let my_binary_int: I32 = 0b10000000000
    env.out.print(my_decimal_int.string() + " = " + my_hexadecimal_int.string() + " = " + my_binary_int.string())