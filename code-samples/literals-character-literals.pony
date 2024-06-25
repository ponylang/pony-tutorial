actor Main
  new create(env: Env) =>
    let big_a: U8 = 'A'                 // 65
    let hex_escaped_big_a: U8 = '\x41'  // 65
    let newline: U32 = '\n'             // 10
    env.out.print(
      "\"" + String.from_array([big_a]) + "\" (char " +  big_a.string()+ ") = " +
      "\"" + String.from_array([hex_escaped_big_a]) + "\" (char " +  hex_escaped_big_a.string() + ") = " +
      "\"" + String.from_array([newline.u8()]) + "\" (char " +  newline.string() + ")")