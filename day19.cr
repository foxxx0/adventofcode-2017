require "benchmark"

DIRECTIONS = { down: {1,0}, right: {0,1}, up: {-1,0}, left: {0,-1}}
LETTERS = ('a'..'z').to_a.concat(('A'..'Z').to_a)
PATH_ELEMENTS = LETTERS.concat(['|', '-', '+'])

class GridOutOfBoundsError < Exception
end

@[AlwaysInline]
def inbounds?(pos : {Int32, Int32}, grid : Array(String)) : Bool
  return false unless pos[0] >= 0 && pos[0] < grid.size
  return false unless pos[1] >= 0 && pos[1] < grid[pos[0]].size
  true
end

@[AlwaysInline]
def next_pos(cur : {Int32, Int32}, dir : {Int32, Int32}) : {Int32, Int32}
  cur.map_with_index { |val, idx| val += dir[idx] }
end

@[AlwaysInline]
def path?(pos : {Int32, Int32}, grid : Array(String)) : Bool
  return false unless inbounds?(pos, grid)
  return false unless PATH_ELEMENTS.includes?(grid[pos[0]][pos[1]])
  true
end

@[AlwaysInline]
def next_direction(pos : {Int32, Int32}, grid : Array(String), dir : {Int32, Int32}) : {Int32, Int32}
  cur = grid[pos[0]][pos[1]]
  case dir
  when DIRECTIONS[:down], DIRECTIONS[:up]
    case cur
    when '|', '-', 'a'..'z', 'A'..'Z' then return dir
    when '+'
      if path?(next_pos(pos, DIRECTIONS[:left]), grid)
        return DIRECTIONS[:left]
      elsif path?(next_pos(pos, DIRECTIONS[:right]), grid)
        return DIRECTIONS[:right]
      else
        raise "dunno where to move from here: #{cur} (#{pos})"
      end
    else raise "unknown char at current pos: #{cur}"
    end
  when DIRECTIONS[:right], DIRECTIONS[:left]
    case cur
    when '|', '-', 'a'..'z', 'A'..'Z' then return dir
    when '+'
      if path?(next_pos(pos, DIRECTIONS[:up]), grid)
        return DIRECTIONS[:up]
      elsif path?(next_pos(pos, DIRECTIONS[:down]), grid)
        return DIRECTIONS[:down]
      else
        raise "dunno where to move from here: #{cur} (#{pos})"
      end
    else raise "unknown char at current pos: #{cur}"
    end
  else raise "unknown direction: #{dir}"
  end
end


@[AlwaysInline]
def move(
  pos       : {Int32, Int32},
  grid      : Array(String),
  direction : {Int32, Int32},
  collected : Array(Char)
) : Array(Char)

  raise GridOutOfBoundsError.new("#{pos} is outside the grid") unless inbounds?(pos, grid)

  current = grid[pos[0]].chars[pos[1]]
  return collected unless PATH_ELEMENTS.includes?(current)

  case current
  when 'a'..'z', 'A'..'Z'
    collected << current
  else
    direction = next_direction(pos, grid, direction)
  end
  return move(next_pos(pos, direction), grid, direction, collected)
end

@[AlwaysInline]
def travel(
  pos       : {Int32, Int32},
  grid      : Array(String),
  direction : {Int32, Int32},
  steps     : Int32
) : Int32

  raise GridOutOfBoundsError.new("#{pos} is outside the grid") unless inbounds?(pos, grid)

  current = grid[pos[0]].chars[pos[1]]
  return steps unless PATH_ELEMENTS.includes?(current)

  steps += 1

  direction = next_direction(pos, grid, direction)
  return travel(next_pos(pos, direction), grid, direction, steps)
end

def part1(input : Array(String)) : String
  collected = [] of Char

  start = {0, input.first.chars.index('|').not_nil!}
  collected = move(start, input, DIRECTIONS[:down].not_nil!, collected)

  collected.join
end

def part2(input : Array(String)) : Int32
  steps = 0

  start = {0, input.first.chars.index('|').not_nil!}
  steps = travel(start, input, DIRECTIONS[:down].not_nil!, steps)

  steps
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %16s = %16s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "collected", result1, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "steps", result2.to_s, time2.total_milliseconds
end
