data = File.read('input')

puts 'Day 2'
puts 'Part 1'

def check_game(game)
  max = { 'red' => 12, 'green' => 13, 'blue' => 14 }
  game.split(';').all? do |r|
    r.split(',').all? do |s|
      num_string, color = s.split
      num = num_string.to_i
      num <= max[color]
    end
  end
end

def game_value(line)
  num_string, game = line.split ':'
  if check_game game
    num_string.split[1].to_i
  else
    0
  end
end

puts(data.lines.sum { |l| game_value l })

puts 'Part 2'

def game_power(line)
  _, game = line.split ':'
  max = game.split(';').each_with_object({}) do |round, acc|
    round.split(',').each do |s|
      num_string, color = s.split
      num = num_string.to_i
      acc[color] = [acc[color] || 0, num].max
    end
  end
  max.values.inject(:*)
end

puts(data.lines.sum { |l| game_power l })
