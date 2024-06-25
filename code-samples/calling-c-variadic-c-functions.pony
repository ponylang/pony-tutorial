use @printf[I32](fmt: Pointer[U8] tag, ...)
// ...

actor Main
  let _current_t: I64 = 5
  let _last_t: I64 = 1
  let _partial_count: F64 = 42.0

  new create(env: Env) =>
    let run_ns: I64 = _current_t - _last_t
    let rate: I64 = (_partial_count.i64() * 1_000_000_000) / run_ns
    @printf("Elapsed: %lld,%lld\n".cstring(), run_ns, rate)
