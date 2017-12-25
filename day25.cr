require "benchmark"
require "json"

STATES = {
  'A' => [{1,  1, 'B'}, {0, -1, 'B'}],
  'B' => [{1, -1, 'C'}, {0,  1, 'E'}],
  'C' => [{1,  1, 'E'}, {0, -1, 'D'}],
  'D' => [{1, -1, 'A'}, {1, -1, 'A'}],
  'E' => [{0,  1, 'A'}, {0,  1, 'F'}],
  'F' => [{1,  1, 'E'}, {1,  1, 'A'}]
}

class TuringMachine
  property tape : Hash(Int32, Int32)
  property state : Char
  property cursor : Int32

  def initialize(@tape, @cursor)
    @state = 'A'
  end

  def checksum
    tape.values.sum
  end

  def step
    val, move, new_state = STATES[@state][@tape[@cursor]]
    @tape[@cursor] = val
    @cursor += move
    @state = new_state
    @tape[@cursor] = 0 unless @tape.has_key?(@cursor)
  end
end

# @[AlwaysInline]

def part1(input : Int32) : Int32
  tape = { 0 => 0 }

  foo = TuringMachine.new(tape, 0)
  input.times do |i|
    foo.step
  end
  foo.checksum
end


def part2(input : Int32) : Int32
end

# if ARGF
# input = ARGF.gets_to_end.lines
input = 12683008

fmt_output = "%6s: %25s = %8s (took %8.3fms)\n"
result1 = nil
result2 = nil

time1 = Benchmark.realtime do
  result1 = part1(input)
end
printf fmt_output, "part1", "checksum", result1.to_s, time1.total_milliseconds

# time2 = Benchmark.realtime do
#   result2 = part2(bridges)
# end
# printf fmt_output, "part2", "longest strongest bridge", result2.to_s, time2.total_milliseconds

# pp(bridges.keys.size)

# foo = bridges.values.map(&.to_json)
# puts(foo)
# end
