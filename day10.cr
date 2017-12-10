require "benchmark"

RING_LENGTH = 256
RING_MAX_INDEX = RING_LENGTH - 1
SPARSE_PARTS = 16
DENSE_PART_SIZE = (RING_LENGTH / 16).floor

def part1(input : String) : Int32
  ring = (0..RING_MAX_INDEX).to_a
  idx = 0
  skip = 0

  input.split(',').map(&.to_i).each do |length|
    raise "invalid length" if length > ring.size

    unless length == 1
      sublist = [] of Int32
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

def part2(input : String) : String
  ring = (0..RING_MAX_INDEX).to_a
  idx = 0
  skip = 0

  ascii = [] of Int32
  ascii = input.chomp("\n").chars.map(&.ord)

  # add suffix
  ascii << 17 << 31 << 73 << 47 << 23

  64.times do
    ascii.each do |length|
      raise "invalid length" if length > ring.size

      unless length == 1
        sublist = [] of Int32
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

  dense_hash = [] of Int32
  (0..RING_MAX_INDEX).step(SPARSE_PARTS).each do |start|
    slice = ring[start, DENSE_PART_SIZE]
    hash = slice[0]
    1.upto(slice.size - 1) do |i|
      hash = hash ^ slice[i]
    end
    dense_hash << hash
  end
  dense_hash.map { |x| x.to_s(16) }.join
end

if ARGF
	input = ARGF.gets_to_end.lines.first
  fmt_output = "%6s: %14s = %34s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "product", result1.to_s, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "knot hash", result2, time2.total_milliseconds
end
