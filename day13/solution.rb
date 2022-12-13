# frozen_string_literal: true

def compare(a, b)
  if a.is_a?(Array) && b.is_a?(Array)
    result = compare(a.first, b.first)
    result != 0 ? result : compare(a[1..], b[1..])
  elsif a.is_a?(Integer) && b.is_a?(Integer)
    a <=> b
  elsif a.nil? && b.nil?
    0
  elsif a.nil?
    -1
  elsif b.nil?
    1
  elsif a.is_a?(Integer)
    result = compare([a], b)
    result != 0 ? result : compare(nil, b[1..])
  elsif b.is_a?(Integer)
    result = compare(a, [b])
    result != 0 ? result : compare(a[1..], nil)
  end
end

def count_right_order(input)
  input.length.times.select do |i|
    list_a, list_b = *input[i]
    compare(list_a, list_b) == -1
  end.map(&:next).sum
end

def distress_signal_decoder(input)
  distress_signals = [[[2]], [[6]]]
  input << distress_signals
  sorted_items = input.flatten(1).sort do |list_a, list_b|
    compare(list_a, list_b)
  end
  sorted_items.length.times.select do |i|
    distress_signals.include?(sorted_items[i])
  end.map(&:next).inject(:*)
end

input = File.read(ARGV.last).split("\n\n").map { |m| m.split("\n").map { |list| eval(list) } }

p count_right_order(input)
p distress_signal_decoder(input)
