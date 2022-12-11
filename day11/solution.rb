# frozen_string_literal: true

ITEMS = /Starting items: (?<items>[\d, ]+)/.freeze
OPERATION = /Operation: new = old (?<operator>[+*]) (?<operand>\d+|old)/.freeze
TEST = /Test: divisible by (?<by>\d+)/.freeze
IF_TRUE = /If true: throw to monkey (?<monkey>\d+)/.freeze
IF_FALSE = /If false: throw to monkey (?<monkey>\d+)/.freeze

class Monkey
  attr_accessor :items
  attr_reader :inspections

  def initialize(items:, operation:, test:)
    @items = items
    @operation = operation
    @test = test
    @inspections = 0
  end

  def turn(monkeys)
    while (item = @items.shift)
      new = inspect(item)
      reduced = reduce_stress(new)
      monkeys[test!(reduced)].items << reduced
    end
  end

  private

  def inspect(item)
    @inspections += 1
    operand = @operation[:operand] == 'old' ? item : @operation[:operand].to_i
    [item, operand].inject(@operation[:operator])
  end

  def reduce_stress(item)
    (item / 3.0).floor
  end

  def test!(item)
    (item % @test[:by]).zero? ? @test[:when_true] : @test[:when_false]
  end
end

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

def monkey_business(input)
  monkeys = input.map { |m| parse_monkey(m) }
  20.times do
    monkeys.each do |monkey|
      monkey.turn(monkeys)
    end
  end
  monkeys.map(&:inspections).sort.last(2).inject(:*)
end

input = File.read(ARGV.last).split("\n\n")

puts monkey_business(input)
