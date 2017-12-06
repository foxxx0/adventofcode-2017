# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'benchmark'

def max_index(input = nil)
  max = 0
  index = nil

  input.each_with_index do |el, idx|
    if el > max
      max = el
      index = idx
    end
  end

  index
end

def part1(banks = nil, seen = nil)
  cycles = 0
  until seen.key?(banks)
    seen[banks.dup] = cycles

    idx_bank = max_index(banks)
    blocks = banks[idx_bank]
    banks[idx_bank] = 0

    i = 0
    blocks.downto(1) do
      idx_bank = ((idx_bank + 1) % banks.size)
      banks[idx_bank] += 1
      i += 1
    end

    cycles += 1
  end
  [cycles, banks, seen]
end

def part2(duplicate = nil, seen = nil)
  seen.size - seen[duplicate]
end

if ARGF
  input = ARGF.read.split("\t").map(&:to_i)
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  duplicate = []
  seen = {}
  result1 = 0
  result2 = 0

  duration1 = Benchmark.realtime do
    result1, duplicate = part1(input, seen)
  end
  printf fmt_output, 'part1', 'redist cycles', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(duplicate, seen)
  end
  printf fmt_output, 'part2', 'loop size', result2, duration2 * 1000
end
