use "pony_test"
use "collections"

class _ListReverseProperty is Property[Array[USize]]
  fun name(): String => "list/reverse"

  fun gen(): Generator[Array[USize]] =>
    Generators.seq_of[USize, Array[USize]](Generators.usize())

  fun ref property(arg1: Array[USize], ph: PropertyHelper) =>
    ph.assert_array_eq[USize](arg1, arg1.reverse().reverse())

class _ListReverseOneProperty is Property[Array[USize]]
  fun name(): String => "list/reverse/one"

  fun gen(): Generator[Array[USize]] =>
    Generators.seq_of[USize, Array[USize]](
      Generators.usize()
      where from = 1, to = 1)

  fun ref property(arg1: Array[USize], ph: PropertyHelper) =>
    ph.assert_array_eq[USize](arg1, arg1.reverse())
