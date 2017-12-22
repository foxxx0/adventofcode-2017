require "benchmark"

# up, right, down, left
# turn right: idx = (idx + 1) % size
# turn left: idx = (idx - 1) % size
DIRECTIONS = [{0,-1}, {1,0}, {0,1}, {-1,0}]

# @[AlwaysInline]

def parse_grid(input : Array(String)) : Hash(Int32, Hash(Int32, Symbol))
  grid = {} of Int32 => Hash(Int32, Symbol)
  input.each_with_index do |line, row|
    parsed_row = {} of Int32 => Symbol
    line.chars.each_with_index do |char, col|
      state = (char == '#') ? :infected : :clean
      parsed_row[col] = state
    end
    grid[row] = parsed_row
  end
  grid
end

@[AlwaysInline]
def print_grid(grid : Hash(Int32, Hash(Int32, Symbol)), pos : {Int32, Int32})
  last = false
  grid.keys.sort.each do |y|
    grid[y].keys.sort.each do |x|
      prefix = ' '
      char = case grid[y][x]
             when :infected then '#'
             when :flagged then 'F'
             when :weakened then 'W'
             when :clean then '.'
             end
      if pos == {x, y}
        prefix = '['
        last = true
      elsif last
        prefix = ']'
        last = false
      end
      printf "%s%s", prefix, char
    end
    printf "\n"
  end
end

def part1(input : Array(String)) : Int32
  infected = 0

  grid = parse_grid(input)

  # center
  pos = { ((grid.values.first.size - 1)/2), ((grid.keys.size - 1)/2) }

  # up
  dir = 0

  10_000.times do
    # make sure nodes are initialized
    grid[pos[1]] = {} of Int32 => Symbol unless grid.has_key?(pos[1])
    grid[pos[1]][pos[0]] = :clean unless grid[pos[1]].has_key?(pos[0])

    cur_node = grid[pos[1]][pos[0]]

    case cur_node
    when :infected
      # turn right
      dir = (dir + 1) % DIRECTIONS.size
      # clean the node
      grid[pos[1]][pos[0]] = :clean
    when :clean
      # turn left
      dir = (dir - 1) % DIRECTIONS.size
      # infect the node
      grid[pos[1]][pos[0]] = :infected
      infected += 1
    else raise "unknown node state: #{cur_node}"
    end

    # move
    pos = {(pos[0] + DIRECTIONS[dir][0]), (pos[1] + DIRECTIONS[dir][1])}

    # puts("\n")
    # print_grid(grid, pos)
  end

  # print_grid(grid, pos)

  infected
end

def part2(input : Array(String)) : Int32
  infected = 0

  grid = parse_grid(input)

  # center
  pos = { ((grid.values.first.size - 1)/2), ((grid.keys.size - 1)/2) }

  # up
  dir = 0

  10_000_000.times do
    # make sure nodes are initialized
    grid[pos[1]] = {} of Int32 => Symbol unless grid.has_key?(pos[1])
    grid[pos[1]][pos[0]] = :clean unless grid[pos[1]].has_key?(pos[0])

    cur_node = grid[pos[1]][pos[0]]

    case cur_node
    when :infected
      # turn right
      dir = (dir + 1) % DIRECTIONS.size
      # flag the node
      grid[pos[1]][pos[0]] = :flagged
    when :clean
      # turn left
      dir = (dir - 1) % DIRECTIONS.size
      # weaken the node
      grid[pos[1]][pos[0]] = :weakened
    when :weakened
      # infect the node
      grid[pos[1]][pos[0]] = :infected
      infected += 1
    when :flagged
      # reverse
      dir = (dir + 2) % DIRECTIONS.size
      # clean the node
      grid[pos[1]][pos[0]] = :clean
    else raise "unknown node state: #{cur_node}"
    end

    # move
    pos = {(pos[0] + DIRECTIONS[dir][0]), (pos[1] + DIRECTIONS[dir][1])}

    # puts("\n")
    # print_grid(grid, pos)
  end

  # print_grid(grid, pos)

  infected
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %18s = %8s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "infective bursts", result1.to_s, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "active pixels", result2.to_s, time2.total_milliseconds
end
