# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'

def part1(input = nil)
  banks = input.map(&:to_i)
  seen = []
  cycles = 0
  until seen.include?(banks.join)
    seen.push(banks.join)
    blocks = banks.max
    i = banks.find_index(blocks)
    banks[i] = 0
    i == (banks.length - 1) ? i = 0 : i += 1
    while blocks > 0
      banks[i] += 1
      blocks -= 1
      i == (banks.length - 1) ? i = 0 : i += 1
    end
    cycles += 1
  end
  cycles
end

def part2(input = nil)
  banks = input.map(&:to_i)
  seen = {}
  cycles = 0
  until seen.include?(banks.join)
    seen[banks.join] = cycles
    blocks = banks.max
    i = banks.find_index(blocks)
    banks[i] = 0
    i == (banks.length - 1) ? i = 0 : i += 1
    while blocks > 0
      banks[i] += 1
      blocks -= 1
      i == (banks.length - 1) ? i = 0 : i += 1
    end
    cycles += 1
  end
  cycles - seen[banks.join]
end

if ARGF
  input = ARGF.read.split("\t")
  result_part1 = 0
  result_part2 = 0
  fmt_output = "%6s: %14s = %8d (took %.3fs)\n"

  time_part1 = Benchmark.realtime do
    result_part1 = part1(input)
  end
  printf fmt_output, 'part1', 'redist cycles', result_part1, time_part1

  time_part2 = Benchmark.realtime do
    result_part2 = part2(input)
  end
  printf fmt_output, 'part2', 'loop size', result_part2, time_part2
end
