chars = File.open("9.input").read
# chars = "X(8x2)(3x3)ABCY".chars

def decompress(chars)
  offset = 0
  output = 0

  loop do
    case char = chars[offset]
    when nil, "\n"
      break
    when "("
      close = chars[offset..-1].index(")")
      length, repeat = chars[offset..offset + close].scan(/\d+/).map(&:to_i)
      offset += close + 1
      section = chars[offset...offset + length]
      output += decompress(section) * repeat
      offset += length
    else
      output += 1
      offset += 1
    end
  end

  return output
end

result = decompress(chars)

p result

