require "./day01"
require "./day02"

module Advent
  VERSION = "0.1.0"

  def self.run
    #day01 = Advent::Day01.new
    #day01.run

    day02 = Advent::Day02.new
    day02.run
  end
end

Advent.run
