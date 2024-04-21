primitive Printer
  fun print_two_strings(out: StdStream, s1: String, s2: String) =>
    out.>print(s1).>print(s2)
    // Equivalent to:
    out.print(s1)
    out.print(s2)
    out