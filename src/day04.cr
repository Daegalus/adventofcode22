class Advent::Day04
  def self.run
    puts "[Day 04] Camp Cleanup"

    contains = 0
    overlaps = 0
    
    File.each_line("data/day04.txt") do |line|
      pairs = line.split(",").map { |pair| pair.split("-") }
      pairs = pairs.map { |pair| (pair[0].to_i..pair[1].to_i).to_a }
      
      contains += 1 if (pairs[0] | pairs[1]).size == Math.max(pairs[0].size, pairs[1].size)
      overlaps += 1 if !(pairs[0] & pairs[1]).empty?
    end

    puts "  [Part 1] Contains: #{contains}"
    puts "  [Part 2] Overlap: #{overlaps}"
  end
end
