# frozen_string_literal: true

require 'benchmark'
require 'pp'

def part1(ranges = nil)
  periods = ranges.map { |l, d| [l, 2 * (d - 1)] }.to_h.freeze
  periods.select { |l, p| (l % p).zero? }.keys.map { |l| l * ranges[l] }.sum
end

def caught?(ranges, periods, delay)
  ranges.each_key do |depth|
    return true if ((depth + delay) % periods[depth]).zero?
  end
  false
end

def part2(ranges = nil)
  periods = ranges.map { |l, d| [l, 2 * (d - 1)] }.to_h.freeze
  delay = 0
  delay += 1 while caught?(ranges, periods, delay)
  delay
end

if ARGF
  input = ARGF.read.lines.map { |x| x.split(':').map(&:to_i) }.to_h.freeze
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'severity', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, 'part2', 'delay', result2, duration2 * 1000
end
