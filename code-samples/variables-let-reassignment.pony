actor Main
  new create(env: Env) =>
    let x: U32 = 3 // Ok
    let y: U32 // Error, can't declare a let local without assigning to it
    y = 6 // Error, can't reassign to a let local