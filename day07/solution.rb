# frozen_string_literal: true

require 'set'

CD = /\$ cd (?<directory>\w+)/.freeze
CD_BACK = /\$ cd \.\./.freeze
FILE = /(?<size>\d+) (?<name>[\w.]+)/.freeze
DIR = /dir (?<name>\w+)/.freeze

Directory = Struct.new(:parent, :total_size, :files, :dirs)
FileStruct = Struct.new(:name, :file_size)

def build_directories(terminal_output)
  root = Directory.new(
    nil, 0, [].to_set, {}
  )
  current = root
  terminal_output.each do |output|
    if (match = output.match(CD))
      current = current.dirs.fetch(match[:directory])
    elsif (match = output.match(CD_BACK))
      current = current.parent
    elsif (match = output.match(FILE))
      current.files << FileStruct.new(
        match[:name],
        match[:size].to_i
      )
    elsif (match = output.match(DIR))
      current.dirs[match[:name]] = Directory.new(
        current, 0, [].to_set, {}
      )
    end
  end
  root
end

def calculate_total_sizes(directory)
  total_size = directory.files.sum(&:file_size)
  total_size += directory.dirs.to_a.sum { |(_, dir)| calculate_total_sizes(dir) }
  directory.total_size = total_size
  total_size
end

def flatten(dir, acc = [])
  acc << dir
  dir.dirs.each do |(_name, child_dir)|
    flatten(child_dir, acc)
  end
  acc
end

def find_smallest_dirs(root)
  calculate_total_sizes(root)
  flatten(root).select { |dir| dir.total_size <= 100_000 }.sum(&:total_size)
end

def find_deleteable_dir(root)
  calculate_total_sizes(root)
  available_space = 70_000_000
  unused_space = available_space - root.total_size
  space_to_free = 30_000_000 - unused_space

  flatten(root).sort_by(&:total_size).bsearch { |dir| dir.total_size >= space_to_free }.total_size
end

input = File.read(ARGV.last).split("\n")

pp find_smallest_dirs(build_directories(input))
pp find_deleteable_dir(build_directories(input))
