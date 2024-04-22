use "cli"

actor Main
  new create(env: Env) =>
    let command_spec =
      try
        CommandSpec.leaf(
          "pony-embed",
          "sample program",
          [ OptionSpec.string("output", "output filename", 'o') ],
          [ ArgSpec.string("input", "source of input" where default' = "-") ]
        )? .> add_help()?
      else
        env.exitcode(1)
        return
      end
    let command =
      match CommandParser(command_spec).parse(env.args, env.vars)
      | let c: Command => c
      | let ch: CommandHelp =>
        ch.print_help(env.out)
        env.exitcode(0)
        return
      | let se: SyntaxError =>
        env.err.print(se.string())
        env.exitcode(1)
        return
      end
    let input_source = command.arg("input").string()
    let output_filename = command.option("output").string()
    env.out.print("Loading data from " + input_source + ". Writing output to " + output_filename)
    // ...