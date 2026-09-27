class _ListReverseProperties is UnitTest
  fun name(): String => "list/properties"

  fun apply(h: TestHelper) ? =>
    let g = Generators

    let gen1 = recover val g.seq_of[USize, Array[USize]](g.usize()) end
    h.for_all[Array[USize]](gen1)(
      {(arg1, ph) =>
        ph.assert_array_eq[USize](arg1, arg1.reverse().reverse())
      })?

    let gen2 = recover val g.seq_of[USize, Array[USize]](g.usize(), 1, 1) end
    h.for_all[Array[USize]](gen2)(
      {(arg1, ph) =>
        ph.assert_array_eq[USize](arg1, arg1.reverse())
      })?
