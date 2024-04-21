trait Named
  fun name(): String => "Bob"

trait Bald
  fun hair(): Bool => false

class Bob is (Named & Bald)