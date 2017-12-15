require "benchmark"

FACTORS = [16_807, 48_271]
MOD = 2_147_483_647

def part1(start : Array(Int32)) : Int32
  generators = [Int64.new(start[0]), Int64.new(start[1])]
  matches = 0
  40_000_000.times do
    generators[0] = (generators[0] * FACTORS[0]) % MOD
    generators[1] = (generators[1] * FACTORS[1]) % MOD

    a = generators[0] & 0xFFFF
    b = generators[1] & 0xFFFF
    matches += 1 if a == b
  end
  matches
end

def part2(start : Array(Int32)) : Int32
  generators = [Int64.new(start[0]), Int64.new(start[1])]
  checked_pairs = 0
  matches = 0
  while checked_pairs < 5_000_000
    generators[0] = (generators[0] * FACTORS[0]) % MOD
    until (generators[0] % 4).zero?
      generators[0] = (generators[0] * FACTORS[0]) % MOD
    end

    generators[1] = (generators[1] * FACTORS[1]) % MOD
    until (generators[1] % 8).zero?
      generators[1] = (generators[1] * FACTORS[1]) % MOD
    end

    a = generators[0] & 0xFFFF
    b = generators[1] & 0xFFFF
    matches += 1 if a == b
    checked_pairs += 1
  end
  matches
end

if ARGF
  input = ARGF.gets_to_end.lines.map { |x| x.split(' ')[4] }.map(&.to_i)

  fmt_output = "%6s: %16s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "matching pairs", result1, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "matching pairs", result2, time2.total_milliseconds
end
