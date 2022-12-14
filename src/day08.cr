module Advent::Day08
  def self.run
    data = Advent.input(day: 8, title: "Treetop Tree House")

    grid = data.lines.map(&.chars)
    xmax = grid[0].size - 1
    ymax = grid.size - 1

    part1 = grid.each_with_index.sum do |row, y|
      row.each_with_index.count do |cell, x|
        (x+1).upto(xmax).all? { |x2| row[x2] < cell } ||
        (x-1).downto(0).all? { |x2| row[x2] < cell } ||
        (y+1).upto(ymax).all? { |y2| grid[y2][x] < cell } ||
        (y-1).downto(0).all? { |y2| grid[y2][x] < cell }
      end
    end
    Advent.answer(part: 1, answer: part1.to_s)

    part2 = grid.each_with_index.max_of do |row, y|
      row.each_with_index.max_of do |cell, x|
        {
          (x+1).upto(xmax).index { |x2| row[x2] >= cell }.try(&.+ 1) || (xmax-x),
          (x-1).downto(0).index { |x2| row[x2] >= cell }.try(&.+ 1) || x,
          (y+1).upto(ymax).index { |y2| grid[y2][x] >= cell }.try(&.+ 1) || (ymax-y),
          (y-1).downto(0).index { |y2| grid[y2][x] >= cell }.try(&.+ 1) || y,
        }.product
      end
    end
    Advent.answer(part: 2, answer: part2.to_s)
  end
end
