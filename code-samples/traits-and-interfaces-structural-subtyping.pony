actor Main
  new create(env: Env) =>
    let divident: U8 = 1
    let divisor: U8 = 0
    let result = div_by_zero(divident, divisor)
    match result
      | let res: U8 => env.out.print(divident.string() + "/" + divisor.string() + " = " + res.string())
      | let err: ExecveError => env.err.print(divident.string() + " cannot be divided by " + divisor.string())
    end
    
  fun div_by_zero(divident: U8, divisor: U8): (U8 | ExecveError) =>
    try divident / divisor
      return divident /? divisor
    else
      return ExecveError
    end

primitive ExecveError
  fun string(): String iso^ => "ExecveError".clone()