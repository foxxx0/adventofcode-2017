require "benchmark"

@[AlwaysInline]
def do_move(move : String, programs : Array(Char)) : Array(Char)
  case move.chars[0]
  when 's'
    x = move.gsub(/^s/, "").to_i
    first = programs.size - x
    slice = programs[first, x]
    remainder = programs[0, first]
    programs = slice
    programs.concat(remainder)
  when 'x'
    tmp = move.gsub(/^x/, "")
    tmp = tmp.split('/')
    a = tmp[0].to_i
    b = tmp[1].to_i
    programs.swap(a, b)
  when 'p'
    tmp = move.gsub(/^p/, "")
    tmp = tmp.split('/')
    a = tmp[0].chars.first
    b = tmp[1].chars.first
    programs.swap(programs.index(a).not_nil!, programs.index(b).not_nil!)
  end
  programs
end

def part1(moves : Array(String)) : String
  programs = ('a'..'p').to_a

  moves.each do |move|
    programs = do_move(move, programs)
  end

  programs.join
end

def part2(moves : Array(String)) : String
  programs = ('a'..'p').to_a

  seen = Hash(Int32, Array(Char)).new

  cycles = 0
  while !seen.has_value?(programs)
    seen[cycles] = programs.dup
    moves.each do |move|
      programs = do_move(move, programs)
    end
    cycles += 1
  end

  seen[(1_000_000_000 % cycles)].join
end

if ARGF
  input = ARGF.gets_to_end.lines.first.chomp("\n").split(',')

  fmt_output = "%6s: %16s = %18s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "order", result1, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "order", result2, time2.total_milliseconds
end
