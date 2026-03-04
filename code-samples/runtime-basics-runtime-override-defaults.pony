actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")

  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponymaxthreads = 4
