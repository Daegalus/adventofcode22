module Advent::Day03
    def self.run
        puts "[Day 03] Rucksack Reorganization"

        priority = ('a'..'z').zip(1..26).concat(('A'..'Z').zip(27..52)).to_h
        data = File.read("data/day03.txt").strip.split("\n")

        total = data.sum do |line|
            intersection = (line.chars[..line.size//2] & line.chars[line.size//2..]).first
            priority[intersection]
        end

        puts "  [Part 1] Total: #{total}"

        total2 = data.each_slice(3).sum do |lines|
            intersection = lines.map(&.chars).reduce { |a, b| a & b }.first
            priority[intersection]
        end

        puts "  [Part 2] Total: #{total2}"
    end
end