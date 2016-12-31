require "set"

def pp(array)
  lookups = {1 => "HM", 2 => "LM", 4 => "HG", 8 => "LG"}
  array.map do |i|
    case i
    when Fixnum
      bits = i
        .to_s(2)
        .rjust(SIZE, "0")
        .chars
        .map(&:to_i)
        .each_with_index
        .select { |b, i| b != 0 }
        .map { |b, i| b * 2**((SIZE - 1) - i) }
        .to_a
      lookups.values_at(*bits).join
    else
      pp(i)
    end
  end
end

MOVE_MAP = {}
def moves(from)
  return MOVE_MAP[from] if MOVE_MAP.has_key?(from)
  bits = from
    .to_s(2)
    .rjust(SIZE, "0")
    .chars
    .map(&:to_i)
    .each_with_index
    .select { |b, i| b != 0 }
    .map { |b, i| b * 2**((SIZE - 1) - i) }
    .to_a
  moves = bits + bits.combination(2).map { |(a, b)| a + b }
  MOVE_MAP[from] = moves
end

def new_state(state, move, direction)
  new_state = State.new(state.visited.dup, state.current_floor + direction, state.floors.dup)
  new_state.floors[state.current_floor] -= move
  new_state.floors[state.current_floor + direction] += move
  new_state.visited << state.floors
  new_state
end

def get_states(state, valid)
  future_states = []
  if state.current_floor < 3
    moves(state.floors[state.current_floor]).each do |move|
      future_states << new_state(state, move, 1)
    end
  end
  if state.current_floor > 0
    moves(state.floors[state.current_floor]).each do |move|
      future_states << new_state(state, move, -1)
    end
  end
  future_states.select { |new_state| new_state.floors.all? { |o| valid.include?(o) } }
end

def iterate(state, valid, victory)
  queue = Queue.new
  queue.push state
  visited = Set.new
  visited.add(state.floors)

  loop do
    break if queue.length == 0

    to_check = queue.pop
    return to_check if to_check.floors[3] == victory

    get_states(to_check, valid).each do |new_state|
      queue.push(new_state) if visited.add?([new_state.current_floor] + new_state.floors)
    end
  end
end

State = Struct.new(:visited, :current_floor, :floors)


p objs = Hash[[:polonium, :thulium, :promethium, :ruthenium, :cobalt, :elerium, :dilithium].product([:g, :m]).each_with_index.map { |obj, i| [obj, 2**i] }.to_a]
# p objs = Hash[[:h, :li].product([:g, :m]).each_with_index.map { |obj, i| [obj, 2**i] }.to_a]

valid = Set.new
invalid = Set.new


(objs.length + 1).times do |i|
  objs.keys.combination(i).each do |set|
    types = set.map(&:last).sort.uniq
    if types == [:g, :m]
      ms = set.select { |(ing, type)| type == :m }
      if ms.all? { |(ing, type)| set.include?([ing, :g]) }
        valid.add(set)
      else
        invalid.add(set)
      end
    else
      valid.add(set)
    end
  end
end

# p valid
p valid.length
# p invalid
p invalid.length

def encode(objs, state_groups)
  state_groups.map { |states| states.map { |s| objs[s] }.reduce(&:+).to_i }
end

p valid = encode(objs, valid)

SIZE = 14
initial = [[[:elerium, :g], [:dilithium, :g], [:elerium, :m], [:dilithium, :m], [:polonium, :g], [:thulium, :g], [:thulium, :m], [:promethium, :g], [:ruthenium, :g], [:ruthenium, :m], [:cobalt, :g], [:cobalt, :m]], [[:polonium, :m], [:promethium, :m]], [], []]
# initial = [[[:h, :m], [:li, :m]], [[:h, :g]], [[:li, :g]], []]
p initial = encode(objs, initial)
result = iterate(State.new([], 0, initial), valid, 16383)
# p result
p result.visited.length
