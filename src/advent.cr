require "./day01"
require "./day02"
require "./day03"
require "./day04"
require "./day05"

module Advent
  VERSION = "0.1.0"

  def self.run
    # Advent::Day01.run
    # Advent::Day02.run
    # Advent::Day03.run
    # Advent::Day04.run
    Advent::Day05.part1
    Advent::Day05.part2
  end
end

Advent.run
