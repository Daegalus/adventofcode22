module Advent::Day09
  DIRS = {
      "U" => {0, -1},
      "D" => {0, 1},
      "L" => {-1, 0},
      "R" => {1, 0}
    }

  def self.run
    puts "[Day 09] Rope Bridge"

    data = File.read("data/day09.txt").strip

    ts = Array.new(10) { {0,0}}
    visited = Set{ {0,0} }
    visited2 = Set{ {0,0} }

    data.scan(/([UDLR]) (\d+)/) do |m|
      dx, dy = DIRS[m[1]]
      m[2].to_i.times do
        ts.map_with_index! do |(tx, ty), i|
          if i == 0
            {tx + dx, ty + dy}
          else
            hx, hy = ts[i - 1]
            if (tx - hx).abs >= 2 || (ty - hy).abs >= 2
              tx -= (tx - hx).sign
              ty -= (ty - hy).sign
            end
            {tx, ty}
          end
        end
        visited << ts[1]
        visited2 << ts[-1]
      end
    end
    puts "  [Part 1] #{visited.size}"
    puts "  [Part 2] #{visited2.size}"
  end
end
