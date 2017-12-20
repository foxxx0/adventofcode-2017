require "benchmark"

VECTOR = /[-]*\d+,[-]*\d+,[-]*\d+/
PARTICLE = /(?<p>#{VECTOR}).*?(?<v>#{VECTOR}).*?(?<a>#{VECTOR})/
TICKS = 50

class Particle
  property p : Tuple(Int32, Int32, Int32)
  property v : Tuple(Int32, Int32, Int32)
  property a : Tuple(Int32, Int32, Int32)

  def initialize(@p, @v, @a); end

  def tick
    @v = {v[0] + a[0], v[1] + a[1], v[2] + a[2]}
    @p = {p[0] + v[0], p[1] + v[1], p[2] + v[2]}
  end
end

@[AlwaysInline]
def parse(input : Array(String)) : Array(Particle)
  particles = [] of Particle
  input.each_with_index do |line, idx|
    matches = PARTICLE.match(line)
    raise "parse error" if matches.nil? || matches.size != 4
    cur = {} of Symbol => {Int32,Int32,Int32}
    %i[p v a].each do |vec|
      tmp = matches.try &.[vec.to_s].split(',').map(&.to_i)
      cur[vec] = { tmp[0], tmp[1], tmp[2] }
    end
    particles << Particle.new(cur[:p], cur[:v], cur[:a])
  end
  particles
end

def part1(input : Array(String)) : Int32
  particles = parse(input)
  accels = {} of Int32 => Int32
  particles.each_with_index { |p, pid| accels[pid] = p.a.to_a.map(&.abs).sum }
  accels.min_by{ |k,v| v }.first
end

def part2(input : Array(String)) : Int32
  particles = parse(input)

  TICKS.times do
    particles.each(&.tick)

    pos = {} of Int32 => {Int32,Int32,Int32}
    particles.each_with_index { |p, pid| pos[pid] = p.p }
    colliding = pos.select { |pid, p| pos.values.count(p) > 1 }.keys.sort.reverse

    # pp(colliding) unless colliding.empty?
    colliding.each { |idx| particles.delete_at(idx) }
  end

  particles.size
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %18s = %8s (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, "part1", "closest to 0,0,0", result1.to_s, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, "part2", "particles left", result2.to_s, time2.total_milliseconds
end
