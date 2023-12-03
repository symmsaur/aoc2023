require 'pp'

system('clear')

Loc = Struct.new(:range, :text)

def scan_line(line, regex)
  res = []
  line.scan(regex) do |match|
    res << Loc.new(
      Regexp.last_match.offset(0),
      match,
    )
  end
  res
end

def parse(data)
  re_number = /\d+/
  re_symbol = /[^\d.\n]/
  numbers = {}
  symbols = {}
  data.lines.each_with_index do |line, line_number|
    numbers[line_number] =  scan_line(line, re_number)
    symbols[line_number] = scan_line(line, re_symbol)
  end
  [numbers, symbols]
end

def adjacent_symbol?(number, line_number, symbols)
  (line_number-1..line_number+1).each do |symbol_line_number|
    symbols_on_line = symbols[symbol_line_number]
    if !symbols_on_line
        next
    end
    symbols_on_line.each do |symbol|
      range = number.range[0] - 1..number.range[1]
      if range.include? symbol.range[0]
        return true
      end
    end
  end
  return false
end

def gear_ratio(symbol, line_number, numbers)
  if symbol.text != "*"
    return 0
  end
  adjacent_numbers = []
  (line_number-1..line_number+1).each do |number_line_number|
    numbers_on_line = numbers[number_line_number]
    if !numbers_on_line
        next
    end
    adjacent_numbers_on_line = numbers_on_line.select do |number|
      range = number.range[0] - 1..number.range[1]
      if range.include? symbol.range[0]
        next true
      end
    end
    adjacent_numbers.concat adjacent_numbers_on_line
  end
  if adjacent_numbers.count == 2
    return adjacent_numbers.inject { |a, b| a.text.to_i * b.text.to_i }
  end
  0
end


data = File.read('input')
# puts data
numbers, symbols = parse(data)
# puts "Numbers:"
# pp numbers
# puts "Symbols:"
# pp symbols

puts 'Day 3'
puts 'Part 1'

selected = []
numbers.each do |line_number, numbers_on_line|
  numbers_on_line.each do |number|
    if adjacent_symbol?(number, line_number, symbols)
      selected << number
    end
  end
end

puts selected.sum { |n| n.text.to_i }

puts 'Part 2'
total = 0
symbols.each do |line_number, symbols_on_line|
  total += symbols_on_line.sum { |symbol| gear_ratio(symbol, line_number, numbers) }
end
puts total
