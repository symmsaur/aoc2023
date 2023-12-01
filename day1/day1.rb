#!/usr/bin/env ruby

data = File.read("input")

puts "Day 1"
puts "Part 1"
puts data.lines.map { |l|
  l.chars.select {
    |c| 48 <= c.ord && c.ord <= 57
  }
}.map { |chars|
  chars[0] + chars[-1]
}.map { |num_string|
  num_string.to_i()
}.sum()

puts "Part 2"
digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
puts data.lines.map { |l|
  res = []
  l.chars.each_index { |i|
    c = l[i]
    if 48 <= c.ord && c.ord <= 57
      res.append(c)
      next
    end
    rest = l[i..-1]
    digits.each_index { |i|
      digit = digits[i]
      if rest.start_with?(digit)
        res.append((i+1).to_s)
      end
    }
  }
  res
}.map { |chars|
  chars[0] + chars[-1]
}.map { |num_string|
  num_string.to_i()
}.sum()
