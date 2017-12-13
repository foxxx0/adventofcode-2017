require "benchmark"

def part1(depths : Hash(Int32, Int32)) : Int32
  periods = depths.map do |layer, depth|
    [layer, 2 * (depth - 1)]
  end.to_h

  periods.select do |layer, period|
    (layer % period).zero?
  end.keys.map { |layer| layer * depths[layer] }.sum
end

@[AlwaysInline]
def caught?(
  depths  : Hash(Int32, Int32),
  periods : Hash(Int32, Int32),
  delay   : Int32
) : Bool
  depths.each_key do |layer|
    return true if ((layer + delay) % periods[layer]).zero?
  end
  false
end

def part2(depths : Hash(Int32, Int32)) : Int32
  periods = depths.map do |layer, depth|
    [layer, 2 * (depth - 1)]
  end.to_h

  delay = 0
  while caught?(depths, periods, delay)
    delay += 1
  end
  delay
end

if ARGF
  input = ARGF.gets_to_end.lines.map { |x| x.split(':').map(&.to_i) }.to_h
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "severity", result1, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "delay", result2, time2.total_milliseconds
end
