require 'set'

def parse_numbers(string)
  string.split.to_set { |s| Integer(s) }
end

def compute_score(line)
  line.sub!(/^Card *\d+: /, '')
  winning, ours = line.split('|')
  (parse_numbers(winning) & parse_numbers(ours)).size
end

puts 'Day 4'
puts 'Part 1'
data = File.read('input')
res = data.lines.sum do |line|
  score = compute_score(line)
  if score.nonzero? then 2**(score - 1) else 0 end
end
puts res

puts 'Part 2'
num_cards = [1]
data.lines.each_with_index do |line, index|
  num_cards[index] = 1 if num_cards[index].nil?
  score = compute_score line
  range = (index + 1)..(index + score)
  range.each do |i|
    existing_value = num_cards[i] || 1
    num_cards[i] = existing_value + num_cards[index]
  end
end
puts num_cards.sum
