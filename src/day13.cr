require "json"

module Advent::Day13

  def self.compare_sides(left : JSON::Any, right : JSON::Any) : Int
    left = left.as_i64? || left.as_a # convert to int or array
    right = right.as_i64? || right.as_a # convert to int or array
    case {left, right}
    in {Int64, Int64} # if both are ints, compare them
      return left <=> right
    in {Int64, Array} # if left is int, right is array, convert left to array
      left = [JSON::Any.new(left)] 
    in {Array, Int64} # if right is int, left is array, convert right to array
      right = [JSON::Any.new(right)]
    in {Array, Array} # if both are arrays, recurse
      # do nothing
    end
  
    left.zip?(right) do |v1, v2|  
      return 1 if v2.nil?
      c = compare_sides(v1, v2) 
      return c unless c == 0
    end
    left.size <=> right.size # compare sizes
  end

  def self.run
    data = Advent.input(day: 13, title: "Distress Signal")

    part1 = data.each_line
    .reject(&.empty?) # remove empty lines
    .map { |line| JSON.parse(line) } # parse as JSON
    .slice(2) # get the array of numbers
    .with_index(offset: 1) # start at 1 for ease of use
    .select { |(left, right), _| compare_sides(left, right) < 0 } # validate the sides, and choose only ones that are valid
    .sum(&.last) # sum it all up

    part2 = data.lines
      .reject(&.empty?) # remove empty lines
      .push("[[2]]", "[[6]]") # add the two packets
      .map { |line| {line, JSON.parse(line)} } # parse as JSON
      .sort! { |(_, left), (_, right)| compare_sides(left, right) } # sort by the side comparison
      .map(&.first) # get the line only for the sorted lines
    part2 = (part2.index!("[[2]]") + 1) * (part2.index!("[[6]]") + 1) # get the index of the two packets, and multiply them together
  
    Advent.answer(part: 1, answer: part1.to_s)
    Advent.answer(part: 2, answer: part2.to_s)
  end
end
