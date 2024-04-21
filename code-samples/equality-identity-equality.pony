if None is None then
  // TRUE!
  // There is only 1 None so the identity is the same
end

let a = Foo("hi")
let b = Foo("hi")

if a is b then
  // NOPE. THIS IS FALSE
end

let c = a
if a is c then
  // YUP! TRUE!
end