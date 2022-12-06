module Advent::Day06
  def self.run
    puts "[Day 06] Camp Cleanup"

    data = File.read("data/day06.txt").strip

    counter = 4 + data.each_char.cons(4).index { |group| group.uniq.size == group.size }.not_nil!
    counter2 = 14 + data.each_char.cons(14).index { |group| group.uniq.size == group.size }.not_nil!
    
    puts "  [Part 1] #{counter}"
    puts "  [Part 2] #{counter2}"
  end
end
