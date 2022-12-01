class Advent::Day01
    def initialize()
        puts "Day 01 - Calorie Counting"
    end

    def run()
        data = File.read("data/day01.txt").split("\n")
        elves = [] of UInt32
        sum = 0
        data.each do |line|
            if line == ""
                elves << sum.to_u32
                sum = 0
                next
            end
            number = line.to_u32
            sum += number
        end

        maxValue = elves.max
        index = elves.index(maxValue)
        puts "Part 1, Most calories carried: #{maxValue} by Elf #{index}"

        elves.delete_at(index) if index

        maxValue2nd = elves.max
        index2nd = elves.index(maxValue2nd)
        elves.delete_at(index2nd) if index2nd

        maxValue3rd = elves.max
        index3rd = elves.index(maxValue3rd)
        elves.delete_at(index3rd) if index3rd

        puts "Part 2, Top 3 most calories carried: #{maxValue} by Elf #{index}, #{maxValue2nd} by Elf #{index2nd}, #{maxValue3rd} by Elf #{index3rd}"
        puts "Part 2, Top 3 most calories carried: Total #{maxValue + maxValue2nd + maxValue3rd}"
    end
end