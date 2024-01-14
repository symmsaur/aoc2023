MapItem = Struct.new(:destination, :source, :length)

def parse(data)
  seeds_line, *lines = data.lines
  seeds = seeds_line.split(':')[1].split.map { |s| Integer(s) }
  maps = []
  # Skip first line since it's a "\n". We wanna start at the first map.
  lines[1..].chunk_while { |before, after| !(before == "\n" && after.include?(':')) }.each do |chunk|
    item_lines = chunk[1..-2]  #Discard header and newline
    maps.push item_lines.map { |line| MapItem.new(*(line.split.map {|s| Integer(s)})) }
  end
  [seeds, maps]
end

system('clear')

puts 'Day 5'
puts 'Part 1'

data = File.read('test')

seeds, maps = parse(data)

locations = seeds.map do |seed|
  maps.reduce(seed) do |number, map|
    res = number
    map.each do |map_item|
      if map_item.source <= number && number < map_item.source + map_item.length
        res = map_item.destination + number - map_item.source
        break
      end
    end
    res
  end
end

puts locations.min

puts 'Part 2'
seed_ranges = seeds.each_slice(2).to_a

def overlaps?(range1, range2)
  !(range1[0] + range1[1] - 1 < range2[0] ||
    range2[0] + range2[1] - 1 < range1[0])
end

def apply(map_item, range)
  res = []
  if map_item.source < range[0] && map_item.source + map_item.length - 1 < range[0] + range[1]
    [[map_item(range[0]
  else if
    []
  else
    []
  end
  end
end

def transform(input_range, map)
  ranges = [input_range]
  map.each do |map_item|
    to_delete = []
    to_add = []
    ranges.each do |range|
      if overlaps([map_item.source, map.length], range)
        to_delete.push range
        to_add.push apply(map_item, range)
      end
    end
    ranges -= to_delete
    ranges += to_add
  end
end

location_ranges = maps.reduce(seed_ranges) do |ranges, map|
  ranges.flat_map do |range|
    puts range.to_s
    passes_through = map.none? do |map_item|
      overlaps = overlaps?([map_item.source, map_item.length], range)
      overlaps
    end
    if passes_through
      [range]
    else
      transform(range, map)
    end
  end
end

puts location_ranges.to_s
puts location_ranges.map { |r| r.first }.min
