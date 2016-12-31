# example = <<-eos
# value 5 goes to bot 2
# bot 2 gives low to bot 1 and high to bot 0
# value 3 goes to bot 1
# bot 1 gives low to output 1 and high to bot 0
# bot 0 gives low to output 2 and high to output 0
# value 2 goes to bot 2
# eos
#
# example = example.split("\n")

example = File.open("10.input").each_line

Bot = Struct.new(:number, :items, :low_type, :low_number, :high_type, :high_number)

bots = {}
outputs = {}

example.each do |line|
  case line
  when /value/
    val, number = line.scan(/\d+/).map(&:to_i)
    if bot = bots[number]
      bot.items << val
    else
      bots[number] = Bot.new(number, [val])
    end
  else
    number, low_number, high_number = line.scan(/\d+/).map(&:to_i)
    low_type, high_type = line.scan(/ to \w+/).map(&:split).map(&:last)
    unless bot = bots[number]
      bot = bots[number] = Bot.new(number, [])
    end

    bot.low_type, bot.low_number = [low_type, low_number]
    bot.high_type, bot.high_number = [high_type, high_number]
  end
end

loop do
  changed = false
  bots.each do |number, bot|
    if bot.items.length == 2
      low, high = bot.items.sort
      # if low == 17 && high == 61
      #   p number
      #   break
      # end
      changed = true
      bot.items.clear
      case bot.low_type
      when "output"
        outputs[bot.low_number] = low
      else
        bots[bot.low_number].items << low
      end
      case bot.high_type
      when "output"
        outputs[bot.high_number] = high
      else
        bots[bot.high_number].items << high
      end
    end
  end
  unless changed
    break
  end
end

p bots
p outputs
p outputs.values_at(0, 1, 2).reduce(&:*)
