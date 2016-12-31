require "set"
State = Struct.new(:directions, :x, :y)
directions = ["N", "E", "S", "W"]

instructions = File.read("1.input").split(", ").map do |instruction|
  [instruction[0], instruction[1..-1].to_i]
end

locations = Set.new
final_state = instructions.each_with_object(State.new(directions.dup, 0, 0)) do |(turn, distance), state|
  case turn
  when "R"
    state.directions = state.directions.rotate
  when "L"
    state.directions = state.directions.rotate(-1)
  end

  distance.times do
    case state.directions[0]
    when "N"
      state.y += 1
    when "E"
      state.x += 1
    when "S"
      state.y -= 1
    when "W"
      state.x -= 1
    end

    unless locations.add?([state.x, state.y])
      p state
    end
  end
end
