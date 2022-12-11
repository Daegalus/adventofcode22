module Advent::Day11

  struct Monkey
     property id : UInt64, items : Array(UInt64), operation : String, operation_value : UInt64, test : UInt64, true_throw : UInt64, false_throw : UInt64

    def initialize(@id, @items, @operation, @operation_value, @test, @true_throw, @false_throw)
    end

    def operation(item : UInt64)
      case @operation
      when "+"
        item + @operation_value
      when "*"
        item * @operation_value
      when "^"
        item ** @operation_value
      else
        item
      end
    end
  end
  
  def self.run
    puts "[Day 11] Cathode-Ray Tube"
    data = Advent.input(11).split("\n\n")

    monkeys = load(data)
    Advent.answer(part: 1, answer: looks(monkeys, part: 1).to_s)

    monkeys = load(data)
    mod = monkeys.product(&.test)
    Advent.answer(part: 2, answer: looks(monkeys, mod, times: 10000, part: 2).to_s)
  end

  def self.load(data)
    monkeys = [] of Monkey
    data.each do |line|
      lines = line.split("\n")
      monkey = lines[0].split(" ").last[0].to_u64
      starting_items = lines[1].split(": ").last.split(",").map(&.strip).map(&.to_u64)
      operator, operation_value = lines[2].split("=")[1].split(" ")[-2..]
      if operator == "*" && operation_value == "old"
        operator = "^"
        operation_value = "2"
      end
      operation_value = operation_value.to_u64

      test = lines[3].split(" ").last.to_u64
      true_throw = lines[4].split(" ").last.to_u64
      false_throw = lines[5].split(" ").last.to_u64

      monkeys << Monkey.new(monkey, starting_items, operator, operation_value, test, true_throw, false_throw)
    end
    return monkeys
  end
  
  def self.looks(monkeys : Array(Monkey), mod = 3, times = 20, part : Int32 = 1) : UInt64
    counts = {} of UInt64 => UInt64
    (0...times).each do |_|
      monkeys.each_with_index do |monkey, i|
        counts[monkey.id] ||= 0_u64
        counts[monkey.id] += monkey.items.size
        monkey.items.map!(&.% mod) if part == 2
        monkey.items.map!{|item| monkey.operation(item)}
        monkey.items.map!(&.// mod) if part == 1
        monkey.items.each do |item|
          monkeys[item % monkey.test == 0 ? monkey.true_throw : monkey.false_throw].items << item
        end
        monkey.items.clear
      end
    end

    counts.values.sort[-2..].product
  end
end
