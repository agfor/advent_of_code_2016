ranges = File.open("20.input").each_line.map { |r| r.strip.split("-").map(&:to_i) }.sort


def overlap((s1, e1), (s2, e2))
  [[s1, s2].min, [e1, e2].max] unless s2 > e1 + 1 || s1 > e2 + 1
end
changed = true
loop do
  i = 0
  break unless changed
  changed = false

  loop do
    break if i == ranges.length - 1
    if new_range = overlap(ranges[i], ranges[i + 1])
      changed = true
      ranges[i] = new_range
      ranges.delete_at(i + 1)
    else
      i += 1
    end
  end
end
p ranges.flatten[1..-2].each_slice(2).map { |a, b| b - a - 1 }.reduce(&:+)
