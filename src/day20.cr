module Advent::Day20
  def self.run
    data = Advent.input(day: 20, title: "Grove Positioning System")

    part1 = solve(data)
    Advent.answer(part: 1, answer: part1)

    part2 = solve(data, 811589153, 10)
    Advent.answer(part: 2, answer: part2)
  end

  def self.solve(data : String, key = 1, times = 1)
    numbers = data.lines.map(&.to_i64.* key)
    indices = (0...numbers.size).to_a

    (indices * times).each do |i|
      j = indices.index(i).not_nil!
      indices.delete_at(j)
      indices.insert((j.to_i64 + numbers[i]) % indices.size, i)
    end

    zero_loc = indices.index(numbers.index(0)).not_nil!
    (1..3).map { |i| numbers[indices[(zero_loc + i * 1000) % numbers.size]] }.sum
  end
end
