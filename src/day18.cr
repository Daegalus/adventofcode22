module Advent::Day18

  OFFSETS = [
    { 0, 0, 0.5 },
    { 0, 0.5, 0 },
    { 0.5, 0, 0 },
    { 0, 0, -0.5 },
    { 0, -0.5, 0 },
    { -0.5, 0, 0 },
  ]

  def self.run
    data = Advent.input(day: 18, title: "Boiling Boulders")

    part1 = surface_area(data)
    Advent.answer(part: 1, answer: part1.to_s)

    part2 = no_air(data)
    Advent.answer(part: 2, answer: part2.to_s)
  end

  def self.surface_area(data : String)
    faces = {} of Tuple(Int32 | Float64, Int32 | Float64, Int32 | Float64) => Int32

    data.each_line do |line|
      x, y, z = line.split(",").map(&.to_i)

      OFFSETS.each do |dx, dy, dz|
        k = {x + dx, y + dy, z + dz}
        faces[k] = 0 unless faces.has_key?(k)
        faces[k] += 1
      end
    end

    faces.values.count(1)
  end

  def self.no_air(data)
    faces = {} of Tuple(Int32 | Float64, Int32 | Float64, Int32 | Float64) => Int32

    mx = my = mz = Float64::INFINITY
    ox = oy = oz = -Float64::INFINITY

    droplets = Set(Tuple(Float64|Int32,Float64|Int32,Float64|Int32)).new

    data.each_line do |line|
      x, y, z = line.split(",").map(&.to_i)
      droplets.add({x, y, z})

      mx = {x, mx}.min
      my = {y, my}.min
      mz = {z, mz}.min

      ox = {x, ox}.max
      oy = {y, oy}.max
      oz = {z, oz}.max

      OFFSETS.each do |dx, dy, dz|
        k = {x + dx, y + dy, z + dz}
        faces[k] = 0 unless faces.has_key?(k)
        faces[k] += 1
      end
    end

    mx -= 1
    my -= 1
    mz -= 1
    ox += 1
    oy += 1
    oz += 1

    queue = Deque(Tuple(Float64|Int32,Float64|Int32,Float64|Int32)).new([{mx, my, mz}])
    air = Set(Tuple(Float64|Int32,Float64|Int32,Float64|Int32)).new([{mx, my, mz}])

    while cell = queue.shift?
      x, y, z = cell

      OFFSETS.each do |dx, dy, dz|
        nx, ny, nz = k = {x + dx * 2, y + dy * 2, z + dz * 2}

        next unless mx <= nx <= ox && my <= ny <= oy && mz <= nz <= oz
        next if air.includes?(k) || droplets.includes?(k)

        air << k
        queue << k
      end
    end

    free = Set(Tuple(Float64|Int32,Float64|Int32,Float64|Int32)).new

    air.each do |x, y, z|
      OFFSETS.each do |dx, dy, dz|
        free << {x + dx, y + dy, z + dz}
      end
    end

    (faces.keys.to_a & free.to_a).size
  end
end
