class Advent::Day01
    def self.run
        puts "[Day 01] Calorie Counting"

        data = File.read("data/day01.txt").strip.split("\n\n")
        elves = data.map do |elf|
            elf.split('\n').map(&.to_i).sum
        end

        maxValue = elves.sort[-1]
        puts "  [Part 1]: Most calories carried: #{maxValue}"

        top3Values = elves.sort[-3..-1].sum
        puts "  [Part 2]: Top 3 most calories carried: #{top3Values}"
    end
end