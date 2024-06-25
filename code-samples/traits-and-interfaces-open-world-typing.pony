actor Main
  new create(env: Env) =>
    let compactor: Compactor = Compactor(2)
    let a = [ as U64:
      1
      2
    ]
    env.out.print("size: " + a.size().string() + ", space: " + a.space().string())
    compactor.try_compacting(a)
    env.out.print("size: " + a.size().string() + ", space: " + a.space().string())
    let b = [ as U64:
      1
      2
      3
    ]
    env.out.print("size: " + b.size().string() + ", space: " + b.space().string())
    compactor.try_compacting(b)
    env.out.print("size: " + b.size().string() + ", space: " + b.space().string())

interface Compactable
  fun ref compact()
  fun size(): USize

class Compactor
  """
  Compacts data structures when their size crosses a threshold
  """
  let _threshold: USize

  new create(threshold: USize) =>
    _threshold = threshold

  fun ref try_compacting(thing: Compactable) =>
    if thing.size() > _threshold then
      thing.compact()
    end