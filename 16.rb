state = "10111100110001111".chars
target_length = 35651584

while state.length < target_length
  state += ["0"] + state.reverse.map { |c| c == "1" ? "0" : "1" }
end

state = state[0...target_length]

while state.length % 2 == 0
  state = state.each_slice(2).map { |a, b| a == b ? "1" : "0" }
end

p state.join
