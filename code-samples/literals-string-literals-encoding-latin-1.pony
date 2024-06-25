actor Main
  new create(env: Env) =>
    let u_umlaut = "�"

    let runes = u_umlaut.runes()
    try
      if runes.has_next() then
        let rune = u_umlaut.runes().next()?
        env.out.print(u_umlaut + ": " + Format.int[U32](rune, FormatHex))
      end
    end