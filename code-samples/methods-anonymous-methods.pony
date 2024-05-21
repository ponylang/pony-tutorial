use "collections"

actor Main
  new create(env: Env) =>
    let list_of_numbers = List[U32].from([1; 2; 3; 4])
    let is_odd = {(n: U32): Bool => (n % 2) == 1}
    for odd_number in list_of_numbers.filter(is_odd).values() do
      env.out.print(odd_number.string())
    end