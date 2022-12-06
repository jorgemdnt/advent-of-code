# frozen_string_literal: true

require 'set'

def packet_start(input, packet_size)
  ((packet_size - 1)..(input.length - 1)).each do |i|
    return i + 1 if input[(i - packet_size + 1)..i].to_set.length == packet_size
  end
end

input = File.read(ARGV.last).split("\n").map(&:chars)

puts(input.map { |signal| packet_start(signal, 4) })
puts(input.map { |signal| packet_start(signal, 14) })
