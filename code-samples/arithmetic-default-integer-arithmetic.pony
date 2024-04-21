// unsigned wrap-around on overflow
U32.max_value() + 1 == 0

// signed wrap-around on overflow/underflow
I32.min_value() - 1 == I32.max_value()