# frozen_string_literal: true

def parse(raw_pair)
  raw_pair.split(',').map { |p| p.split('-').map(&:to_i) }
end

def fully_overlaps?(section_a, section_b)
  section_a[0] <= section_b[0] && section_a[1] >= section_b[1]
end

def count_full_overlaps(raw_pairs)
  raw_pairs
    .map { |p| parse(p) }
    .count { |(a, b)| fully_overlaps?(a, b) || fully_overlaps?(b, a) }
end

def overlaps?(section_a, section_b)
  section_a[0] >= section_b[0] && section_a[0] <= section_b[1] ||
    section_a[1] >= section_b[0] && section_a[1] <= section_b[1]
end

def count_overlaps(raw_pairs)
  raw_pairs
    .map { |p| parse(p) }
    .count { |(a, b)| overlaps?(a, b) || overlaps?(b, a) }
end

input = File.read(ARGV.last).split("\n")

p count_full_overlaps(input)
p count_overlaps(input)
