module Advent::Day14

  def self.fill(rocks, ymax, part2 = false)
    (0..).each do |n|
      x, y = 500, 0
      return n if rocks.includes?({x, y})

      blocked = while y <= ymax
        break part2 if y + 1 == ymax
        x, y = { {x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1} }.find { |v| !rocks.includes?(v) } || break true
      end
      return n unless blocked
      rocks << {x, y}
    end
  end

  def self.run
    puts "[Day 14] Regolith Reservoir"
    data = Advent.input(day: 14)

    rocks = Set({Int32, Int32}).new
    ymax = Int32::MIN
    data.each_line do |line|
      line.scan(/(\d+),(\d+)/).map { |m| {m[1].to_i, m[2].to_i} }.each_cons_pair do |(x1, y1), (x2, y2)|
        x1, x2 = {x1, x2}.minmax
        y1, y2 = {y1, y2}.minmax
        (x1..x2).each do |x|
          (y1..y2).each do |y|
            rocks << {x, y}
          end
        end
        ymax = {ymax, y2}.max
      end
    end

    part1 = fill(rocks.clone, ymax)
    part2 = fill(rocks, ymax + 2, true)
   

    Advent.answer(part: 1, answer: part1.to_s)
    Advent.answer(part: 2, answer: part2.to_s)
  end
end
