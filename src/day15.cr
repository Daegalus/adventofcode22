require "./support"

module Advent::Day15
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
    xmin = Int32::MAX
    xmax = Int32::MIN

    locations.each do |sensor, beacon, distance|
      dis = distance - (sensor.y - y).abs
      xmin = {xmin, sensor.x - dis}.min
      xmax = {xmax, sensor.x + dis}.max
    end

    xmax - xmin
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
