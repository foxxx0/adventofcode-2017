# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/BlockLength

require 'benchmark'
require 'pp'

def part1(input = nil)
  sum = 0
  nested = 0
  skip = false
  garbage = false

  input.delete!("\n")
  input.split('').each do |char|
    if garbage
      if skip
        skip = false
        next
      end

      if char == '!'
        skip = true
        next
      end

      next unless char == '>'
      garbage = false
      next
    end

    case char
    when '{'
      nested += 1
      next
    when '}'
      sum += nested
      nested -= 1
      next
    when '<'
      garbage = true
      next
    when ','
      next
    else
      raise "invalid char: 0x#{char.hex}"
    end
  end

  sum
end

def part2(input = nil)
  sum = 0
  skip = false
  garbage = false

  input.delete!("\n")
  input.split('').each do |char|
    if garbage
      if skip
        skip = false
        next
      end

      if char == '!'
        skip = true
        next
      end

      unless char == '>'
        sum += 1
        next
      end
      garbage = false
      next
    end

    case char
    when '{'
      next
    when '}'
      next
    when '<'
      garbage = true
      next
    when ','
      next
    else
      raise "invalid char: 0x#{char.hex}"
    end
  end

  sum
end

if ARGF
  input = ARGF.read.lines.first
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'total score', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, 'part2', 'garbage chars', result2, duration2 * 1000
end
