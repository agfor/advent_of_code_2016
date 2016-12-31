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

# number = 1363
def open(x, y, number = 1362)
  value = x*x + 3*x + 2*x*y + y + y*y + number
  value.to_s(2).count("1") % 2 == 0
end

# 6.times do |y|
#   10.times do |x|
#     print (open(x, y) ? "." : "#")
#   end
#   print "\\n"
# end

count = 0
51.times do |x|
  p x
  51.times do |y|
    next unless x + y <= 52 && open(x, y)
    dist = a_star([1, 1], [x, y]).length - 1
    count += 1 if dist <= 50
  end
end
p count
