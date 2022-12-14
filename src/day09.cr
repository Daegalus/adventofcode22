module Advent::Day09
  DIRS = {
      "U" => Point.new(0, -1),
      "D" => Point.new(0, 1),
      "L" => Point.new(-1, 0),
      "R" => Point.new(1, 0),
    }

  record Point, x : Int32, y : Int32 do
    def +(other : Point)
      Point.new(x + other.x, y + other.y)
    end

    def -(other : Point)
      Point.new(x - other.x, y - other.y)
    end

    def x=(value : Int32)
      @x = value
    end

    def y=(value : Int32)
      @y = value
    end
  end

  def self.run
    data = Advent.input(day: 9, title: "Rope Bridge")

    ts = Array.new(10) { Point.new(0, 0)}
    visited = Set{ Point.new(0, 0) }
    visited2 = Set{ Point.new(0, 0) }

    data.scan(/([UDLR]) (\d+)/) do |m|
      dp = DIRS[m[1]]
      m[2].to_i.times do
        ts.map_with_index! do |tp, i|
          if i == 0
            tp + dp
          else
            hp = ts[i - 1]
            diff = tp - hp
            if diff.x.abs >= 2 || diff.y.abs >= 2
              tp.x -= diff.x.sign
              tp.y -= diff.y.sign
            end
            tp
          end
        end
        visited << ts[1]
        visited2 << ts[-1]
      end
    end
    Advent.answer(part: 1, answer: visited.size.to_s)
    Advent.answer(part: 2, answer: visited2.size.to_s)
  end
end
