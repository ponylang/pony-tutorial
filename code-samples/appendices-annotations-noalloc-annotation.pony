fun \noalloc\ checksum(data: Array[U8] box): U32 =>
  var acc: U32 = 0
  var i: USize = 0
  while i < data.size() do
    try acc = acc + data(i)?.u32() end
    i = i + 1
  end
  acc

be \noalloc\ add(n: U64) =>
  _sum = _sum + n

new \noalloc\ create(x: U64, y: U64) =>
  _x = x
  _y = y
