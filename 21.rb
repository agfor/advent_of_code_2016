# commands = {
#   ["swap", "letter"] => proc { |state, (first, _, _, last)|
#     state.map { |letter| letter == first ? last : letter == last ? first : letter }
#   },
#   ["move", "position"] => proc { |state, (first, _, _, last)|
#     state.insert(last.to_i, state.delete_at(first.to_i))
#   },
#   ["rotate", "based"] => proc { |state, (_, _, _, _, first)|
#     distance = state.index(first) + 1
#     distance += 1 if distance > 4
#     state.rotate(-distance)
#   },
#   ["reverse", "positions"] => proc { |state, (first, _, last)|
#     state[first.to_i..last.to_i] = state[first.to_i..last.to_i].reverse
#     state
#   },
#   ["swap", "position"] => proc { |state, (first, _, _, last)|
#     state[first.to_i], state[last.to_i] = state[last.to_i], state[first.to_i]
#     state
#   },
#   ["rotate", "right"] => proc { |state, (first, _)|
#     state.rotate(-first.to_i)
#   },
#   ["rotate", "left"] => proc { |state, (first, _)|
#     state.rotate(first.to_i)
#   },
# }
#
# state = "abcdefgh".chars
# File.open("21.input").each_line.map(&:split).each do |args|
#   command = args[0..1]
#   args = args[2..-1]
#   state = commands[command].call(state, args)
# end
#
# p state.join

commands = {
  ["swap", "letter"] => proc { |state, (first, _, _, last)|
    state.map { |letter| letter == first ? last : letter == last ? first : letter }
  },
  ["move", "position"] => proc { |state, (first, _, _, last)|
    state.insert(first.to_i, state.delete_at(last.to_i))
  },
  ["rotate", "based"] => proc { |orig_state, (_, _, _, _, first)|
    back_state = nil
    orig_state.length.times do |i|
      back_state = orig_state.rotate(i)
      distance = back_state.index(first) + 1
      distance += 1 if distance > 4
      state = back_state.rotate(-distance)
      break if state == orig_state
    end
    back_state
  },
  ["reverse", "positions"] => proc { |state, (first, _, last)|
    state[first.to_i..last.to_i] = state[first.to_i..last.to_i].reverse
    state
  },
  ["swap", "position"] => proc { |state, (first, _, _, last)|
    state[first.to_i], state[last.to_i] = state[last.to_i], state[first.to_i]
    state
  },
  ["rotate", "right"] => proc { |state, (first, _)|
    state.rotate(first.to_i)
  },
  ["rotate", "left"] => proc { |state, (first, _)|
    state.rotate(-first.to_i)
  },
}

state = "fbgdceah".chars
# p state = "decab".chars
# p state = "bgfacdeh".chars
input = File.open("21.input")

# input = <<-eos
# swap position 4 with position 0
# swap letter d with letter b
# reverse positions 0 through 4
# rotate left 1 step
# move position 1 to position 4
# move position 3 to position 0
# rotate based on position of letter b
# rotate based on position of letter d
# eos

input.each_line.map(&:split).reverse.each do |args|
  command = args[0..1]
  args = args[2..-1]
  state = commands[command].call(state, args)
end

p state.join
