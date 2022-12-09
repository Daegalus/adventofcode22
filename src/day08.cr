module Advent::Day08
  def self.run
    puts "[Day 08] Treetop Tree Houe"

    data = File.read("data/day08.txt").strip

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
    puts "  [Part 1] #{part1}"

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
    puts "  [Part 2] #{part2}"
  end
end
