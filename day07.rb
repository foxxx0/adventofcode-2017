# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'
require 'json'
require 'pp'

def part1(input = nil)
  childs = {}
  parents = []

  input.grep(/->/).each do |line|
    parts = line.split(' ')
    parts.delete(2) # '->'

    parents << parts[0]
    3.upto(parts.size - 1) do |idx|
      next if idx == 1 # weight
      childs[parts[idx]] = 1
    end
  end

  parents.reject { |p| childs.key?(p) }.first
end

def build_tree(nodes, root)
  if nodes[root][:children].nil?
    nodes[root].delete(:children)
    return nodes[root][:weight]
  end

  children = nodes[root][:children]
  nodes[root][:children] = {}
  children.each_key do |c|
    nodes[root][:children][c] = build_tree(nodes, c)
  end
  nodes[root]
end

class TreeUnbalancedError < StandardError
end

def get_weights(id, obj)
  return obj unless obj.respond_to?(:key?) && obj.key?(:children)

  weights = {}
  obj[:children].each do |cid, child|
    test = get_weights(cid, child)
    weights[cid] = if child.respond_to?(:key?)
                     { test[cid] => test[:original] }
                   else
                     child
                   end
  end

  w_vals = weights.values
  w_vals.each_index do |idx|
    w_vals[idx] = w_vals[idx].keys.first if w_vals[idx].respond_to?(:key?)
  end

  unless w_vals.count(w_vals.first) == w_vals.size
    wrong = w_vals.detect { |w| w_vals.count(w) == 1 }
    correct = w_vals.detect { |w| w_vals.count(w) > 1 }

    node = weights.select { |n| weights[n].key?(wrong) }
    id = node.keys.first

    raise TreeUnbalancedError,
          'node' => id, 'weight' => node[id][wrong], 'delta' => wrong - correct
  end

  w_self = obj[:weight]
  obj[:weight] += w_vals.reduce(:+)
  { id => obj[:weight], original: w_self }
end

def part2(input = nil, root = nil)
  nodes = {}

  input.each do |line|
    parts = line.split(' ')
    children = parts.size > 2 ? {} : nil
    nodes[parts[0]] = {
      weight: parts[1].to_i,
      children: children
    }
    3.upto(parts.size - 1) do |idx|
      nodes[parts[0]][:children][parts[idx]] = nil
    end
  end

  tree = { root => build_tree(nodes, root) }

  begin
    get_weights(root, tree[root])
  rescue TreeUnbalancedError => err
    result = JSON.parse(err.message.gsub('=>', ':'))
    # pp(result)
    weight = result['weight']
    delta = result['delta']
    return weight - delta
  end
end

if ARGF
  input = ARGF.read.tr('(),', '').split("\n")
  fmt_output = "%6s: %14s = %15s (took %8.3fms)\n"
  result1 = nil
  result2 = 0

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'root node', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input, result1)
  end
  printf fmt_output, 'part2', 'new weight', result2.to_s, duration2 * 1000
end
