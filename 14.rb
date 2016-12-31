require "digest"

triples = []
fivers = Hash.new { |h, k| h[k] = [] }

salt = "cuanljph"
# salt = "abc"
hashes = 30_000.times.map do |i|
  p i if i % 100 == 0
  hash = salt + i.to_s
  2017.times { hash = Digest::MD5.hexdigest(hash) }
  matches = hash.scan(/((\w)\2{2}\2*)/)
  triple = matches.first && matches.first.last
  triples << [i, triple, hash]
  five_group = matches.select { |match, _| match.length >= 5 }.map(&:last)
  five_group.each do |five|
    fivers[five] << [i, hash]
  end
end

keys = []
triples.each do |i, triple, hash|
  other_index, other_hash = fivers[triple].detect { |j, other_hash| i < j && i + 1000 > j }
  if other_index
    keys << hash
    if keys.length == 64
      p i
      break
    end
  end
end

