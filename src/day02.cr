module Advent::Day02
  @@playMap = {
    "A" => "rock",
    "B" => "paper",
    "C" => "scissors",
    "X" => "rock",
    "Y" => "paper",
    "Z" => "scissors",
  }

  @@stratMap = {
    "X" => "lose",
    "Y" => "draw",
    "Z" => "win",
  }

  @@scoring = {
    "rock" => {
      "scissors" => 3,
      "rock"     => 4,
      "paper"    => 8,
    },
    "paper" => {
      "rock"     => 1,
      "paper"    => 5,
      "scissors" => 9,
    },
    "scissors" => {
      "paper"    => 2,
      "scissors" => 6,
      "rock"     => 7,
    },
  }

  @@plays = {
    "rock" => {
      "lose" => "scissors",
      "draw" => "rock",
      "win"  => "paper",
    },
    "paper" => {
      "lose" => "rock",
      "draw" => "paper",
      "win"  => "scissors",
    },
    "scissors" => {
      "lose" => "paper",
      "draw" => "scissors",
      "win"  => "rock",
    },
  }

  def self.run
    data = Advent.input(day: 2, title: "Rock Paper Scissors").split("\n")
    totalScore = 0
    totalScore2 = 0
    data.each do |line|
      opponent_play_code, player_play_code = line.split(" ")

      opponent_play = @@playMap[opponent_play_code]
      player_play = @@playMap[player_play_code]

      totalScore += @@scoring[opponent_play][player_play]

      strategy = @@stratMap[player_play_code]
      player_play2 = @@plays[opponent_play][strategy]

      totalScore2 += @@scoring[opponent_play][player_play2]
    end

    Advent.answer(part: 1, answer: "#{totalScore}")
    Advent.answer(part: 2, answer: "#{totalScore2}")
  end
end
