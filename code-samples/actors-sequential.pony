"""
description: "Execution order of actor behaviors"
stdout: This is printed first\nThis is printed last\n
stderr:
exitcode: 0
"""

actor Main
  new create(env: Env) =>
    call_me_later(env)
    env.out.print("This is printed first")

  be call_me_later(env: Env) =>
    env.out.print("This is printed last")