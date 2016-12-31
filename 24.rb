require "set"

def a_star(start, goal)
  closed_set = Set.new
  open_set = Set.new([start])
  came_from = {}

  g_score = Hash.new(999999)
  g_score[start] = 0
  f_score = Hash.new(999999)
  f_score[start] = heuristic(start, goal)

  while !open_set.empty?
    current = open_set.min_by { |node| f_score[node] }

    return reconstruct_path(came_from, current) if current == goal

    open_set.delete(current)
    closed_set.add(current)

    neighbors(current).each do |neighbor|
      next if closed_set.include?(neighbor)

      tentative_g_score = g_score[current] + distance(current, neighbor)

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

def distance(*)
  1
end

def heuristic(node, goal)
  (node.first - goal.first).abs + (node.last + goal.last).abs
end

def neighbors((x, y))
  neighbors = [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
  neighbors.select { |x, y| open(x, y) && x >= 0 && y >= 0 }
end

input = <<-eos
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
eos

input = File.open("24.input")
GRID = input.each_line.map(&:chars)
def open(x, y)
  GRID[y][x] != "#"
end

def find(n)
  GRID.each_with_index do |row, y|
    row.each_with_index do |char, x|
      return [x, y] if char == n
    end
  end
  nil
end

locations = 8.times.map { |n| find(n.to_s) }

p zero = locations.first
p goals = locations[1..-1].compact

steps = 999999
PRE = {}
goals.permutation.each_with_index do |goals, i|
  goals += [zero]
  p [i, goals]
  start = zero
  total = 0
  goals.each do |goal|
    if PRE.has_key?([start, goal])
      total += PRE[[start, goal]]
    else
      total += (PRE[[start, goal]] = a_star(start, goal).length - 1)
    end
    start = goal
  end

  if total < steps
    p ["new min", total]
    steps = total
  end
end

p ["min", steps]
