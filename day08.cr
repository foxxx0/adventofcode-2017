require "benchmark"
require "io/console"

@[AlwaysInline]
def cond(left : Int32, op : String, right : Int32) : Bool
  {% begin %}
    case(op)
      {% for op in %w( < <= > >= == != ) %}
      when {{op}} then left {{op.id}} right
      {% end %}
      else
        raise "Invalid conditional operation #{op}"
      end
  {% end %}
end

@[AlwaysInline]
def part12(input : Array(String)) : { Int32, Int32 }
  highest = Int32::MIN
  registers = {} of String => Int32

  input.each do |line|
    reg, instr, param, _if, chk_reg, cond_op, condition = line.split(' ')
    param = param.to_i
    param *= -1 if instr == "dec"
    condition = condition.to_i

    registers[chk_reg] = 0 unless registers.has_key?(chk_reg)

    next unless cond(registers[chk_reg], cond_op, condition)
    registers[reg] = 0 unless registers.has_key?(reg)
    registers[reg] += param
    highest = registers[reg] if registers[reg] > highest
  end

  {registers.values.max, highest}
end

if ARGF
  input = [] of String

  time = Benchmark.realtime do
    input = ARGF.gets_to_end.lines
  end
  printf "reading and preparing input took: %8.3fms\n", time.total_milliseconds

  fmt_output = "%6s: %14s = %7d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time = Benchmark.realtime do
    result1, result2 = part12(input)
  end
  printf fmt_output, "part1", "largest value", result1, time.total_milliseconds
  printf fmt_output, "part2", "max alltime", result2, 0
end
