require "set"

def a_star(start, goal)
  closed_set = Set.new
  open_set = Set.new([start])
  came_from = {}

  g_score = Hash.new(999999)
  g_score[start] = 0
  f_score = Hash.new(999999)
  p [start, goal]
  f_score[start] = heuristic(start, goal)

  while !open_set.empty?
    current = open_set.min_by { |node| f_score[node] }

    return reconstruct_path(came_from, current) if heuristic(current, goal) == 0

    open_set.delete(current)
    closed_set.add(current)

    neighbors(current).each do |neighbor|
      next if closed_set.include?(neighbor)

      tentative_g_score = g_score[current] + 1

      if !open_set.include?(neighbor)
        open_set.add(neighbor)
      elsif tentative_g_score >= g_score[neighbor]
        next
      end

      came_from[neighbor] = current
      g_score[neighbor] = tentative_g_score
      f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, goal)
    end
  end

  [0] * 100
end

def reconstruct_path(came_from, current)
  total_path = [current]

  while came_from.include?(current)
    current = came_from[current]
    total_path << current
  end

  total_path
end

def heuristic((empty, node), (_, goal))
  distance = (node.first - goal.first).abs + (node.last + goal.last).abs
  distance *= 1000
  distance += (empty.first - goal.first).abs + (empty.last + goal.last).abs unless distance == 0
  distance
end

def neighbors(((x, y), data))
  neighbors = [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
  neighbors.select { |i, j| open(x, y, i, j) }.map do |neighbor|
    if neighbor == data
      p [x, y]
      [neighbor, [x, y]]
    else
      [neighbor, data]
    end
  end
end

GRID = {}
def open(x, y, i, j) # FIXME
  return unless GRID.has_key?([i, j])
  size = GRID[[x, y]].first
  used = GRID[[i, j]].last

  used <= size
end

nodes = File.open("22.input").each_line.to_a[2..-1].map(&:split)

State = Struct.new(:empty_x, :empty_y, :data_x, :data_y)

max_x = 0
empty = nil
nodes.each do |node, size, used, _, _|
  x, y = node.scan(/\d+/).map(&:to_i)
  max_x = x if x > max_x
  GRID[[x, y]] = [size.to_i, used.to_i]
  empty = [x, y] if used.to_i == 0
end

# start = State.new(
p a_star([empty, [max_x, 0]], [[0, 0], [0, 0]]).length - 1
