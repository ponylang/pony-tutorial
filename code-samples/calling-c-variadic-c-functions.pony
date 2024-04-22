use @printf[I32](fmt: Pointer[U8] tag, ...)
// ...
let run_ns: I64 = _current_t - _last_t
let rate: I64 = (_partial_count.i64() * 1_000_000_000) / run_ns
@printf("Elapsed: %lld,%lld\n".cstring(), run_ns, rate)