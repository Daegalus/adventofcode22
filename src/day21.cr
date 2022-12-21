module Advent::Day21
  def self.run
    data = Advent.input(day: 21, title: "Monkey Math")
    exprs = {} of String => Array(String)

    data.lines.each do |line|
      words = line.split
      puts words if words.includes?("root")
      name = words[0][...-1]
      expr = line.split(':')[1]
      exprs[name] = expr.split
    end

    part1 = find(exprs, "root", -1)
    Advent.answer(part: 1, answer: part1.to_i64)

    part2 = humn(exprs)
    Advent.answer(part: 2, answer: part2.to_i64)
  end

  def self.find(exprs, name, humn_call)
    expr = exprs[name]
    return humn_call if name == "humn" && humn_call >= 0

    begin
      return expr[0].to_i64.not_nil!
    rescue
      e1 = find(exprs, expr[0], humn_call)
      e2 = find(exprs, expr[2], humn_call)
      return e1+e2 if expr[1] == "+"
      return e1*e2 if expr[1] == "*"
      return e1-e2 if expr[1] == "-"
      return e1/e2 if expr[1] == "/"
      raise expr.inspect
    end
  end

  def self.humn(exprs)
    op1 = exprs["root"][0]
    op2 = exprs["root"][2]
    op1, op2 = {op2, op1} if find(exprs, op2, 0) != find(exprs, op2, 1)
    target = find(exprs, op2, 0)

    lo = 0
    hi = 1e20

    while lo < hi
      mid = (lo+hi)//2
      score = target - find(exprs, op1, mid)
      if score < 0
        lo = mid
      elsif score == 0
        return mid
      else
        hi = mid
      end
    end
    raise "nope"
  end

end
