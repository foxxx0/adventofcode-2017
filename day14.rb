# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

require 'benchmark'
require 'pp'

RING_LENGTH = 256
RING_MAX_INDEX = RING_LENGTH - 1
SPARSE_PARTS = 16
DENSE_PART_SIZE = (RING_LENGTH / 16).floor

def knot_hash(string = nil)
  ring = (0..RING_MAX_INDEX).to_a
  idx = 0
  skip = 0

  ascii = string.chomp("\n").chars.map(&:ord)

  # add suffix
  ascii << 17 << 31 << 73 << 47 << 23

  64.times do
    ascii.each do |length|
      raise 'invalid length' if length > ring.size

      unless length == 1
        sublist = []
        0.upto(length - 1) do |i|
          sublist << ring[(idx + i) % ring.size]
        end
        sublist.reverse!

        0.upto(sublist.size - 1) do |i|
          ring[(idx + i) % ring.size] = sublist[i]
        end
      end
      idx = (idx + length + skip) % ring.size
      skip += 1
    end
  end

  dense_hash = []
  (0..RING_MAX_INDEX).step(SPARSE_PARTS).each do |start|
    slice = ring[start, DENSE_PART_SIZE]
    hash = slice[0]
    1.upto(slice.size - 1) do |i|
      hash = hash ^ slice[i]
    end
    dense_hash << hash
  end
  dense_hash.map { |x| x.to_s(16).rjust(2, '0') }.join
end

def part1(input = nil)
  sum = 0
  grid = (0..127).to_a.product([nil]).to_h
  grid.each_key do |r|
    key = "#{input}-#{r}"
    binary = knot_hash(key).chars.map { |c| c.hex.to_s(2).rjust(4, '0') }.join
    grid[r] = binary.chars.map(&:to_i)
    sum += grid[r].count(1)
  end
  sum
end

def extend(g, y, c)
  return if g.nil?
  return if g[y].nil?
  return unless y < g.size && c < g[y].size && y >= 0 && c >= 0 && g[y][c] == 1
  g[y][c] = 0
  extend(g, y + 1, c)
  extend(g, y, c + 1)
  extend(g, y - 1, c)
  extend(g, y, c - 1)
end

def part2(input = nil)
  regions = 0
  grid = (0..127).to_a.product([nil]).to_h
  grid.each_key do |y|
    key = "#{input}-#{y}"
    binary = knot_hash(key).chars.map { |c| c.hex.to_s(2).rjust(4, '0') }.join
    grid[y] = binary.chars.map(&:to_i)
  end

  grid.each_pair do |y, row|
    row.each_index do |col|
      if row[col] == 1
        regions += 1
        extend(grid, y, col)
      end
    end
  end
  regions
end

if ARGF
  input = ARGF.read.lines.first.chomp("\n")
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'blocks', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, 'part2', 'regions', result2, duration2 * 1000
end
