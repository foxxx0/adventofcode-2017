require "benchmark"
require "json"

class Bridge
  property components : Array(Array(Int32))
  property strength : Int32
  property length : Int32
  property open_conn : Int32

  def initialize(@components, @strength, @length, @open_conn); end

  def clone : Bridge
    return Bridge.new(@components.dup, @strength.dup, @length.dup, @open_conn.dup)
  end

  def add(comp : Array(Int32))
    @components << comp
    if comp.uniq.size == 1
      @open_conn = comp.first
    else
      tmp = @open_conn.dup
      @open_conn = comp.select { |c| c != tmp }.first
    end
    @strength += comp.sum
    @length += 1
  end

  def to_json
    {
      "components" => @components,
      "strength" => @strength,
      "length" => @length,
      "open_conn" => @open_conn
    }.to_json
  end
end

@[AlwaysInline]
def build_bridges(components : Array(Array(Int32)),
                  bridges : Hash(Int32, Bridge),
                  id : Int32,
                  init : Bool) : Hash(Int32, Bridge)

  if init
    id = 0
    startpoints = components.select { |c| c.includes?(0) }
    components = components - startpoints
    startpoints.each do |sp|
      bridges[id] = Bridge.new([sp], sp.sum, 1, sp.select { |c| c > 0 }.first)
      build_bridges(components.dup, bridges, id, false)
      id += 1
    end
  else
    # inside recursive loop
    return bridges if components.empty?

    choices = (components - bridges[id].components).select { |c| c.includes?(bridges[id].open_conn) }

    return bridges if choices.empty?

    if choices.size > 1
      current = choices.delete_at(0)

      next_id = bridges.keys.sort.last + 1
      choices.each do |choice|
        bridges[next_id] = bridges[id].clone
        bridges[next_id].add(choice)
        build_bridges((components.dup - choice), bridges, next_id, false)
        next_id = bridges.keys.sort.last + 1
      end

      bridges[id].add(current)
      build_bridges((components.dup - current), bridges, id, false)
    else
      component = choices.first
      bridges[id].add(component)
      build_bridges((components - component), bridges, id, false)
    end
  end

  bridges
end

def part1(input : Array(String)) : {Int32, Hash(Int32, Bridge)}
  components = [] of Array(Int32)
  input.map do |line|
    components << line.chomp("\n").split('/').map(&.to_i)
  end

  bridges = {} of Int32 => Bridge
  bridges = build_bridges(components, bridges, 0, true)
  # pp(bridges)
  {bridges.values.map { |b| b.strength }.max, bridges}
end


def part2(bridges : Hash(Int32, Bridge)) : Int32
  longest = bridges.values.map { |b| b.length }.max
  bridges.values.select { |b| b.length == longest }.map { |b| b.strength }.max
end

if ARGF
  input = ARGF.gets_to_end.lines

  fmt_output = "%6s: %25s = %8s (took %8.3fms)\n"
  result1 = nil
  result2 = nil
  bridges = {} of Int32 => Bridge

  time1 = Benchmark.realtime do
    result1, bridges = part1(input)
  end
  printf fmt_output, "part1", "strongest bridge", result1.to_s, time1.total_milliseconds

  time2 = Benchmark.realtime do
    result2 = part2(bridges)
  end
  printf fmt_output, "part2", "longest strongest bridge", result2.to_s, time2.total_milliseconds

  # pp(bridges.keys.size)

  # foo = bridges.values.map(&.to_json)
  # puts(foo)
end
