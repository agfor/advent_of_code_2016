grid = (["." * 50] * 6).map(&:chars)
puts grid.map(&:join).join("\n")

display_grid = nil
File.open("8.input").each_line.each_with_index do |line, i|
  # puts "\\n"
  a, b = line.scan(/\d+/).map(&:to_i)
  case line
  when /rect/
    a.times do |x|
      b.times do |y|
        grid[y][x] = "#"
      end
    end
  when /rotate row/
    grid[a].rotate!(-b)
  when /rotate column/
    grid = grid[0].zip(*grid[1..-1])
    grid[a].rotate!(-b)
    grid = grid[0].zip(*grid[1..-1])
  end
  puts line
  puts display_grid = grid.map(&:join).join("\n")
  # break if i == 30
end

# puts "\\n"
# puts display_grid
p display_grid.count("#")
