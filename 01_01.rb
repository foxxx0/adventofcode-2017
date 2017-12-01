# frozen_string_literal: true

require 'benchmark'

if ARGF
  sum = 0
  time = Benchmark.realtime do
    input = ARGF.read.to_s.split('').map(&:to_i)
    input.each_index do |idx|
      num = input[idx].to_i
      if idx == (input.length - 1)
        sum += num if num == input[0]
      elsif num == input[idx + 1]
        sum += num
      end
    end
  end
  printf "sum = %d (took %.3fs)\n", sum, time
end
