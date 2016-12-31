def value(state, arg)
  state.has_key?(arg) ? state[arg] : arg.to_i
end

commands = {
  "cpy" => proc { |state, instructions, position, (first, second)|
    state[second] = value(state, first) if state.has_key?(second)
    position + 1
  },
  "inc" => proc { |state, instructions, position, (first, second)|
    state[first] += 1 if state.has_key?(first)
    position + 1
  },
  "dec" => proc { |state, instructions, position, (first, second)|
    state[first] -= 1 if state.has_key?(first)
    position + 1
  },
  "jnz" => proc { |state, instructions, position, (first, second)|
    value(state, first) == 0 ?  position + 1 : position + value(state, second)
  },
  "tgl" => proc { |state, instructions, position, (first, second)|
    new_position = position + value(state, first)
    case instructions[new_position] && instructions[new_position].first
    when "inc"
      instructions[new_position][0] = "dec"
    when "dec", "tgl"
      instructions[new_position][0] = "inc"
    when "jnz"
      instructions[new_position][0] = "cpy"
    when "cpy"
      instructions[new_position][0] = "jnz"
    end
    position + 1
  },
  "out" => proc { |state, instructions, position, (first, second)|
    state["out"] << value(state, first)
    position + 1
  },
}

input = File.open("25.input")
# input = <<-eos
# cpy 2 a
# tgl a
# tgl a
# tgl a
# cpy 1 a
# dec a
# dec a
# eos

instructions = input.each_line.map(&:split).to_a

100000.times do |i|
  state = {"a" => i, "b" => 0, "c" => 0, "d" => 0, "out" => []}
  position = 0

  while instruction = instructions[position]
    position = commands[instruction.first].call(state, instructions, position, instruction[1..-1])
    if position == 29
      win = state["out"].each_slice(2).all? do |first, second|
        first == 0 && (second == 1 || second == nil)
      end
      if win
        p i
        raise
      else
        break
      end
    end
  end
end
