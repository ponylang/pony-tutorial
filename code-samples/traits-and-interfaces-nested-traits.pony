trait Named
  fun name(): String => "Bob"

trait Bald is Named
  fun hair(): Bool => false

class Bob is Bald