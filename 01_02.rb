# frozen_string_literal: true

unless ARGV.empty?
  sum = 0
  input = ARGV[0].to_s.split('').map(&:to_i)
  unless input.length.odd?
    half = input.length / 2
    input.each_index do |idx|
      idx2 = idx + half - input.length
      num = input[idx]
      sum += num if num == input[idx2]
    end
    puts "sum = #{sum}"
  end
end
