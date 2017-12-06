require "benchmark"
require "io/console"

# thanks to github.com/Papierkorb for this
def max_index(input : Enumerable(Int32)) : Int32?
  max = Int32::MIN
  index = nil

  input.each_with_index do |el, idx|
    if el > max
      max = el
      index = idx
    end
  end

  index
end

def part1(
  banks : Array(Int32),
  seen : Hash(Array(Int32), Int32)
) : {Int32, Array(Int32), Hash(Array(Int32), Int32)}

  # continue until we detect infinite loop (state has occured before)
  cycles = 0
  until seen.has_key?(banks)
    # remember cycle count for current state
    seen[banks.dup] = cycles

    # select highest value for redistribution
    idx_bank = max_index(banks).not_nil!
    blocks = banks[idx_bank]
    banks[idx_bank] = 0

    # redistribute blocks until none left
    blocks.downto(1) do
      idx_bank = ((idx_bank + 1) % banks.size)
      banks[idx_bank] += 1
    end

    cycles += 1
  end

  # return cycle count and the abort condition (duplicate state)
  {cycles.not_nil!, banks, seen}
end

def part2(duplicate : Array(Int32), seen : Hash(Array(Int32), Int32)) : Int32
  # we are only interested in the size of the infinite loop
  # i.e. the actual infinite cycle
  seen.size - seen[duplicate]
end

if ARGF
  input = ARGF.gets_to_end.split("\t").reject { |x| x.empty? }.map(&.to_i)
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  duplicate = [] of Int32
  seen = {} of Array(Int32) => Int32
  result1 = 0
  result2 = 0

  time1 = Benchmark.realtime do
    result1, duplicate = part1(input, seen)
  end
  printf fmt_output, "part1", "redist cycles", result1, time1.total_milliseconds


  time2 = Benchmark.realtime do
    result2 = part2(duplicate, seen)
  end
  printf fmt_output, "part2", "loop size", result2, time2.total_milliseconds
end
