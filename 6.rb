messages = File.open("6.input").each_line.map(&:chars)
chars = messages[0].zip(*messages[1..-1])

chars.each do |char_set|
  p char_set.group_by { |char| char }.values.min_by(&:size).first
end
