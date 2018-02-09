# frozen_string_literal: true

require 'benchmark'

def part1(input)
  sum = 0
  input.each_index do |idx|
    num = input[idx].to_i
    if idx == (input.length - 1)
      sum += num if num == input[0]
    elsif num == input[idx + 1]
      sum += num
    end
  end
  sum
end

def part2(input)
  sum = 0
  unless input.length.odd?
    half = input.length / 2
    input.each_index do |idx|
      idx2 = idx + half - input.length
      num = input[idx]
      sum += num if num == input[idx2]
    end
  end
  sum
end

if ARGF
  input = ARGF.read.to_s.chomp("\n").split('').map(&:to_i)

  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf "sum = %d (took %.3fs)\n", result1, time1

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf "sum = %d (took %.3fs)\n", result2, time2
end
