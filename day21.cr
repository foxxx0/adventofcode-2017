require "benchmark"
require "openssl"

@[AlwaysInline]
def rotate_grid(grid : Hash(Int32, Array(Char))) : Hash(Int32, Array(Char))
  result = {} of Int32 => Array(Char)
  0.upto(grid.size - 1) do |row|
    0.upto(grid[0].size - 1) do |col|
      value = grid[row].reverse[col]
      if row.zero?
        result[col] = [value]
      else
        result[col] << value
      end
    end
  end
  result
end

@[AlwaysInline]
def flip_grid(grid : Hash(Int32, Array(Char)), axis : Symbol) : Hash(Int32, Array(Char))
  result = {} of Int32 => Array(Char)
  case axis
  when :horiz
    0.upto(grid.size - 1) do |row|
      result[row] = grid[grid.size - row - 1]
    end
  when :vert
    0.upto(grid.size - 1) do |row|
      result[row] = grid[row].reverse
    end
  else raise "unknown axis: #{axis}"
  end
  result
end

@[AlwaysInline]
def split_grid(grid : Hash(Int32, Array(Char))) : Array(Hash(Int32, Array(Char)))
  result = [] of Hash(Int32,Array(Char))
  current_size = grid[0].size
  splits = 0
  split_size = 0
  splits_per_row = 0

  if (current_size % 2).zero?
    splits_per_row = (current_size / 2)
    splits = splits_per_row**2
    split_size = 2
  elsif (current_size % 3).zero?
    splits_per_row = (current_size / 3)
    splits = splits_per_row**2
    split_size = 3
  else
    raise "dimension error: #{grid[0].size}"
  end

  return [grid] unless splits > 1

  (0..((splits_per_row * split_size) - 1)).step(split_size) do |row_offset|
    (0..((splits_per_row * split_size) - 1)).step(split_size) do |col_offset|
      current_split = {} of Int32 => Array(Char)
      0.upto(split_size - 1) do |row|
        current_split[row] = grid[(row_offset + row)][col_offset, split_size]
      end
      result << current_split
    end
  end

  result
end

@[AlwaysInline]
def join_grid(splits : Array(Hash(Int32, Array(Char)))) : Hash(Int32, Array(Char))
  result = {} of Int32 => Array(Char)

  splits_per_row = Math.sqrt(splits.size).to_i
  split_size = splits.first.size
  result_size = splits_per_row * split_size

  splits_offset = 0
  (0..(result_size - 1)).step(split_size) do |row_offset|
    row_elements = splits[splits_offset, splits_per_row]
    0.upto(split_size - 1) do |y|
      result[y + row_offset] = row_elements.map { |e| e[y] }.flatten
    end
    splits_offset += splits_per_row
  end

  result
end

@[AlwaysInline]
def grid_sha256(grid : Hash(Int32, Array(Char))) : String
  OpenSSL::Digest.new("SHA256").update(grid.values.map(&.join).join("\n")).hexdigest
end

@[AlwaysInline]
def enhance_grid(lut : Hash(String, Hash(Int32, Array(Char))), grid : Hash(Int32, Array(Char))) : Hash(Int32, Array(Char))
  hash = grid_sha256(grid)
  return lut[hash] if lut.has_key?(hash)

  transform = grid.dup

  0.upto(3) do
    transform = rotate_grid(transform)
    hash = grid_sha256(transform)
    return lut[hash] if lut.has_key?(hash)

    transform = flip_grid(transform, :horiz)
    hash = grid_sha256(transform)
    return lut[hash] if lut.has_key?(hash)
    transform = flip_grid(transform, :horiz)

    transform = flip_grid(transform, :vert)
    hash = grid_sha256(transform)
    return lut[hash] if lut.has_key?(hash)
    transform = flip_grid(transform, :vert)
  end

  raise "could not find enhancement rule for #{grid}"
end

# @[AlwaysInline]
def part1(input : Array(String)) : Int32
  grid = {
    0 => ['.', '#', '.'],
    1 => ['.', '.', '#'],
    2 => ['#', '#', '#']
  }

  lut = {} of String => Hash(Int32, Array(Char))

  input.each do |line|
    s_pat, s_rule = line.chomp("\n").split(" => ")

    pat = {} of Int32 => Array(Char)
    s_pat.split('/').each_with_index do |row, idx|
      pat[idx] = row.chars
    end

    rule = {} of Int32 => Array(Char)
    s_rule.split('/').each_with_index do |row, idx|
      rule[idx] = row.chars
    end

    lut[grid_sha256(pat)] = rule
  end

  # puts("\n")
  # puts(grid.values.map(&.join).join("\n"))

  # 2.times do
  5.times do
    splits = split_grid(grid)
    if splits.size == 1
      grid = splits.first
      grid = enhance_grid(lut, grid)
    else
      grid = join_grid(splits.map { |part| enhance_grid(lut, part) })
    end

    # debug check
    rows = grid.keys.size
    cols = grid.values.first.size
    raise "grid is messed up: #{rows} rows, #{cols} columns. WTF?" unless rows == cols

    # puts("\n")
    # puts(grid.values.map(&.join).join("\n"))
  end

  grid.values.map(&.join).join.count('#')
end

def part2(input : Array(String)) : Int32
  grid = {
    0 => ['.', '#', '.'],
    1 => ['.', '.', '#'],
    2 => ['#', '#', '#']
  }

  lut = {} of String => Hash(Int32, Array(Char))

  input.each do |line|
    s_pat, s_rule = line.chomp("\n").split(" => ")

    pat = {} of Int32 => Array(Char)
    s_pat.split('/').each_with_index do |row, idx|
      pat[idx] = row.chars
    end

    rule = {} of Int32 => Array(Char)
    s_rule.split('/').each_with_index do |row, idx|
      rule[idx] = row.chars
    end

    lut[grid_sha256(pat)] = rule
  end

  # puts("\n")
  # puts(grid.values.map(&.join).join("\n"))

  18.times do
    splits = split_grid(grid)
    if splits.size == 1
      grid = splits.first
      grid = enhance_grid(lut, grid)
    else
      grid = join_grid(splits.map { |part| enhance_grid(lut, part) })
    end

    # debug check
    rows = grid.keys.size
    cols = grid.values.first.size
    raise "grid is messed up: #{rows} rows, #{cols} columns. WTF?" unless rows == cols

    # puts("\n")
    # puts(grid.values.map(&.join).join("\n"))
  end

  grid.values.map(&.join).join.count('#')
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %18s = %8s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "active pixels", result1.to_s, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "active pixels", result2.to_s, time2.total_milliseconds
end
