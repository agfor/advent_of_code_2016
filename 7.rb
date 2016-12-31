def abba?(string)
  (string.length - 3).times do |i|
    a, b, c, d = string.chars[i...i+4]
    return true if a != b && a == d && b == c
  end
  false
end

def abas(string)
  (string.length - 2).times.map do |i|
    a, b, c = string.chars[i...i+3]
    [a, b, c] if a == c && a != b
  end.compact
end

def bab?(string, abas)
  abas.each do |aba|
    bab = aba[1] + aba[0] + aba[1]
    return true if string.include?(bab)
  end
  false
end

def main
  p File.open("7.input").each_line.select { |line|
    goods, bads = line.split(/[\[\]]/).each_with_index.partition { |a, b| b % 2 == 0 }
    goods = goods.map(&:first).flatten
    bads = bads.map(&:first).flatten
    potential_abas = goods.map { |good| abas(good) }.flatten(1)
    bads.any? { |bad| bab?(bad, potential_abas) }
  }.length
end

main
