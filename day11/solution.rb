# frozen_string_literal: true

ITEMS = /Starting items: (?<items>[\d, ]+)/.freeze
OPERATION = /Operation: new = old (?<operator>[+*]) (?<operand>\d+|old)/.freeze
TEST = /Test: divisible by (?<by>\d+)/.freeze
IF_TRUE = /If true: throw to monkey (?<monkey>\d+)/.freeze
IF_FALSE = /If false: throw to monkey (?<monkey>\d+)/.freeze

def parse_monkey(raw_monkey)
  Monkey.new(
    items: raw_monkey.match(ITEMS)[:items].split(', ').map(&:to_i),
    operation: {
      operator: raw_monkey.match(OPERATION)[:operator].to_sym,
      operand: raw_monkey.match(OPERATION)[:operand]
    },
    test: {
      by: raw_monkey.match(TEST)[:by].to_i,
      when_true: raw_monkey.match(IF_TRUE)[:monkey].to_i,
      when_false: raw_monkey.match(IF_FALSE)[:monkey].to_i
    }
  )
end

class Monkey
  attr_accessor :items
  attr_reader :inspections, :test

  def initialize(items:, operation:, test:)
    @items = items
    @operation = operation
    @test = test
    @inspections = 0
  end

  def turn(monkeys, lcm = nil)
    while (item = @items.shift)
      worry_level = inspect(item)
      reduced = reduce_stress(worry_level, lcm)
      monkeys[next_monkey(reduced)].items << reduced
    end
  end

  private

  def inspect(item)
    @inspections += 1
    operand = @operation[:operand] == 'old' ? item : @operation[:operand].to_i
    [item, operand].inject(@operation[:operator])
  end

  def reduce_stress(item, lcm)
    lcm ? item % lcm : item / 3
  end

  def next_monkey(item)
    (item % @test[:by]).zero? ? @test[:when_true] : @test[:when_false]
  end
end

def monkey_business(input)
  monkeys = input.map { |m| parse_monkey(m) }
  20.times do
    monkeys.each do |monkey|
      monkey.turn(monkeys)
    end
  end
  monkeys.map(&:inspections).sort.last(2).inject(:*)
end

def monkey_business_v2(input)
  monkeys = input.map { |m| parse_monkey(m) }
  lcm = monkeys.map { |m| m.test[:by] }.inject(&:lcm)
  10_000.times do
    monkeys.each do |monkey|
      monkey.turn(monkeys, lcm)
    end
  end
  monkeys.map(&:inspections).sort.last(2).inject(:*)
end

input = File.read(ARGV.last).split("\n\n")

puts monkey_business(input)
puts monkey_business_v2(input)
