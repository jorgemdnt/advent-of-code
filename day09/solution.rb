# frozen_string_literal: true

require 'set'

class Knot
  attr_accessor :tail
  attr_reader :visited, :x, :y

  def initialize
    @x = 0
    @y = 0
    @visited = [[@x, @y]].to_set
    @tail = nil
  end

  def move_to(next_position)
    @x = next_position[0]
    @y = next_position[1]
    @visited << next_position
    @tail.drag_to(self) if @tail&.too_far?(self)
  end

  def move_once(direction)
    move_to(new_position(direction))
  end

  def drag_to(parent)
    x_diff = parent.x - @x
    y_diff = parent.y - @y
    closer_position = [@x + limit_diff(x_diff), @y + limit_diff(y_diff)]
    move_to(closer_position)
  end

  def too_far?(parent)
    Math.sqrt((parent.x - @x)**2 + (parent.y - @y)**2) >= 2
  end

  def tail_tip
    @tail&.tail_tip || self
  end

  private

  def limit_diff(num)
    num.clamp(-1, 1)
  end

  def new_position(direction)
    case direction
    when 'U'
      [@x + 1, y]
    when 'R'
      [@x, y + 1]
    when 'D'
      [@x - 1, y]
    when 'L'
      [@x, y - 1]
    end
  end
end

def count_visited_positions(moves, rope_size)
  head = Knot.new
  tail_size = rope_size - 1
  tail_size.times.reduce(head) do |acc|
    acc.tail = Knot.new
    acc.tail
  end
  moves.each do |move|
    direction, steps = move.split(' ')
    steps.to_i.times do
      head.move_once(direction)
    end
  end
  head.tail_tip.visited.count
end

input = File.read(ARGV.last).split("\n")

p count_visited_positions(input, 2)
p count_visited_positions(input, 10)
