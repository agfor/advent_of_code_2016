ints = File.open("3.input").each_line.map do |line|
  line.split.map(&:to_i)
end

ints = ints.map(&:first) + ints.map { |is| is[1] } + ints.map(&:last)

p (ints.each_slice(3).map do |slice|
  a, b, c = slice.sort
  a + b > c ? 1 : 0
end.reduce(&:+))
