# frozen_string_literal: true

def divide_compartiments(rucksack)
  mid = rucksack.length / 2 - 1
  [rucksack[0..mid], rucksack[mid + 1..]]
end

def prioritize(intersection)
  char_byte = intersection.first.ord
  char_byte >= 97 ? char_byte - 96 : char_byte - 65 + 27
end

def sum_priorities_of_repeating_items(rucksacks)
  rucksacks
    .map { |sack| sack.split('') }
    .map { |sack| divide_compartiments(sack) }
    .map { |sack_compartiments| sack_compartiments.inject(:&) }
    .map { |intersection| prioritize(intersection) }
    .sum
end

def sum_priority_of_elf_group_item(rucksacks)
  rucksacks
    .map { |sack| sack.split('') }
    .each_slice(3)
    .map { |elf_group_rucksacks| elf_group_rucksacks.inject(:&) }
    .map { |intersection| prioritize(intersection) }
    .sum
end

input = File.read(ARGV.last).split("\n")

puts sum_priorities_of_repeating_items(input)
puts sum_priority_of_elf_group_item(input)
