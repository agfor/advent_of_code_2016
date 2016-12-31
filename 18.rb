row = "...^^^^^..^...^...^^^^^^...^.^^^.^.^.^^.^^^.....^.^^^...^^^^^^.....^.^^...^^^^^...^.^^^.^^......^^^^"
count = row.count(".")

399_999.times do
  new_row = row.length.times.map do |i|
    left = i == 0 ? "." : row[i - 1]
    center = row[i]
    right = row[i + 1] || "."

    case left + center + right
    when "^.."
      "^"
    when "^^."
      "^"
    when ".^^"
      "^"
    when "..^"
      "^"
    else
      "."
    end
  end
  count += new_row.count(".")
  row = new_row
end

p count
