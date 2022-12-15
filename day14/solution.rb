# frozen_string_literal: true

require 'set'

input = File.read(ARGV.last).split("\n").map { |m| m.split(' -> ').map { |list| list.split(',').map(&:to_i) } }

def range(a, b)
  if a < b
    (a..b)
  else
    a.downto(b)
  end
end

def expand(position, other_position)
  return other_position if position.nil?

  if position[0] != other_position[0]
    range(position[0], other_position[0]).map { |x| [x, position[1]] }
  else
    range(position[1], other_position[1]).map { |y| [position[0], y] }
  end
end

def expand_rocks(rock_vertices)
  rock_vertices.reduce([]) do |rocks, vertix|
    rocks.last ? rocks.concat(expand(rocks.last, vertix)) : [vertix]
  end.uniq
end

class FellIntoOblivion < StandardError; end
class EntranceBlocked < StandardError; end

def occupy(occupied, x, y)
  raise FellIntoOblivion unless occupied.key?(x) && occupied[x].max > y
  raise EntranceBlocked if occupied[x].include?(y) && x == 500 && y.zero?

  if occupied[x].include?(y)
    if !occupied[x - 1]&.include?(y)
      occupy(occupied, x - 1, y)
    elsif !occupied[x + 1]&.include?(y)
      occupy(occupied, x + 1, y)
    end
  elsif occupied[x].include?(y + 1) &&
        occupied[x - 1]&.include?(y + 1) &&
        occupied[x + 1]&.include?(y + 1)
    [x, y]
  else
    occupy(occupied, x, y + 1)
  end
end

def resting_sand(input, floor = false)
  occupied =
    input
    .map { |rock_vertices| expand_rocks(rock_vertices) }
    .flatten(1)
    .group_by(&:first)
    .transform_values do |positions|
      positions.map { |(_x, y)| y }.to_set
    end
  max_y = input.flatten(1).map { |v| v[1] }.max + 2
  100000.times do |i|
    occupied[i] ||= Set.new
    occupied[i] << max_y
  end if floor
  settled_sand = 0

  begin
    loop do
      x, y = occupy(occupied, 500, 0)
      occupied[x] << y
      settled_sand += 1
    end
  rescue FellIntoOblivion, EntranceBlocked
    settled_sand
  end
end

p resting_sand(input)
p resting_sand(input, true)
