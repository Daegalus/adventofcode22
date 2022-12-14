module Advent::Day04
  def self.run
    contains = 0
    overlaps = 0
    
    Advent.input_lines(day: 4, title: "Camp Cleanup") do |line|
      pairs = line.split(",").map { |pair| pair.split("-") }
      pairs = pairs.map { |pair| (pair[0].to_i..pair[1].to_i).to_a }
      
      contains += 1 if (pairs[0] | pairs[1]).size == Math.max(pairs[0].size, pairs[1].size)
      overlaps += 1 if !(pairs[0] & pairs[1]).empty?
    end

    Advent.answer(part: 1, answer: "#{contains}")
    Advent.answer(part: 2, answer: "#{overlaps}")
  end
end
