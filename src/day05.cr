module Advent::Day05
  struct Instruction
    property qty, from, to
  
    def initialize(@qty : Int32, @from : Int32, @to : Int32)
    end
  end

  def self.part1
    puts "[Day 05] Camp Cleanup"

    stacks, instructions = parse_input

    instructions.each do |instruction|
      next unless instruction
      stacks[instruction.from].pop(instruction.qty).reverse.each do |item|
        stacks[instruction.to].push(item)
      end
    end

    final = stacks.map { |stack| stack.last }.join
    puts " [Part 1] Top Crates: #{final}"
  end

  def self.part2
    stacks, instructions = parse_input

    instructions.each do |instruction|
      next unless instruction
      stacks[instruction.from].pop(instruction.qty).each do |item|
        stacks[instruction.to].push(item)
      end
    end

    final = stacks.map { |stack| stack.last }.join
    puts " [Part 2] Top Crates: #{final}"
  end

  def self.parse_input
    start_state, instructions = File.read("data/day05.txt").split("\n\n")

    start_state = start_state.lines[0..-2].map do |line|
      line.gsub("    ", "$")
        .gsub(/[\s\]\[]/, "")
        .chars
    end

    stacks = start_state.transpose.map do |s|
      s.reject do |item|
        item == '$'
      end.reverse
    end

    instructions = instructions.lines.map do |line|
      match = /move (?<qty>\d+) from (?<from>\d) to (?<to>\d)/.match(line)
      Instruction.new(match["qty"].to_i, match["from"].to_i - 1, match["to"].to_i - 1) if match
    end

    {stacks, instructions}
  end
end
