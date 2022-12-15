# frozen_string_literal: true

require 'set'

Beacon = Struct.new(:x, :y)

class Sensor
  attr_reader :x, :y, :nearest_beacon

  def initialize(x, y, nearest_beacon:)
    @x = x
    @y = y
    @nearest_beacon = nearest_beacon
  end

  def covers?(h, j)
    distance = (@x - h).abs + (@y - j).abs
    distance <= radius
  end

  def beacon?(h, j)
    @nearest_beacon.x == h && @nearest_beacon.y == j
  end

  def radius
    (@x - @nearest_beacon.x).abs + (@y - @nearest_beacon.y).abs
  end
end

input = File.read(ARGV.last).split("\n")

def parse_sensor(raw_sensor)
  match = raw_sensor.match(
    /Sensor at x=(?<x>-?\d+), y=(?<y>-?\d+): closest beacon is at x=(?<beacon_x>-?\d+), y=(?<beacon_y>-?\d+)/
  )
  Sensor.new(
    match[:x].to_i,
    match[:y].to_i,
    nearest_beacon: Beacon.new(match[:beacon_x].to_i, match[:beacon_y].to_i)
  )
end

def parse_input(input)
  input.map { |raw_sensor| parse_sensor(raw_sensor) }
end

def count_positions_without_beacon(sensors, at_y)
  left = sensors.map(&:x).min - sensors.map(&:radius).max
  right = sensors.map(&:x).max + sensors.map(&:radius).max
  (left..right).count do |i|
    sensors.any? do |sensor|
      sensor.covers?(i, at_y) && !sensor.beacon?(i, at_y)
    end
  end
end

def find_uncovered_spot(sensors, width)
  top = sensors.map(&:y).min
  bottom = sensors.map(&:y).max

  (top..bottom).each do |y|
    (0..width).find do |x|
      covered = sensors.any? do |sensor|
        sensor.covers?(x, y)
      end
      return x * 4_000_000 + y unless covered
    end
  end
end

p count_positions_without_beacon(parse_input(input), 10)
p find_uncovered_spot(parse_input(input), 20)

# p count_positions_without_beacon(parse_input(input), 2000000)
# p find_uncovered_spot(parse_input(input), 4000000)
