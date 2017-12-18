# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
# rubocop:disable Metrics/BlockNesting, Metrics/BlockLength

require 'benchmark'
require 'pp'

def extract_params(data)
  params = []
  data.flatten.each do |param|
    params << if param =~ /[\-]*[0-9]+/
                param.to_i
              else
                param.chars.first
              end
  end
  params
end

def part1(instructions)
  registers = instructions.map do |line|
    x = line.split(' ')
    x.delete_at(0)
    x
  end
  registers = registers.flatten.select { |x| x if x =~ /[a-zA-Z]/ }.uniq.sort
  registers = registers.map { |r| r.chars.first }.product([0]).to_h

  last_freq = 0

  i = 0
  while i < instructions.size && i >= 0
    data = instructions[i].split(' ')
    op = data.delete_at(0)
    params = extract_params(data)
    values = []
    reg = ''
    params.each do |p|
      case p
      when String
        values << registers[p]
        reg = p if params.index(p).zero?
      when Integer then values << p
      end
    end

    case op
    when 'snd'
      last_freq = values.first
    when 'set'
      registers[reg] = values.last
    when 'add'
      registers[reg] += values.last
    when 'mul'
      registers[reg] *= values.last
    when 'mod'
      registers[reg] = values.first % values.last
    when 'rcv'
      return last_freq unless values.first.zero?
    when 'jgz'
      i += (values.last - 1) if values.first > 0
    end
    i += 1
  end

  last_freq
end

def run(instructions, pid, snd, rcv)
  regs = Hash.new(0)
  regs['p'] = pid
  num_rcvd = 0
  i = 0

  lambda do
    firstrun = true

    while i < instructions.size && i >= 0
      data = instructions[i].split(' ')
      op = data.delete_at(0)
      params = extract_params(data)
      values = []
      reg = ''
      params.each do |p|
        case p
        when String
          values << regs[p]
          reg = p if params.index(p).zero?
        when Integer then values << p
        end
      end

      case op
      when 'snd'
        snd << values.first
      when 'set'
        regs[reg] = values.last
      when 'add'
        regs[reg] += values.last
      when 'mul'
        regs[reg] *= values.last
      when 'mod'
        regs[reg] = values.first % values.last
      when 'rcv'
        # try "receive"
        unless (data = rcv[num_rcvd])
          # stuck waiting?
          return firstrun ? :wait_init : :wait
        end
        num_rcvd += 1
        regs[reg] = data
      when 'jgz'
        i += (values.last - 1) if values.first > 0
      end

      i += 1
      firstrun = false
    end
    :done
  end
end

def part2(instr)
  q = [[], []]
  procs = [0, 1].map { |id| run(instr, id, q[id], q[1 - id]) }
  peer_waiting = false

  # break will return the result
  0.step do |i|
    # retrieve actual result from lambda operator (using []) instead of the proc
    status = procs[i % 2][]
    if status == :wait_init && peer_waiting
      # deadlock
      break q[1].size
    end
    peer_waiting = status == :wait_init
  end
end

if ARGF
  input = ARGF.read.lines

  fmt_output = "%6s: %16s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  time1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'frequency', result1, time1 * 1000

  time2 = Benchmark.realtime do
    result2 = part2(input)
  end
  printf fmt_output, 'part2', 'pid 1 sent', result2, time2 * 1000
end
