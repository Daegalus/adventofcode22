module Advent::Day06
  def self.run
    puts "[Day 06] Camp Cleanup"

    data = File.read("data/day06.txt").strip

    first_index = ->(x : Int32) { x + data.each_char.cons(x).index!(&.uniq.size.== x) }

    puts "  [Part 1] #{first_index.call(4)}"
    puts "  [Part 2] #{first_index.call(14)}"
  end
end
