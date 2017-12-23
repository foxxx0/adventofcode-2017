require "benchmark"

def extract_params(data : Array(String|Int32)) : Array(Int64|Char)
  params = [] of Int64|Char
  data.flatten.each do |param|
    params << if param =~ /[\-]*[0-9]+/
                param.to_i64
              else
                param.chars.first
              end
  end
  params
end

def part1(instructions : Array(String)) : Int32
  registers = instructions.map do |line|
    x = line.split(' ')
    x.delete_at(0)
    x
  end
  registers = registers.flatten.select { |x| x if x =~ /[a-zA-Z]/ }.uniq.sort
  registers = registers.map { |r| r.chars.first }.product([0i64]).to_h

  multiplications = 0

  i = 0
  while i < instructions.size && i >= 0
    data = instructions[i].split(' ')
    op = data.delete_at(0)
    params = extract_params(data)
    values = [] of Int64
    reg = 'z'
    params.each do |p|
      case p
      when Char
        values << registers[p]
        reg = p if params.index(p).not_nil!.zero?
      when Int64 then values << p
      end
    end

    case op
    when "set"
      registers[reg] = values.last
    when "sub"
      registers[reg] -= values.last
    when "mul"
      registers[reg] *= values.last
      multiplications += 1
    when "jnz"
      i += (values.last - 1) if values.first != 0
    end
    i += 1
  end

  multiplications
end


def part2(instructions : Array(String)) : Int32
  b = instructions[0].split(' ').last.to_i
  b *= 100
  b += 100_000

  h = 0
  ((b)..(b + 17000)).step(17) do |i|
    2.upto(i - 1) do |j|
      if (i % j).zero?
        h += 1
        break
      end
    end
  end

  h
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %16s = %8s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "multiplications", result1.to_s, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "registers[h]", result2.to_s, time2.total_milliseconds
end
