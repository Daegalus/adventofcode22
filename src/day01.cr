module Advent::Day01
    def self.run
        puts "[Day 01] Calorie Counting"

        data = Advent.input(day: 1).split("\n\n")
        elves = data.map do |elf|
            elf.split('\n').map(&.to_i).sum
        end

        maxValue = elves.sort[-1]
        Advent.answer(part: 1, answer: "#{maxValue}")

        top3Values = elves.sort[-3..-1].sum
        Advent.answer(part: 2, answer: "#{top3Values}")
    end
end