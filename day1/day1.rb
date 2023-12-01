def digit?(char)
  char.ord >= 48 && char.ord <= 57
end

data = File.read('input')
puts 'Day 1'
puts 'Part 1'
digits = data.lines.map do |l|
  l.chars.select { |c| digit?(c) }
end
nums = digits.map { |chars| (chars[0] + chars[-1]).to_i }
puts nums.sum

puts 'Part 2'
digits = %w[one two three four five six seven eight nine]
digit_lists = data.lines.map do |l|
  res = []
  l.chars.each_index do |i|
    c = l[i]
    if digit?(c)
      res.append(c)
      next
    end
    rest = l[i..]
    digits.each_index do |j|
      digit = digits[j]
      res.append((j + 1).to_s) if rest.start_with?(digit)
    end
  end
  res
end
nums = digit_lists.map { |digit_list| (digit_list[0] + digit_list[-1]).to_i }
puts nums.sum
