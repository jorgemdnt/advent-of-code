# frozen_string_literal: true

def to_crate_row(raw_crate_row)
  raw_crate_row
    .gsub(/(...)./, '\1,')
    .split(',')
    .each_with_index
    .reject { |(v, _)| v.strip == '' }
    .to_h { |v, i| [i + 1, v.find(/\w/)] }
end

def parse_crates(raw_crates)
  crate_stacks = {}
  raw_crates.reverse.drop(1).each do |raw_crate_row|
    crate_row = to_crate_row(raw_crate_row)
    crate_row.each do |stack_id, crate|
      crate_stacks[stack_id] = [] unless crate_stacks.key?(stack_id)
      crate_stacks[stack_id] << crate
    end
  end
  crate_stacks
end

Procedure = Struct.new(:from, :to, :total)

def parse_procedures(raw_procedures)
  raw_procedures.drop(1).map do |procedure|
    match = procedure.match(/move (?<total>\d+) from (?<from>\d+) to (?<to>\d+)/)
    Procedure.new(match[:from].to_i, match[:to].to_i, match[:total].to_i)
  end
end

def parse(input)
  crates, procedures = *input.slice_before('')

  [parse_crates(crates), parse_procedures(procedures)]
end

def crate_mover9000(crate_stacks, procedures)
  procedures.each do |procedure|
    procedure.total.times do
      moved_crate = crate_stacks[procedure.from].pop
      crate_stacks[procedure.to].push(moved_crate)
    end
  end
  crate_stacks.values.map(&:last).join
end

def crate_mover9001(crate_stacks, procedures)
  procedures.each do |procedure|
    stack_length = crate_stacks[procedure.from].length
    moved_crates = crate_stacks[procedure.from].slice!(stack_length - procedure.total, procedure.total)
    crate_stacks[procedure.to].concat(moved_crates)
  end
  crate_stacks.values.map(&:last).join
end

input = File.read(ARGV.last).split("\n")

puts crate_mover9000(*parse(input))
puts crate_mover9001(*parse(input))
