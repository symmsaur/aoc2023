Loc = Struct.new(:range, :text)

# Extending existing class
class Range
  def intersect?(other)
    include?(other.begin) || include?(other.end)
  end
end

def scan_line(line, regex)
  res = []
  line.scan(regex) do |match|
    offset = Regexp.last_match.offset(0)
    range = offset[0]..(offset[1] - 1)
    res << Loc.new(
      range,
      match
    )
  end
  res
end

def parse(data)
  numbers = {}
  symbols = {}
  data.lines.each_with_index do |line, line_number|
    numbers[line_number] = scan_line(line, /\d+/)
    symbols[line_number] = scan_line(line, /[^\d.\n]/)
  end
  [numbers, symbols]
end

def compute_adjacent(needle, line_number, haystack)
  (line_number - 1..line_number + 1).flat_map do |haystack_line_number|
    items = haystack[haystack_line_number]
    next unless items

    items.select do |item|
      needle_range = (needle.range.begin - 1)..(needle.range.end + 1)
      next true if needle_range.intersect?(item.range)
    end
  end
end

def adjacent_symbol?(number, line_number, symbols)
  compute_adjacent(number, line_number, symbols).any?
end

def gear_ratio(symbol, line_number, numbers)
  return 0 unless symbol.text == '*'

  adjacent_numbers = compute_adjacent(symbol, line_number, numbers)
  if adjacent_numbers.count == 2
    adjacent_numbers.inject { |a, b| a.text.to_i * b.text.to_i }
  else
    0
  end
end

data = File.read('test')
numbers, symbols = parse(data)

puts 'Day 3'
puts 'Part 1'
selected = numbers.flat_map do |line_number, numbers_on_line|
  numbers_on_line.select { |number| adjacent_symbol?(number, line_number, symbols) }
end
puts(selected.sum { |n| n.text.to_i })

puts 'Part 2'
puts(symbols.reduce(0) do |total, (line_number, symbols_on_line)|
       total + symbols_on_line.sum { |symbol| gear_ratio(symbol, line_number, numbers) }
     end)
