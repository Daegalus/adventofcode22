class Point
  getter x : Int32, y : Int32, z : Int32

  def initialize(@x, @y, @z = 0)
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

  def +(other : Point)
    Point.new(@x + other.x, @y + other.y, @z + other.z)
  end

  def -(other : Point)
    Point.new(@x - other.x, @y - other.y, @z - other.z)
  end

  def ==(other : Point)
    @x == other.x && @y == other.y && @z == other.z
  end

  def <(other : Point)
    @y < other.y || (@y == other.y && @x < other.x) || (@y == other.y && @x == other.x && @z < other.z)
  end

  def <=(other : Point)
    @y < other.y || (@y == other.y && @x <= other.x) || (@y == other.y && @x == other.x && @z <= other.z)
  end

  def >(other : Point)
    @y > other.y || (@y == other.y && @x > other.x) || (@y == other.y && @x == other.x && @z > other.z)
  end

  def >=(other : Point)
    @y > other.y || (@y == other.y && @x >= other.x) || (@y == other.y && @x == other.x && @z >= other.z)
  end

  def hash
    @x.hash ^ @y.hash ^ @z.hash
  end

  def to_s(io)
    io << "(#{@x}, #{@y} #{@z ? ", #{@z}" : ""})"
  end
end
