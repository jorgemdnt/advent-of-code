# frozen_string_literal: true

class Array
  def count_until(num)
    count = 0
    each do |n|
      count += 1
      break if n >= num
    end
    count
  end
end

def get_sides(i, j, trees)
  horizontal_size = trees.first.length
  vertical_size = trees.length
  left = trees[i][0..(j - 1)].reverse
  right = trees[i][(j + 1)..(horizontal_size - 1)]
  top = (i - 1).downto(0).map { |other_i| trees[other_i][j] }
  bottom = ((i + 1)..(vertical_size - 1)).map { |other_i| trees[other_i][j] }
  [left, right, top, bottom]
end

def visible?(i, j, trees)
  current_tree_size = trees[i][j]
  sides = get_sides(i, j, trees)
  sides.any? { |side| side.all? { |tree_size| tree_size < current_tree_size } }
end

def count_visible_trees(trees)
  visible_trees = 0
  (1..(trees.length - 2)).each do |i|
    (1..(trees[i].length - 2)).each do |j|
      visible_trees += 1 if visible?(i, j, trees)
    end
  end
  border_trees = trees.first.length * 2 + (trees.length - 2) * 2
  visible_trees + border_trees
end

def calculate_visibility_score(i, j, trees)
  current_tree = trees[i][j]
  sides = get_sides(i, j, trees)
  sides.map { |side| side.count_until(current_tree) }.inject(:*)
end

def find_highest_visibility_score(trees)
  max_score = 0
  (1..(trees.length - 2)).each do |i|
    (1..(trees.first.length - 2)).each do |j|
      curr_score = calculate_visibility_score(i, j, trees)
      max_score = curr_score if curr_score > max_score
    end
  end
  max_score
end

input = File.read(ARGV.last).split("\n").map(&:chars).map { |row| row.map(&:to_i) }

p count_visible_trees(input)
p find_highest_visibility_score(input)
