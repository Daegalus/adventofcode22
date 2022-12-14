module Advent::Day07
  
  MAX_TOTAL_DIR_SIZE = 100_000
  MAX_FILESYSTEM_SIZE = 70_000_000
  MIN_FREE_SPACE_NEEDED = 30_000_000

  def self.run
    data = Advent.input(day: 7, title: "No Space Left On Device")

    sizes = [] of Int32
    traverse(data.each_line, sizes)

    Advent.answer(part: 1, answer: "#{sizes.reject(&.> MAX_TOTAL_DIR_SIZE).sum}")
    Advent.answer(part: 2, answer: "#{sizes.reject(&.<(sizes.last - (MAX_FILESYSTEM_SIZE-MIN_FREE_SPACE_NEEDED))).min}")   
  end

  def self.traverse(data, sizes : Array(Int32))
    size = 0

    data.each do |line|
      case line[0]
      when 'd' then next
      when '$'
        break if line.ends_with? ".."
        size += traverse(data, sizes) unless line[2] == 'l'
      else size += line.split(" ").first.to_i
      end
    end

    sizes << size
    size
  end
end