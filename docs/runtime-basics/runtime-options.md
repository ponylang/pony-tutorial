# Runtime Options

Every Pony program accepts a set of `--pony*` command-line options. These are runtime options, handled by the Pony runtime itself before your program's `Main.create` runs. They are not compiler options (those are passed to `ponyc`).

You can see the full list by running any compiled Pony program with `--ponyhelp`.

## Command-Line Options

### Threading

| Option | Argument | Description |
|---|---|---|
| `--ponymaxthreads` | N | Use N scheduler threads. Defaults to the number of physical CPU cores. Cannot exceed the number of available cores. |
| `--ponyminthreads` | N | Minimum number of active scheduler threads. Defaults to 0, meaning all threads can suspend when idle. Cannot exceed `--ponymaxthreads`. |
| `--ponynoyield` | none | Do not yield the CPU when no work is available. By default, idle scheduler threads yield to avoid wasting CPU cycles. |
| `--ponypin` | none | Pin scheduler threads to CPU cores. |
| `--ponypinasio` | none | Pin the [ASIO](asio.md) thread to a CPU core. Requires `--ponypin`. |
| `--ponypinpinnedactorthread` | none | Pin the pinned actor thread to a CPU core. Requires `--ponypin`. The pinned actor thread is a dedicated scheduler thread for actors that need thread affinity. |

### Scaling

| Option | Argument | Description |
|---|---|---|
| `--ponynoscale` | none | Don't scale down the number of active scheduler threads. Cannot be used with `--ponyminthreads`. |
| `--ponysuspendthreshold` | N | Idle time in milliseconds before a scheduler thread suspends itself (range: 1--1000 ms). Defaults to 1 ms. |

### Garbage Collection

| Option | Argument | Description |
|---|---|---|
| `--ponycdinterval` | N | Run cycle detection every N milliseconds (range: 10--1000 ms). Defaults to 100 ms. |
| `--ponygcinitial` | N | Defer garbage collection until an actor is using at least 2^N bytes of heap memory. Defaults to 14 (16 KB). |
| `--ponygcfactor` | N | After GC, next collection triggers when heap usage reaches N times the current size. This is a floating-point value. Defaults to 2.0. |
| `--ponynoblock` | none | Disable the cycle detector. Dead actor cycles will never be collected. |

### Diagnostics

| Option | Argument | Description |
|---|---|---|
| `--ponyprintstatsinterval` | N | Print actor stats before an actor is destroyed and print scheduler stats every N seconds. Defaults to -1 (disabled). |
| `--ponyversion` | none | Print the runtime version and exit. |
| `--ponyhelp` | none | Print runtime usage options and exit. |

## Programmatic Overrides

You can override the default values of runtime options in your program by adding a bare function called `@runtime_override_defaults` to your `Main` actor. This function receives a `RuntimeOptions` struct that you can modify:

```pony
--8<-- "runtime-basics-runtime-override-defaults.pony"
```

The function is called during runtime initialization, before command-line arguments are parsed. This means command-line arguments still take precedence: if your code sets `ponymaxthreads` to 4 but the user passes `--ponymaxthreads 2`, the program will use 2 threads.

The `RuntimeOptions` struct is defined in the `builtin` package and has a field for each runtime option. See the [standard library documentation](https://stdlib.ponylang.io/builtin-RuntimeOptions/) for the full list of fields.
