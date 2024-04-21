class _ListReverseProperties is UnitTest
  fun name(): String => "list/properties"

  fun apply(h: TestHelper) ? =>
    let gen1 = Generators.seq_of[USize, Array[USize]](Generators.usize())
    PonyCheck.for_all[Array[USize]](gen1, h)({
      (arg1: Array[USize], ph: PropertyHelper) =>
        ph.assert_array_eq[USize](arg1, arg1.reverse().reverse())
    })
    let gen2 = Generators.seq_of[USize, Array[USize]](1, Generators.usize())
    PonyCheck.for_all[Array[USize]](gen2, h)({
      (arg1: Array[USize], ph: PropertyHelper) =>
        ph.assert_array_eq[USize](arg1, arg1.reverse())
    })