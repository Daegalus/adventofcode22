require "./support"

module Advent::Day23
  DIRECTIONS = {
    {Point.new(-1, -1), Point.new(-1, 0), Point.new(-1, 1)},
    {Point.new(1, -1), Point.new(1, 0), Point.new(1, 1)},
    {Point.new(-1, -1), Point.new(0, -1), Point.new(1, -1)},
    {Point.new(-1, 1), Point.new(0, 1), Point.new(1, 1)},
  }

  def self.run
    data = Advent.input(day: 23, title: "Unstable Diffusion")

    elves = parse(data)
    part1, part2 = solve(elves)

    Advent.answer(part: 1, answer: part1)
    Advent.answer(part: 1, answer: part2)
  end

  def self.solve(elves : Set(Point))
    proposals = Hash(Point, Array(Point)).new
    propose = [] of Point

    part1 = 0

    (0..).each do |i|
      elves.each do |elf|
        propose.clear

        4.times do |j|
          possible_dirs = DIRECTIONS[(i + j) % 4].map(&.+(elf))
          propose << possible_dirs[1] unless possible_dirs.any?(&.in?(elves))
        end

        next if propose.size == 0 || propose.size == 4

        proposals[propose.first] ||= [] of Point
        proposals[propose.first] << elf
      end

      moved = false

      proposals.each do |place, elfs|
        next if elfs.size > 1
        moved = true

        elves << place
        elves.delete(elfs.first)
      end

      if i == 9
        xmin, xmax = elves.map(&.x).minmax
        ymin, ymax = elves.map(&.y).minmax

        part1 = (xmax - xmin + 1) * (ymax - ymin + 1) - elves.size
      end

      proposals.clear
      next if moved

      return {part1, i + 1}
    end
  end

  def self.parse(data : String) : Set(Point)
    elves = Set(Point).new
    data.each_line.with_index do |line, y|
      line.each_char.with_index do |char, x|
        elves << Point.new(y, x) if char == '#'
      end
    end
    elves
  end
end
