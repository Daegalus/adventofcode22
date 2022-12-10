module Advent::Day06
  def self.run
    puts "[Day 06] Tuning Trouble"

    data = Advent.input(day: 6)

    first_index = ->(x : Int32) { x + data.each_char.cons(x).index!(&.uniq.size.== x) }

    Advent.answer(part: 1, answer: "#{first_index.call(4)}")
    Advent.answer(part: 2, answer: "#{first_index.call(14)}")
  end
end
