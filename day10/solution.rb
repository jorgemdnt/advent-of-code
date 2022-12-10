# frozen_string_literal: true

class CPU
  attr_reader :signal_strength

  def initialize
    @current_cycle = 1
    @x = 1
    @signal_strength = 0
  end

  def add(val)
    2.times { cycle }
    @x += val
  end

  def noop
    cycle
  end

  private

  def cycle
    recalculate_strength
    draw_pixel

    @current_cycle += 1
  end

  def draw_pixel
    pixel = [@x - 1, @x, @x + 1].include?((@current_cycle - 1) % 40) ? '#' : '.'
    print pixel
    print "\n" if (@current_cycle % 40).zero?
  end

  def recalculate_strength
    @signal_strength += @current_cycle * @x if @current_cycle == 20 || ((@current_cycle - 20) % 40).zero?
    @signal_strength
  end
end

def signal_strength(instructions)
  cpu = CPU.new
  instructions.each do |instruction|
    if (match = instruction.match(/addx (?<value>-?\d+)/))
      cpu.add(match[:value].to_i)
    else
      cpu.noop
    end
  end
  cpu.signal_strength
end

input = File.read(ARGV.last).split("\n")

p signal_strength(input)
