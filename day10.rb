# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'
require 'pp'

RING_LENGTH = 256
RING_MAX_INDEX = RING_LENGTH - 1
SPARSE_PARTS = 16
DENSE_PART_SIZE = (RING_LENGTH / 16).floor

def part1(input = nil)
  ring = (0..RING_MAX_INDEX).to_a
  idx = 0
  skip = 0

  input.split(',').map(&:to_i).each do |length|
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

  ring[0] * ring[1]
end

def part2(input = nil)
  ring = (0..RING_MAX_INDEX).to_a
  idx = 0
  skip = 0

  ascii = input.chomp("\n").split('').map(&:ord)

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
    1.upto(slice.length - 1) do |i|
      hash = hash ^ slice[i]
    end
    dense_hash << hash
  end
  dense_hash.map { |x| x.to_s(16) }.join
end

if ARGF
  input = ARGF.read.lines.first
  fmt_output = "%6s: %14s = %34s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'product', result1.to_s, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, 'part2', 'knot hash', result2, duration2 * 1000
end
