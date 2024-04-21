  new create(env: Env) =>
    foo({(s: String)(myenv = env) => myenv.out.print(s) })