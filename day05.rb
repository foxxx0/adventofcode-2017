# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'benchmark'

def part1(input = nil)
  instructions = input.map(&:to_i)
  i = 0
  steps = 0
  loop do
    break if i >= instructions.length
    jump = instructions[i]
    instructions[i] += 1
    steps += 1
    i += jump
  end
  steps
end

def part2(input = nil)
  instructions = input.map(&:to_i)
  i = 0
  steps = 0
  loop do
    break if i >= instructions.length
    jump = instructions[i]
    if jump >= 3
      instructions[i] -= 1
    else
      instructions[i] += 1
    end
    steps += 1
    i += jump
  end
  steps
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
  printf fmt_output, 'part1', 'steps', result_part1, time_part1
  printf fmt_output, 'part2', 'steps', result_part2, time_part2
end
