# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

require 'benchmark'
require 'pry'

def part1(input = nil)
  x = 0
  y = 0
  y_min = 0
  x_min = 0
  y_max = 0
  x_max = 0
  num = 1
  index = {}
  rows = {}
  last_move = nil

  # access port
  index[num] = { x: x, y: y }
  rows[y] = { x => num }
  num += 1

  unless num >= input
    loop do
      case last_move
      when 'right'
        # check if above is empty
        if rows[(y - 1)].nil? || rows[(y - 1)][x].nil?
          # go up
          y -= 1
          last_move = 'up'
        else
          # continue right
          x += 1
        end
      when 'up'
        # check if left is empty
        if rows[y][(x - 1)].nil?
          # go left
          x -= 1
          last_move = 'left'
        else
          # continue up
          y -= 1
        end
      when 'left'
        # check if beneth is empty
        if rows[(y + 1)].nil? || rows[(y + 1)][x].nil?
          # go down
          y += 1
          last_move = 'down'
        else
          # continue left
          x -= 1
        end
      when 'down'
        # check if right is empty
        if rows[y][(x + 1)].nil?
          # go right
          x += 1
          last_move = 'right'
        else
          # continue down
          y += 1
        end
      when nil then
        # initial move to the right
        x += 1
        last_move = 'right'
      end

      index[num] = { x: x, y: y }
      if rows[y].nil?
        rows[y] = { x => num }
      else
        rows[y][x] = num
      end
      # p(index)
      # p(rows)
      # puts("num = #{num}")
      # puts("x = #{x}")
      # puts("y = #{y}")
      # puts("last_move = #{last_move}")

      x_min = x if x < x_min
      y_min = y if y < y_min
      x_max = x if x > x_max
      y_max = y if y > y_max

      break if num == input
      num += 1
    end
  end

  # y_iter = y_min
  # while y_iter <= y_max
  #   x_iter = x_min
  #   while x_iter <= x_max
  #     printf '%5d ', rows[y_iter][x_iter] unless rows[y_iter][x_iter].nil?
  #     x_iter += 1
  #   end
  #   printf "\n"
  #   y_iter += 1
  # end

  (index[input][:x]).abs + (index[input][:y]).abs
end

def part2(input = nil)
  x = 0
  y = 0
  y_min = 0
  x_min = 0
  y_max = 0
  x_max = 0
  rows = {}
  last_move = nil
  result = 0

  num = 1
  # access port
  rows[y] = { x => num }

  loop do
    case last_move
    when 'right'
      # check if above is empty
      if rows[(y - 1)].nil? || rows[(y - 1)][x].nil?
        # go up
        y -= 1
        last_move = 'up'
      else
        # continue right
        x += 1
      end
    when 'up'
      # check if left is empty
      if rows[y][(x - 1)].nil?
        # go left
        x -= 1
        last_move = 'left'
      else
        # continue up
        y -= 1
      end
    when 'left'
      # check if beneth is empty
      if rows[(y + 1)].nil? || rows[(y + 1)][x].nil?
        # go down
        y += 1
        last_move = 'down'
      else
        # continue left
        x -= 1
      end
    when 'down'
      # check if right is empty
      if rows[y][(x + 1)].nil?
        # go right
        x += 1
        last_move = 'right'
      else
        # continue down
        y += 1
      end
    when nil then
      # initial move to the right
      x += 1
      last_move = 'right'
    end

    num = 0
    if rows.include?(y + 1)
      num += rows[(y + 1)][x] if rows[(y + 1)].include?(x)
      num += rows[(y + 1)][(x + 1)] if rows[(y + 1)].include?(x + 1)
      num += rows[(y + 1)][(x - 1)] if rows[(y + 1)].include?(x - 1)
    end
    if rows.include?(y - 1)
      num += rows[(y - 1)][x] if rows[(y - 1)].include?(x)
      num += rows[(y - 1)][(x + 1)] if rows[(y - 1)].include?(x + 1)
      num += rows[(y - 1)][(x - 1)] if rows[(y - 1)].include?(x - 1)
    end

    if rows.include?(y)
      num += rows[y][(x - 1)] if rows[y].include?(x - 1)
      num += rows[y][(x + 1)] if rows[y].include?(x + 1)
    end

    if rows[y].nil?
      rows[y] = { x => num }
    else
      rows[y][x] = num
    end
    # p(rows)
    # puts("num = #{num}")
    # puts("x = #{x}")
    # puts("y = #{y}")
    # puts("last_move = #{last_move}")

    x_min = x if x < x_min
    y_min = y if y < y_min
    x_max = x if x > x_max
    y_max = y if y > y_max

    result = num if num > input
    break if num > input
  end

  # y_iter = y_min
  # while y_iter <= y_max
  #   x_iter = x_min
  #   while x_iter <= x_max
  #     if rows[y_iter][x_iter].nil?
  #       printf '%8s ', ' '
  #     else
  #       printf '%8d ', rows[y_iter][x_iter]
  #     end
  #     x_iter += 1
  #   end
  #   printf "\n"
  #   y_iter += 1
  # end

  result
end

if ARGF
  input = ARGF.read.split("\n")[0].to_i
  result_part1 = 0
  result_part2 = 0

  time_part1 = Benchmark.realtime do
    result_part1 = part1(input)
  end

  time_part2 = Benchmark.realtime do
    result_part2 = part2(input)
  end

  fmt_output = "%6s: %10s = %8d (took %.3fs)\n"
  printf fmt_output, 'part1', 'distance', result_part1, time_part1
  printf fmt_output, 'part2', 'next val', result_part2, time_part2
end
