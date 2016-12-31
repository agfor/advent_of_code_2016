# 5 - 1 = 4
# 13 - 2 = 11
# 17 - 3 = 14
# 3 - 4 = -1 = 3
# 19 - 5 = 14
# 7 - 6 = 1

p state = [2, 7, 10, 2, 9, 0, 0]
p sizes = [5, 13, 17, 3, 19, 7, 11]
p target = sizes.each_with_index.map { |size, index| (size - index - 1) % size }
p max = sizes.reduce(&:*)
# state = [4, 1]
# target = [4, 0]
# sizes = [5, 2]
i = 0
loop do
  p state if i % 100000 == 0
  if state == target
    p i
    break
  end
  state = state.zip(sizes).map { |curr, size| (curr + 1) % size }
  i += 1
  raise if i > max
end

