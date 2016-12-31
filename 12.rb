commands = {
  "cpy" => proc { |state, position, (first, second)|
    state[second] = state.has_key?(first) ? state[first] : first.to_i; position + 1
  },
  "inc" => proc { |state, position, first| state[first.first] += 1; position + 1 },
  "dec" => proc { |state, position, first| state[first.first] -= 1; position + 1 },
  "jnz" => proc { |state, position, (first, second)|
    (state.has_key?(first) ? state[first] : first.to_i) == 0 ? position + 1 : position + second.to_i
  },
}

instructions = File.open("12.input").each_line.map(&:split).to_a

state = {"a" => 0, "b" => 0, "c" => 1, "d" => 0}
position = 0

while instruction = instructions[position]
  position = commands[instruction.first].call(state, position, instruction[1..-1])
end

p state
