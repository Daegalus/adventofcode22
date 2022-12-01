require "./day01"

module Advent
  VERSION = "0.1.0"

  def self.run
    day01 = Advent::Day01.new
    day01.run
  end
end

Advent.run
