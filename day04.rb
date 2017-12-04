# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'benchmark'

def part1(input = nil)
  valid = 0
  input.each do |line|
    seen = []
    duplicate_found = false
    line.split(' ').each do |segment|
      if seen.include?(segment)
        duplicate_found = true
      else
        seen.push(segment)
      end
    end
    next if duplicate_found
    valid += 1
  end
  valid
end

def part2(input = nil)
  valid = 0
  input.each do |line|
    seen = []
    duplicate_found = false
    line.split(' ').each do |segment|
      sorted = segment.split('').sort.join('')
      if seen.include?(sorted)
        duplicate_found = true
      else
        seen.push(sorted)
      end
    end
    next if duplicate_found
    valid += 1
  end
  valid
end

if ARGF
  input = ARGF.read.split("\n")
  result_part1 = 0
  result_part2 = 0

  time_part1 = Benchmark.realtime do
    result_part1 = part1(input)
  end

  time_part2 = Benchmark.realtime do
    result_part2 = part2(input)
  end

  fmt_output = "%6s: %10s = %8d (took %.3fs)\n"
  printf fmt_output, 'part1', 'valid', result_part1, time_part1
  printf fmt_output, 'part2', 'valid', result_part2, time_part2
end
