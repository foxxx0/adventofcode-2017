require "benchmark"
require "set"

def build_group(group : Set(Int32), input : Array(Set(Int32)), groups : Set(Set(Int32))) : Array(Set(Int32))
  emptyset = Set(Int32).new
  seen = Set(Int32).new
  while group - seen != emptyset.to_set
    todo = group - seen
    neighbors = input.select { |x| x.includes?(todo.first) }
    neighbors.each do |n|
      group.concat(n)
    end
    seen << todo.first
  end
  groups << group
  input.select! { |x| group & x == emptyset }
end

def part12(input : Array(String)) : { Int32, Int32 }
  data = input.map do |line|
    line.chomp("\n").gsub(" <->", ',').tr(" ", "").split(',').map(&.to_i).to_set
  end

  groups = Set(Set(Int32)).new
  until data.empty?
    group = data.first
    build_group(group, data, groups)
  end

  {groups.select { |g| g.includes?(0) }.first.to_a.size, groups.to_a.size}
end

if ARGF
  input = ARGF.gets_to_end.lines
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time = Benchmark.realtime do
    result1, result2 = part12(input)
  end
  printf fmt_output, "part1", "group size", result1, time.total_milliseconds
  printf fmt_output, "part2", "groups", result2, 0
end
