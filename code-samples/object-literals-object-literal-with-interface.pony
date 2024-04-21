object is Hashable
  fun apply(): String => "hi"
  fun hash(): USize => this().hash()
end