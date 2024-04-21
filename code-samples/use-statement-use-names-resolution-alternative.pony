// In package A
class Foo

// In package B
class Foo

// In your code
use "packageA"
use b = "packageB"

class Bar
  var _x: Foo  // The Foo from package A
  var _y: b.Foo  // The Foo from package B