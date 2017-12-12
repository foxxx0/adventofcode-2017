# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'
require 'pp'
require 'set'

def part12(input = nil)
  input.map! { |i| i.gsub(' <->', ',').tr(' ', '').split(',').map(&:to_i) }
  data = input.map(&:to_set)

  groups = Set.new

  input.flatten.uniq.each do |pid|
    next unless (groups.find { |x| x.include?(pid) }).nil?
    group = data.find { |x| x.include?(pid) }
    seen = [].to_set
    while group - seen != [].to_set
      todo = group - seen
      neighbors = data.find_all { |x| x.include?(todo.first) }
      neighbors.each do |n|
        group += n
      end
      seen += [todo.first]
    end
    groups << group
  end

  [groups.select { |g| g.include?(0) }.first.to_a.size, groups.to_a.size]
end

if ARGF
  input = ARGF.read.chomp("\n").lines.map { |line| line.chomp("\n") }
  fmt_output = "%6s: %14s = %8d (took %8.3fms)\n"
  result1 = nil
  result2 = nil

  duration1 = Benchmark.realtime do
    result1, result2 = part12(input)
  end
  printf fmt_output, 'part1', 'group size', result1, duration1 * 1000
  printf fmt_output, 'part2', 'groups', result2, 0
end
