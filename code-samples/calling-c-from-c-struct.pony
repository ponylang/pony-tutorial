use @from_c[Rect]()

struct Rect
  var length: U16
  var width: U16
  
  new create(length': U16, width': U16) =>
    length = length'
    width = width'

actor Main
  new create(env: Env) =>
    let rect = Rect(2, 3)
    
    env.out.print("This rect is " + rect.length.string() + " cm x " + rect.width.string() + " cm")