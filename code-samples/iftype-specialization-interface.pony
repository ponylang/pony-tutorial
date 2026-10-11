interface Describable[A: Any val]
  fun describe(): String

  fun describe(): String iftype A <: Stringable val
