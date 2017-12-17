require "benchmark"

@[AlwaysInline]
def assert(condition)
  raise("assertion failed") unless condition
end

@[AlwaysInline]
def spin(ring : Array(Int32), idx : Int32, rounds : Int32, cycle : Int32) : {Int32, Array(Int32)}
  nextval = 1
  rounds.times do |_r|
    idx = (idx + cycle) % ring.size
    ring.insert(idx + 1, nextval)
    idx += 1
    nextval += 1
  end

  { idx, ring }
end


def part1(cycle : Int32) : Int32
  ring = [0]
  idx = 0

  idx, ring = spin(ring, idx, 2017, cycle)

  ring[idx + 1]
end

def part2(cycle : Int32) : Int32
  ring = [0]
  result = 0
  idx = 0
  size = 1
  50_000_000.times do |r|
    nextval = r + 1
    idx = (idx + cycle) % size
    idx += 1
    if idx == 1
      result = nextval
      # puts("round #{r + 1}, ring size #{size}")
    end
    size += 1
  end
  result
end

if ARGF
  input = ARGF.gets_to_end.lines.first.chomp("\n").to_i

  fmt_output = "%6s: %16s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  assert(spin([0], 0, 3, 3) == {2,  [0, 2, 3, 1]})

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "next", result1, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "ring[1]", result2, time2.total_milliseconds
end
