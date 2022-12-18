module Advent::Day10
  def self.run
    data = Advent.input(day: 10, title: "Cathode-Ray Tube")

    accumulated = data.each_line
      .flat_map { |line| line == "noop" ? [0] : [0, line[5..].to_i] }
      .accumulate(1)
      .with_index.to_a

    part1 = accumulated
      .select { |_, i| i % 40 == 19 } # 20, 60, 100, 140, 180, 220, -1 for 0 based array
      .sum { |x, i| x * (i + 1) }

    part2 = accumulated
      .join { |x, i| "#{x - 1 <= i % 40 <= x + 1 ? '#' : '.'}#{'\n' if i % 40 == 39}" }

    Advent.answer(part: 1, answer: part1.to_s)
    Advent.answer(part: 2, answer: "\n#{part2}")
  end
end
