# frozen_string_literal: true

unless ARGV.empty?
  sum = 0
  input = ARGV[0].to_s.split('').map(&:to_i)
  input.each_index do |idx|
    num = input[idx].to_i
    if idx == (input.length - 1)
      sum += num if num == input[0]
    elsif num == input[idx + 1]
      sum += num
    end
  end
  puts "sum = #{sum}"
end
