# frozen_string_literal: true

def decode(play)
  if %w[A X].include? play
    :rock
  elsif %w[B Y].include? play
    :paper
  elsif %w[C Z].include? play
    :scissor
  else
    raise "Unknown play: '#{play}'"
  end
end

def compare(a, b)
  return 0 if a == b

  PLAYS[b][a]
end

PLAYS = {
  rock: {
    paper: -1,
    scissor: 1
  },
  paper: {
    scissor: -1,
    rock: 1
  },
  scissor: {
    rock: -1,
    paper: 1
  }
}

def find_what_to_play(other_play, strategy)
  case strategy
  when 'X'
    PLAYS[other_play].key(1)
  when 'Y'
    other_play
  when 'Z'
    PLAYS[other_play].key(-1)
  end
end

ATTRIBUTION = { rock: 1, paper: 2, scissor: 3 }

def calculate_score(strategy)
  my_score = 0
  strategy.each do |game|
    opponent, current_game_strategy = game.split(' ')
    me = find_what_to_play(decode(opponent), current_game_strategy)
    result = compare(decode(opponent), me)
    play_points = ATTRIBUTION[me]
    case result
    when 0
      my_score += 3 + play_points
    when 1
      my_score += 6 + play_points
    when -1
      my_score += 0 + play_points
    else
      raise "Unknown result '#{result}'"
    end
  end
  my_score
end

input = File.read(ARGV.last).split("\n")

puts calculate_score(input)
