use "collections"

actor Main
  new create(env: Env) =>
    for i in Range(1, 2_000_000) do
      ... something that uses up heap ...
    end