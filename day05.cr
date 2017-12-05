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

  before1 = Time.now.epoch_ms
  result_part1 = part1(input)
  after1 = Time.now.epoch_ms
  printf fmt_output, "part1", "steps", result_part1, after1 - before1

  before2 = Time.now.epoch_ms
  result_part2 = part2(input)
  after2 = Time.now.epoch_ms
  printf fmt_output, "part2", "steps", result_part2, after2 - before2
end
