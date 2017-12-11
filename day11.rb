# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity

require 'benchmark'
require 'pp'

def part1(input = nil)
  moves = input.split(',')
  point = { x: 0, y: 0, z: 0 }

  moves.each do |move|
    case move
    when 'n'
      point[:y] += 1
      point[:z] -= 1
    when 'ne'
      point[:x] += 1
      point[:z] -= 1
    when 'se'
      point[:x] += 1
      point[:y] -= 1
    when 's'
      point[:y] -= 1
      point[:z] += 1
    when 'sw'
      point[:x] -= 1
      point[:z] += 1
    when 'nw'
      point[:x] -= 1
      point[:y] += 1
    end
    # coords = [point[:x], point[:y], point[:z]].join(',')
    # sum = point.values.reduce(:+)
    # raise "ERROR: point is off-grid: #{coords}" unless sum.zero?
  end

  point.values.map(&:abs).max
end

def part2(input = nil)
  moves = input.split(',')
  point = { x: 0, y: 0, z: 0 }
  furthest = 0

  moves.each do |move|
    case move
    when 'n'
      point[:y] += 1
      point[:z] -= 1
    when 'ne'
      point[:x] += 1
      point[:z] -= 1
    when 'se'
      point[:x] += 1
      point[:y] -= 1
    when 's'
      point[:y] -= 1
      point[:z] += 1
    when 'sw'
      point[:x] -= 1
      point[:z] += 1
    when 'nw'
      point[:x] -= 1
      point[:y] += 1
    end
    # coords = [point[:x], point[:y], point[:z]].join(',')
    # sum = point.values.reduce(:+)
    # raise "ERROR: point is off-grid: #{coords}" unless sum.zero?
    distance = point.values.map(&:abs).max
    furthest = distance if distance > furthest
  end

  furthest
end

if ARGF
  input = ARGF.read.lines.first.chomp("\n")
  fmt_output = "%6s: %14s = %12d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'distance', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, 'part2', 'furthest', result2, duration2 * 1000
end
