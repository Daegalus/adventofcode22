module Advent::Day15

  class Point
    getter x : Int32, y : Int32

    def initialize(@x, @y)
    end

    def +(other : Point)
      Point.new(@x + other.x, @y + other.y)
    end

    def manhattan_distance(other : Point)
      (@x - other.x).abs + (@y - other.y).abs
    end

    def diamond(radius : Int32)
      if radius <= 0
        yield self
      else
        (0...radius).each { |i| yield self + Point.new(i, i - radius) }
        (0...radius).each { |i| yield self + Point.new(radius - i, i) }
        (0...radius).each { |i| yield self + Point.new(-i, radius - i) }
        (0...radius).each { |i| yield self + Point.new(i - radius, -i) }
      end
    end

    def to_s(io)
      io << "(#{@x}, #{@y})"
    end
  end

  def self.load_locations(data)
    data.scan(/-?\d+/).each_slice(4).map do |(sx, sy, bx, by)|
      sensor = Point.new(sx[0].to_i, sy[0].to_i)
      beacon = Point.new(bx[0].to_i, by[0].to_i)
      distance = sensor.manhattan_distance(beacon)
      {sensor, beacon, distance}
    end.to_a
  end

  def self.run
    data = Advent.input(day: 15, title: "Beacon Exclusion Zone")    
    locations = load_locations(data)

    part1 = blocked(locations, 2000000)
    part2 = distress_beacon(locations)
    
    Advent.answer(part: 1, answer: part1.to_s)
    Advent.answer(part: 2, answer: part2.to_s)
  end

  def self.blocked(locations, y)
    blocked = [] of Range(Int32, Int32)
    has_beacon = Set(Int32).new
    locations.each do |sensor, beacon, distance|
      has_beacon << beacon.x if beacon.y == y

      horizontal_dist = distance - (sensor.y - y).abs
      xmin = sensor.x - horizontal_dist
      xmax = sensor.x + horizontal_dist
      next unless xmin <= xmax

      overlap, blocked = blocked.partition { |r2| r2.begin <= xmax + 1 && r2.end >= xmin - 1 }
      overlap << (xmin..xmax)
      blocked << (overlap.min_of(&.begin)..overlap.max_of(&.end))
    end

    blocked.sum do |r|
      r.end - r.begin + 1 - has_beacon.count(&.in?(r))
    end
  end

  def self.distress_beacon(locations)
    boundary = 4000000u64
    locations.each do |sensor, _, distance|
      sensor.diamond(distance + 1) do |perimeter|
        next unless 0 <= perimeter.x <= boundary && 0 <= perimeter.y <= boundary
        if locations.all? { |sensor2, _, distance2| perimeter.manhattan_distance(sensor2) > distance2 }
          return boundary * perimeter.x + perimeter.y
        end
      end
    end
  end
end
