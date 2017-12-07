# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize

require 'benchmark'
require 'json'
require 'pp'

def part1(input = nil)
  tree = {}

  input.each do |line|
    parts = line.split(' ')
    parts.delete(2) # '->'

    0.upto(parts.size - 1) do |idx|
      next if idx == 1 # weight
      element = parts[idx]
      if tree.key?(element)
        tree[element] += 1
      else
        tree[element] = 1
      end
    end
  end

  tree.key(1)
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
  return obj unless obj.respond_to?(:key?)

  weights = {}
  obj[:children].each do |cid, child|
    weights[cid] = if child.respond_to?(:key?)
                     get_weights(cid, child)[cid]
                   else
                     child
                   end
  end

  w_vals = weights.values

  wrong = w_vals.detect { |w| w_vals.count(w) == 1 }
  correct = w_vals.detect { |w| w_vals.count(w) > 1 }
  unless w_vals.count(w_vals.first) == w_vals.size
    raise TreeUnbalancedError,
          'node' => weights.key(wrong), 'delta' => wrong - correct
  end

  { id => obj[:weight] += w_vals.reduce(:+) }
end

def find_node(obj, key)
  if obj.respond_to?(:key?) && obj.key?(key)
    obj[key]
  elsif obj.respond_to?(:each)
    r = nil
    obj.find { |*n| r = find_node(n.last, key) }
    r
  end
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
  temp = Marshal.load(Marshal.dump(tree))
  # pp(tree)

  begin
    get_weights(root, temp[root])
  rescue TreeUnbalancedError => err
    result = JSON.parse(err.message.gsub('=>', ':'))
    id = result['node']
    delta = result['delta']
    node = find_node(tree, id)
    return node[:weight] - delta
  end
end

if ARGF
  input = ARGF.read.tr('(),', '').split("\n")
  fmt_output = "%6s: %14s = %8s (took %8.3fms)\n"
  result1 = nil
  result2 = 0

  duration1 = Benchmark.realtime do
    result1 = part1(input)
  end
  printf fmt_output, 'part1', 'root node', result1, duration1 * 1000

  duration2 = Benchmark.realtime do
    result2 = part2(input, result1)
  end
  printf fmt_output, 'part2', 'result', result2.to_s, duration2 * 1000
end
