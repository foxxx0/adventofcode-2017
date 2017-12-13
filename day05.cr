require "benchmark"
require "io/console"

def part1(input)
  instructions = input.map(&.to_i)
  i = 0
  steps = 0
  while i < instructions.size
    jump = instructions[i]
    instructions[i] += 1
    steps += 1
    i += jump
  end
  steps
end

def part2(input = nil)
  instructions = input.map(&.to_i)
  i = 0
  steps = 0
  while i < instructions.size
    jump = instructions[i]
    jump >= 3 ? (instructions[i]-=1) : (instructions[i]+=1)
    steps += 1
    i += jump
  end
  steps
end


if ARGF
  input = ARGF.gets_to_end.split("\n").reject { |x| x.empty? }
  fmt_output = "%6s: %10s = %8d (took %.3fms)\n"
  result_part1 = 0
  result_part2 = 0

  time1 = Benchmark.realtime do
    result_part1 = part1(input)
  end
  printf fmt_output, "part1", "steps", result_part1, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result_part2 = part2(input)
  end
  printf fmt_output, "part2", "steps", result_part2, time2.total_milliseconds
end
