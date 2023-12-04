require 'set'

def parse_numbers(string)
  string.split.map { |s| Integer(s) }.to_set
end

data = File.read('input')
puts 'Day 4'
puts 'Part 1'
res = data.lines.sum do |line|
  line.sub!(/^Card *\d+: /, '')
  winning, ours = line.split('|')
  intersection = (parse_numbers(winning) & parse_numbers(ours))
  num_winning = intersection.size
  if num_winning != 0
    val = 2 ** (num_winning - 1)
    val
  else
    0
  end
end
puts res
