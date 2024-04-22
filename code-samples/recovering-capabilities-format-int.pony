recover
  var s = String((prec + 1).max(width.max(31)))
  var value = x

  try
    if value == 0 then
      s.push(table(0)?)
    else
      while value != 0 do
        let index = ((value = value / base) - (value * base))
        s.push(table(index.usize())?)
      end
    end
  end

  _extend_digits(s, prec')
  s.append(typestring)
  s.append(prestring)
  _pad(s, width, align, fill)
  s
end