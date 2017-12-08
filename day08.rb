# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'
# require 'pp'

def part12(input = nil)
  highest = 0
  registers = {}

  input.each do |line|
    reg, instr, param, _if, chk_reg, cond_op, condition = line.split(' ')
    param = param.to_i
    param *= -1 if instr == 'dec'
    condition = condition.to_i

    registers[chk_reg] = 0 unless registers.key?(chk_reg)

    next unless registers[chk_reg].public_send(cond_op, condition)
    registers[reg] = 0 unless registers.key?(reg)
    registers[reg] += param
    highest = registers[reg] if registers[reg] > highest
  end

  [registers.values.max, highest]
end

if ARGF
  input = ARGF.read.lines
  fmt_output = "%6s: %14s = %7d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration = Benchmark.realtime do
    result1, result2 = part12(input)
  end
  printf fmt_output, 'part1', 'largest value', result1, duration * 1000
  printf fmt_output, 'part2', 'max alltime', result2, 0
end
