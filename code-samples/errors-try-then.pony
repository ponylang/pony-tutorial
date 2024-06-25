actor Main
  var _err: OutStream
  var _out: OutStream

  new create(env: Env) =>
    _err = env.err
    _out = env.out
  
    try
      callA()
      if not callB() then error end
      callC()
    else
      callD()
    then
      callE()
    end
    
  fun callA(): Bool =>
    true

  fun callB(): Bool =>
    false

  fun callC() =>
    _out.print("callB() executed successfully")

  fun callD() =>
    _err.print("callB() resulted in an error")

  fun callE() =>
    _out.print("I don't know whether callB() was executed successfully ¯\\_ (ツ)_/¯ I get executed either way")