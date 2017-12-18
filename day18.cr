require "benchmark"

@[AlwaysInline]
def assert(condition)
  raise("assertion failed") unless condition
end

@[AlwaysInline]
def extract_params(data : Array(String),
                   regs : Hash(Char, Int64)) : Array(Int64 | Char)
  params = [] of Int64 | Char
  data.flatten.each do |param|
    if param =~ /[\-]*[0-9]+/
      params << param.to_i64
    else
      params << param.chars.first
    end
  end
  params
end

def part1(instructions : Array(String)) : Int64 | String
  registers = instructions.map { |l| x = l.split(' '); x.delete_at(0); x }
  registers = registers.flatten.select { |x| x if x =~ /[a-zA-Z]/ }.uniq.sort
  registers = registers.map { |r| r = r.chars.first }.product([0i64]).to_h

  last_freq = 0i64

  i = 0
  while i < instructions.size && i >= 0
    data = instructions[i].split(' ')
    op = data.delete_at(0)
    params = extract_params(data, registers)
    values = [] of Int64
    reg = ' '
    params.each do |p|
      case p
      when Char
        values << registers[p]
        reg = p if params.index(p).not_nil!.zero?
      when Int64 then values << p
      end
    end

    case op
    when "snd"
      last_freq = values.first
      i += 1
    when "set"
      registers[reg] = values.last
      i += 1
    when "add"
      registers[reg] += values.last
      i += 1
    when "mul"
      registers[reg] *= values.last
      i += 1
    when "mod"
      registers[reg] = values.first % values.last
      i += 1
    when "rcv"
      if values.first.zero?
        i += 1
        next
      end
      return last_freq
    when "jgz"
      if values.first.zero?
        i += 1
        next
      else
        i += values.last
      end
    end
  end

  last_freq
end

def part2(instructions : Array(String)) : Int32
  instructions.size
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %16s = %8d (took %8.3fms)\n"
  result1 = nil
  # result2 = nil

  # assert(spin([0], 0, 3, 3) == {2,  [0, 2, 3, 1]})

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "next", result1, time1.total_milliseconds

  # time2 = Benchmark.realtime do
  #   result2 = part2(input)
  # end
  # printf fmt_output, "part2", "ring[1]", result2, time2.total_milliseconds
end
