require "./day01"
require "./day02"
require "./day03"
require "./day04"

module Advent
  VERSION = "0.1.0"

  def self.run
    Advent::Day01.run
    Advent::Day02.run
    Advent::Day03.run
    Advent::Day04.run
  end
end

Advent.run
