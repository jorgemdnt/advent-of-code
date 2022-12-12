# frozen_string_literal: true

def surrounding(input, row, column)
  top = [row - 1, column] unless row.zero?
  right = [row, column + 1] unless column == input.first.length - 1
  bottom = [row + 1, column] unless row == input.length - 1
  left = [row, column - 1] unless column.zero?
  [top, right, bottom, left].compact
end

def too_tall?(a, b)
  [b, a].map { |l| l.gsub('S', 'a').gsub('E', 'z') }.map(&:ord).inject(:-) > 1
end

def count_steps(tail, came_from)
  steps = 0
  until tail.nil?
    steps += 1
    tail = came_from[tail]
  end
  steps - 1
end

def shortest_path(starting_position, input)
  came_from = { starting_position => nil }

  queue = [starting_position]
  while (current = queue.shift)
    area = input.dig(*current)
    return count_steps(current, came_from) if area == 'E'

    surrounding(input, *current).each do |other_position|
      next if came_from.key?(other_position)

      other_area = input.dig(*other_position)
      next if too_tall?(area, other_area)

      queue << other_position
      came_from[other_position] = current
    end
  end
end

def part_one(input)
  starting_position = nil
  input.each_index do |i|
    input.first.each_index do |j|
      if input.dig(i, j) == 'S'
        starting_position = [i, j]
        break
      end
    end
  end
  shortest_path(starting_position, input)
end

def part_two(input)
  positions = []
  input.each_index do |i|
    input.first.each_index do |j|
      positions << [i, j] if %w[S a].include?(input.dig(i, j))
    end
  end
  positions.map { |position| shortest_path(position, input) }.compact.min
end

input = File.read(ARGV.last).split("\n").map { |m| m.split('') }

puts part_one(input)
puts part_two(input)
