# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'
require 'pp'
require 'set'

def build_group(group, input, groups)
  emptyset = [].to_set
  seen = [].to_set
  while group - seen != emptyset.to_set
    todo = group - seen
    neighbors = input.find_all { |x| x.include?(todo.first) }
    neighbors.each do |n|
      group += n
    end
    seen += [todo.first]
  end
  groups << group
  input.select! { |x| group & x == emptyset }
end

def part12(input = nil)
  data = input.map do |line|
    line.chomp("\n").gsub(' <->', ',').tr(' ', '').split(',').map(&:to_i).to_set
  end

  groups = Set.new
  until data.empty?
    group = data.first
    build_group(group, data, groups)
  end

  [groups.select { |g| g.include?(0) }.first.to_a.size, groups.to_a.size]
end

if ARGF
  input = ARGF.read.lines
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1, result2 = part12(input)
  end
  printf fmt_output, 'part1', 'group size', result1, duration1 * 1000
  printf fmt_output, 'part2', 'groups', result2, 0
end
