require "http"
require "colorize"
require "file_utils"

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
require "./day15"
require "./day16"
require "./day17"
require "./day18"
require "./day19"
require "./day20"
require "./day21"

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
    # Advent::Day14.run
    # Advent::Day15.run
    # Advent::Day16.run
    # Advent::Day17.run
    # Advent::Day18.run
    # Advent::Day19.run
    # Advent::Day20.run
    Advent::Day21.run
  end

  def self.input(day : Int32, title : String)
    input_nostrip(day, title).strip
  end

  def self.input_nostrip(day : Int32, title : String)
    puts "[Day #{day < 10 ? "0#{day}" : day}] #{title.colorize.light_green}".colorize.magenta
    filename = "data/day#{day < 10 ? "0#{day}" : day}.txt"
    download(2022, day)
    File.read(filename)
  end

  def self.input_lines(day : Int32, title : String, &block : String ->)
    puts "[Day #{day < 10 ? "0#{day}" : day}] #{title.colorize.light_green}".colorize.magenta
    filename = "data/day#{day < 10 ? "0#{day}" : day}.txt"
    download(2022, day)
    File.each_line(filename) do |line|
      block.call(line)
    end
  end

  def self.answer(part : Int32, answer : String | Number)
    puts "  [Part #{part}] #{answer.to_s.colorize.yellow}".colorize.light_blue.bold
  end

  def self.download(year : Int32, day : Int32)
    filename = "data/day#{day < 10 ? "0#{day}" : day}.txt"
    return if File.file?(filename)

    token_filename = "../.aoc_session_token"
    unless File.file?(token_filename)
      STDERR.puts "`#{token_filename}` not found! Download `#{filename}` manually".colorize.light_red.bold
      exit 1
    end

    FileUtils.mkdir_p(File.dirname(filename))
    puts "Saving input for day #{day}...".colorize.light_blue

    cookies = HTTP::Cookies{HTTP::Cookie.new("session", File.read(token_filename))}
    headers = HTTP::Headers.new
    cookies.add_request_headers(headers)

    HTTP::Client.get("https://adventofcode.com/#{year}/day/#{day}/input", headers: headers) do |io|
      File.open(filename, "w") do |f|
        IO.copy(io.body_io, f)
      end
    end
  end
end

Advent.run
