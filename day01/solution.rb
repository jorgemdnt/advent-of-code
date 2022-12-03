# frozen_string_literal: true

def find_elf_with_most_calories(foods)
  current = 0
  elf_packages = []
  foods.each_with_index do |food, idx|
    current += food.to_i
    if food == '' || idx == foods.length - 1
      elf_packages << current
      current = 0
    end
  end
  elf_packages.sort.last(3).sum
end

input = []
$stdin.each_line do |line|
  input << line.chomp
end

puts find_elf_with_most_calories(input)
