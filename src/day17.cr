require "complex"

module Advent::Day17

  class Point
    getter x : Int32, y : Int32

    def initialize(@x, @y)
    end

    def +(other : Point)
      Point.new(@x + other.x, @y + other.y)
    end

    def -(other : Point)
      Point.new(@x - other.x, @y - other.y)
    end

    def ==(other : Point)
      @x == other.x && @y == other.y
    end

    def <(other : Point)
      @y < other.y || (@y == other.y && @x < other.x)
    end

    def <=(other : Point)
      @y < other.y || (@y == other.y && @x <= other.x)
    end

    def >(other : Point)
      @y > other.y || (@y == other.y && @x > other.x)
    end

    def >=(other : Point)
      @y > other.y || (@y == other.y && @x >= other.x)
    end

    def hash
      @x.hash ^ @y.hash
    end

    def to_s(io)
      io << "(#{@x}, #{@y})"
    end
  end

  ROCKS = [
    [Point.new(0, 0), Point.new(1, 0), Point.new(2, 0), Point.new(3, 0)], # ----
    [Point.new(0, 1), Point.new(1, 1), Point.new(2, 1), Point.new(1, 2), Point.new(1, 0)], # +
    [Point.new(0, 0), Point.new(1, 0), Point.new(2, 0), Point.new(2, 1), Point.new(2, 2)], # -|
    [Point.new(0, 0), Point.new(0, 1), Point.new(0, 2), Point.new(0, 3)], # |
    [Point.new(0, 0), Point.new(0, 1), Point.new(1, 0), Point.new(1, 1)], # []
  ]

  def self.summarize(solid : Set(Point))
    o = [-20, -20, -20, -20, -20, -20, -20]
    solid.each do |rock|
      o[rock.x] = {o[rock.x], rock.y}.max
    end

    top = o.max
    o.map! { |x| top - x }
  end

  def self.large_tetris(data : String, loop_count : Int64)
    jets = data.chars.map { |ch| ch == '<' ? -1 : 1 }
    solid = (0..6).map { |x| Point.new(x, -1) }.to_set
    height = 0

    seen = {} of Tuple(Int32, Int64, Array(Int32)) => Tuple(Int64, Int32)

    rc = 0i64
    ri = 0i64
    rock = ROCKS[ri].map(&.+ Point.new(2, 3+height)).to_set
    offset = 0

    while rc < loop_count
      jets.each_with_index do |jet, ji|
        moved = rock.map(&.+ Point.new(jet, 0)).to_set
        rock = moved if moved.all? { |p| 0 <= p.x <= 6 } && (moved & solid).empty?

        moved = rock.map(&.- Point.new(0, 1)).to_set
        if (moved & solid).any?
          solid |= rock
          rc += 1
          height = solid.map(&.y).max + 1
          break if rc >= loop_count
          ri = (ri + 1) % ROCKS.size
          rock = ROCKS[ri].map(&.+ Point.new(2, 3+height)).to_set
          key = {ji, ri, summarize(solid)}
          if seen.has_key?(key)
            lrc, lh = seen[key]
            rem = loop_count - rc
            rep = rem // (rc - lrc)
            offset = rep * (height - lh)
            rc += rep * (rc - lrc)
            seen = {} of Tuple(Int32, Int64, Array(Int32)) => Tuple(Int64, Int32)
          end
          seen[key] = {rc, height}
        else
          rock = moved
        end
      end
    end

    height.to_i64 + offset.to_i64
  end

  def self.complex_tetris(data : String, loop_count : Int32 = 2022)
    jets = data.chars.map { |ch| ch == '<' ? -1 : 1 }
    solid = (0..6).map { |x| Point.new(x, -1) }.to_set
    height = 0

    rc = 0
    ri = 0

    rock = ROCKS[ri].map(&.+ Point.new(2, 3+height)).to_set

    while rc < loop_count
      jets.each do |jet|
        moved = rock.map(&.+ Point.new(jet, 0)).to_set
        rock = moved if moved.all? { |p| 0 <= p.x <= 6 } && (moved & solid).empty?

        moved = rock.map(&.- Point.new(0, 1)).to_set
        if (moved & solid).any?
          solid |= rock
          rc += 1
          height = solid.map(&.y).max + 1
          break if rc >= loop_count
          ri = (ri + 1) % ROCKS.size
          rock = ROCKS[ri].map(&.+ Point.new(2, 3+height)).to_set
        else
          rock = moved
        end
      end
    end

    height.to_i
  end

  def self.run
    data = Advent.input(day: 17, title: "Pyroclastic Flow")

    part1 = complex_tetris(data)
    Advent.answer(part: 1, answer: part1.to_s)

    part2 = large_tetris(data, 1_000_000_000_000)
    Advent.answer(part: 2, answer: part2.to_s)
  end
end
