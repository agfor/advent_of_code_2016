require "digest"

def calc_pos((x, y), direction)
  case direction
  when "U"
    [x, y - 1] if y > 0
  when "D"
    [x, y + 1] if y < 3
  when "L"
    [x - 1, y] if x > 0
  when "R"
    [x + 1, y] if x < 3
  end
end

def iterate(*initial)
  paths = []
  queue = Queue.new
  queue.push initial

  loop do
    break if queue.length == 0

    state = queue.pop
    if state.last == [3, 3]
      paths << state.first
      next
    end
    hash = Digest::MD5.hexdigest(state.first)
    info = hash[0..3].chars.map { |c| "bcdef".include?(c) }.zip("UDLR".chars).each do |open, direction|
      if open && (new_pos = calc_pos(state.last, direction))
        queue.push [state.first + direction, new_pos]
      end
    end
  end
  paths.max_by(&:length).length - initial.first.length
end

p iterate("ioramepc", [0, 0])
