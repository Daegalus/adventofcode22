module Advent::Day25
  BASE = 5
  REV_DIGITS = {2 => '2', 1 => '1', 0 => '0', -1 => '-', -2 => '='}
  DIGITS = REV_DIGITS.clone.invert.merge({nil => 0})

  def self.run
    data = Advent.input(day: 25, title: "Full of Hot Air")

    part11 = ""
    data.each_line { |line| part11 = add_snafu(part11, line) }
    
    Advent.answer(part: 1, answer: part11)
  end

  def self.add_snafu(s1, s2)
    sum = ""
    i = carry = 0

    s1 = s1.reverse
    s2 = s2.reverse

    while i < s1.size || i < s2.size || carry != 0
      value = carry + DIGITS[s1[i]?] + DIGITS[s2[i]?]
      carry = 0
      value, carry = [value + BASE, -1] if value < -2
      value, carry = [value - BASE, 1] if value > 2
      sum += REV_DIGITS[value]
      i += 1
    end
    sum.reverse
  end
end
