# frozen_string_literal: true

def calculate_strength(signal_strength, current_cycle, x)
  signal_strength += current_cycle * x if current_cycle == 20 || ((current_cycle - 20) % 40).zero?
  signal_strength
end

def draw_pixel(current_cycle, x)
  pixel = [x - 1, x, x + 1].include?((current_cycle - 1) % 40) ? '#' : '.'
  print pixel
  print "\n" if (current_cycle % 40).zero?
end

def signal_strength(instructions, &block)
  cycle = 1
  x = 1
  signal_strength = 0
  instructions.each do |instruction|
    if (match = instruction.match(/addx (?<value>-?\d+)/))
      2.times do
        signal_strength = calculate_strength(signal_strength, cycle, x)
        draw_pixel(cycle, x)

        cycle += 1
      end
      x += match[:value].to_i
    else
      signal_strength = calculate_strength(signal_strength, cycle, x)
      draw_pixel(cycle, x)

      cycle += 1
    end
  end
  signal_strength
end

input = File.read(ARGV.last).split("\n")

p signal_strength(input)
