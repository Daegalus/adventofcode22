require "./day01"
require "./day02"
require "./day03"
require "./day04"
require "./day05"
require "./day06"
require "./day07"
require "./day08"
require "./day09"
require "./day10"
require "./day11"
require "./day12"
require "./day13"
require "./day14"

module Advent
  VERSION = "0.1.2"

  def self.run
    # Advent::Day01.run
    # Advent::Day02.run
    # Advent::Day03.run
    # Advent::Day04.run
    # Advent::Day05.run
    # Advent::Day06.run
    # Advent::Day07.run
    # Advent::Day08.run
    # Advent::Day09.run
    # Advent::Day10.run
    # Advent::Day11.run
    # Advent::Day12.run
    # Advent::Day13.run
    Advent::Day14.run
  end

  def self.input(day : Int32)
    input_nostrip(day).strip
  end

  def self.input_nostrip(day : Int32)
    File.read("data/day#{day < 10 ? "0#{day}" : day}.txt")
  end

  def self.input_lines(day : Int32, &block : String ->)
    File.each_line("data/day#{day < 10 ? "0#{day}" : day}.txt") do |line|
      block.call(line)
    end
  end

  def self.answer(part : Int32, answer : String)
    puts "  [Part #{part}] #{answer}"
  end
end

Advent.run
