actor Main
  let names: Array[String] = [
    "Jack"
    "Herbert"
    "Jill"
  ]
  var current_name: String = ""

  new create(env: Env) =>
    var name =
      while moreNames() do
        var name' = getName()
        if (name' == "Jack") or (name' == "Jill") then
          break name'
        end
        name'
      else
        "Herbert"
      end
    env.out.print("name = " + name)
      
  fun ref moreNames(): Bool =>
    try
      current_name = names.shift()?
    else
      return false
    end
    true
    
  fun getName(): String =>
    current_name