File.open("4.input").each_line do |line|
  pieces = line.split("-")
  letters = pieces[0..-2].join.chars
  sector = pieces.last.to_i
  checksum = pieces.last.scan(/[a-z]+/).first

  counts = letters.each_with_object(Hash.new(0)) do |letter, acc|
    acc[letter] += 1
  end

  result = counts.sort_by do |letter, count|
    [-count, letter]
  end[0...5].map(&:first).join

  next if result != checksum

  alphabet = "abcdefghijklmnopqrstuvwxyz".chars
  key = alphabet.rotate(sector % 26)

  table = Hash[alphabet.zip(key)]


  result = letters.map { |letter| table[letter] }.join
  if result.scan(/north/).first
    p sector
  end
end
