# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'benchmark'

def part1(input = nil)
  checksum = 0
  lines = input.split("\n")
  lines.each do |line|
    line = line.split(' ').map(&:to_i)
    smallest = line[0]
    largest = line[0]
    line.each do |col|
      smallest = col if col < smallest
      largest = col if col > largest
    end
    checksum += (largest - smallest).abs
  end
  checksum
end

def part2(input = nil)
  sum = 0
  lines = input.split("\n")
  lines.each do |line|
    line = line.split(' ').map(&:to_i)
    line.each_index do |idx|
      num = line[idx]
      line.each_index do |i|
        next if i == idx
        sum += num / line[i] if (num % line[i]).zero?
      end
    end
  end
  sum
end

if ARGF
  input = ARGF.read
  result_part1 = 0
  result_part2 = 0

  time_part1 = Benchmark.realtime do
    result_part1 = part1(input)
  end

  time_part2 = Benchmark.realtime do
    result_part2 = part2(input)
  end

  fmt_output = "%6s: %10s = %8d (took %.3fs)\n"
  printf fmt_output, 'part1', 'checksum', result_part1, time_part1
  printf fmt_output, 'part2', 'sum', result_part2, time_part2
end
