# frozen_string_literal: true

AOC_REGS = 26
AOC_INSTR = 1000
FACTOR = 500

ACTIONS = %w[inc dec].freeze
CONDITIONS = %w[< <= == > >= !=].freeze
RESERVED_STRINGS = %w[inc dec if].freeze

def random_reg_name
  0.upto(rand(5)).map { ('a'..'z').to_a[rand(26)] }.join
end

def random_action
  ACTIONS[rand(ACTIONS.size)]
end

def random_condition
  CONDITIONS[rand(CONDITIONS.size)]
end

# generate registers
regs = {}
1.upto(AOC_REGS * FACTOR) do
  loop do
    name = random_reg_name
    unless regs.key?(name) || RESERVED_STRINGS.include?(name)
      regs[name] = nil
      break
    end
  end
end

reg_names = regs.keys
num_regs = reg_names.size

# generate very high register content
puts "#{reg_names[rand(num_regs)]} inc #{rand(AOC_INSTR * FACTOR * 10)} if #{reg_names[rand(num_regs)]} < 1"

# generate instructions
1.upto(AOC_INSTR * FACTOR - 1) do
  puts "#{reg_names[rand(num_regs)]} #{random_action} #{rand(AOC_INSTR * FACTOR)} if #{reg_names[rand(num_regs)]} #{random_condition} #{rand(AOC_INSTR * FACTOR)}"
end
