KEYPAD = ["0000000", "0005000", "0026A00", "0137BD0", "0048C00", "0009000", "0000000"].map(&:chars)

def calc_index(x, y, direction)
  new_x, new_y = x, y
  case direction
  when "U"
    new_y -= 1
  when "L"
    new_x -= 1
  when "D"
    new_y += 1
  when "R"
    new_x += 1
  end

  if KEYPAD[new_x][new_y] == "0"
    [x, y]
  else
    [new_x, new_y]
  end
end

instructions = File.read("2.input").split.map(&:chars)

x = 1
y = 3

instructions.each do |digit_instructions|
  digit_instructions.each do |direction|
     x, y = calc_index(x, y, direction)
  end

  p KEYPAD[x][y]
  x = 1
  y = 3
end
